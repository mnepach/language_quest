import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_model.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Сохранить прогресс урока
  Future<void> saveLessonProgress({
    required String userId,
    required String lessonId,
    required double progress,
    bool isCompleted = false,
    int? score,
  }) async {
    try {
      final data = {
        'lessonId': lessonId,
        'progress': progress,
        'isCompleted': isCompleted,
        'lastAccessedAt': DateTime.now().toIso8601String(),
        'attemptsCount': FieldValue.increment(1),
      };

      if (score != null) {
        data['score'] = score;
      }

      if (isCompleted) {
        data['completedAt'] = DateTime.now().toIso8601String();
      }

      await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('lessons')
          .doc(lessonId)
          .set(data, SetOptions(merge: true));

      // Обновляем общую статистику пользователя
      if (isCompleted) {
        await _updateUserStats(userId, lessonId);
      }
    } catch (e) {
      throw Exception('Failed to save progress: $e');
    }
  }

  // Получить прогресс урока
  Future<LessonProgress?> getLessonProgress({
    required String userId,
    required String lessonId,
  }) async {
    try {
      final doc = await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('lessons')
          .doc(lessonId)
          .get();

      if (!doc.exists) return null;

      return LessonProgress.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get progress: $e');
    }
  }

  // Получить все прогрессы пользователя
  Future<Map<String, LessonProgress>> getAllLessonProgress(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('lessons')
          .get();

      final Map<String, LessonProgress> progressMap = {};

      for (var doc in snapshot.docs) {
        progressMap[doc.id] = LessonProgress.fromJson(doc.data());
      }

      return progressMap;
    } catch (e) {
      throw Exception('Failed to get all progress: $e');
    }
  }

  // Обновить статистику пользователя
  Future<void> _updateUserStats(String userId, String lessonId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userData = await userRef.get();

      if (!userData.exists) return;

      final data = userData.data()!;
      final progress = data['progress'] as Map<String, dynamic>? ?? {};

      // Увеличиваем счетчик завершенных уроков
      final completedLessons = (progress['completedLessons'] as int? ?? 0) + 1;

      // Обновляем данные
      await userRef.update({
        'progress.completedLessons': completedLessons,
        'lastLoginAt': DateTime.now().toIso8601String(),
      });

      // Проверяем streak
      await _updateStreak(userId);
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }

  // Обновить streak (серию дней)
  Future<void> _updateStreak(String userId) async {
    try {
      final today = DateTime.now();
      final todayStr = _formatDate(today);

      // Получаем последнюю дату активности
      final userRef = _firestore.collection('users').doc(userId);
      final userData = await userRef.get();

      if (!userData.exists) return;

      final data = userData.data()!;
      final progress = data['progress'] as Map<String, dynamic>? ?? {};
      final lastActivityDate = progress['lastActivityDate'] as String?;

      int currentStreak = progress['currentStreak'] as int? ?? 0;
      int longestStreak = progress['longestStreak'] as int? ?? 0;

      if (lastActivityDate == null || lastActivityDate != todayStr) {
        // Проверяем, был ли пользователь активен вчера
        final yesterday = today.subtract(const Duration(days: 1));
        final yesterdayStr = _formatDate(yesterday);

        if (lastActivityDate == yesterdayStr) {
          // Продолжаем streak
          currentStreak++;
        } else if (lastActivityDate != todayStr) {
          // Начинаем новый streak
          currentStreak = 1;
        }

        // Обновляем longest streak если нужно
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }

        // Сохраняем данные
        await userRef.update({
          'progress.currentStreak': currentStreak,
          'progress.longestStreak': longestStreak,
          'progress.lastActivityDate': todayStr,
        });

        // Сохраняем дневной прогресс
        await _saveDailyProgress(userId, todayStr);
      }
    } catch (e) {
      throw Exception('Failed to update streak: $e');
    }
  }

  // Сохранить дневной прогресс
  Future<void> _saveDailyProgress(String userId, String dateStr) async {
    try {
      final dailyRef = _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('daily_progress')
          .doc(dateStr);

      final dailyData = await dailyRef.get();

      if (dailyData.exists) {
        // Обновляем существующую запись
        await dailyRef.update({
          'lessonsCompleted': FieldValue.increment(1),
          'minutesSpent': FieldValue.increment(5), // Примерное время
          'streakMaintained': true,
        });
      } else {
        // Создаем новую запись
        await dailyRef.set({
          'date': dateStr,
          'lessonsCompleted': 1,
          'experienceGained': 50,
          'coinsEarned': 10,
          'minutesSpent': 5,
          'streakMaintained': true,
        });
      }
    } catch (e) {
      throw Exception('Failed to save daily progress: $e');
    }
  }

  // Получить недельный прогресс
  Future<WeeklyProgress?> getWeeklyProgress(String userId) async {
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final snapshot = await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('daily_progress')
          .where('date', isGreaterThanOrEqualTo: _formatDate(weekStart))
          .where('date', isLessThanOrEqualTo: _formatDate(weekEnd))
          .get();

      if (snapshot.docs.isEmpty) return null;

      final dailyProgressList = snapshot.docs
          .map((doc) => DailyProgress.fromJson(doc.data()))
          .toList();

      int totalLessons = 0;
      int totalExperience = 0;
      int totalCoins = 0;
      int totalMinutes = 0;

      for (var daily in dailyProgressList) {
        totalLessons += daily.lessonsCompleted;
        totalExperience += daily.experienceGained;
        totalCoins += daily.coinsEarned;
        totalMinutes += daily.minutesSpent;
      }

      return WeeklyProgress(
        weekStart: _formatDate(weekStart),
        weekEnd: _formatDate(weekEnd),
        totalLessonsCompleted: totalLessons,
        totalExperienceGained: totalExperience,
        totalCoinsEarned: totalCoins,
        totalMinutesSpent: totalMinutes,
        dailyProgress: dailyProgressList,
      );
    } catch (e) {
      throw Exception('Failed to get weekly progress: $e');
    }
  }

  // Форматировать дату
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Stream для отслеживания прогресса
  Stream<Map<String, LessonProgress>> watchLessonProgress(String userId) {
    return _firestore
        .collection('user_progress')
        .doc(userId)
        .collection('lessons')
        .snapshots()
        .map((snapshot) {
      final Map<String, LessonProgress> progressMap = {};
      for (var doc in snapshot.docs) {
        progressMap[doc.id] = LessonProgress.fromJson(doc.data());
      }
      return progressMap;
    });
  }
}