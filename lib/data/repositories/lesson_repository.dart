import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получить все уроки
  Future<List<LessonModel>> getAllLessons() async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load lessons: $e');
    }
  }

  // Получить уроки по уровню
  Future<List<LessonModel>> getLessonsByLevel(LessonLevel level) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('level', isEqualTo: level.name)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load lessons by level: $e');
    }
  }

  // Получить уроки по типу
  Future<List<LessonModel>> getLessonsByType(LessonType type) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('type', isEqualTo: type.name)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load lessons by type: $e');
    }
  }

  // Получить урок по ID
  Future<LessonModel?> getLessonById(String lessonId) async {
    try {
      final doc = await _firestore
          .collection('lessons')
          .doc(lessonId)
          .get();

      if (!doc.exists) return null;

      return LessonModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to load lesson: $e');
    }
  }

  // Получить контент урока
  Future<LessonContent?> getLessonContent(String lessonId) async {
    try {
      final doc = await _firestore
          .collection('lesson_content')
          .doc(lessonId)
          .get();

      if (!doc.exists) return null;

      return LessonContent.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to load lesson content: $e');
    }
  }

  // Отметить урок как завершенный
  Future<void> markLessonComplete({
    required String userId,
    required String lessonId,
    required int score,
  }) async {
    try {
      await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('lessons')
          .doc(lessonId)
          .set({
        'lessonId': lessonId,
        'isCompleted': true,
        'progress': 100.0,
        'score': score,
        'completedAt': DateTime.now().toIso8601String(),
        'lastAccessedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to mark lesson complete: $e');
    }
  }

  // Обновить прогресс урока
  Future<void> updateLessonProgress({
    required String userId,
    required String lessonId,
    required double progress,
  }) async {
    try {
      await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('lessons')
          .doc(lessonId)
          .update({
        'progress': progress,
        'lastAccessedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update lesson progress: $e');
    }
  }

  // Stream для отслеживания прогресса уроков пользователя
  Stream<List<LessonModel>> getUserLessonsStream(String userId) {
    return _firestore
        .collection('lessons')
        .orderBy('order')
        .snapshots()
        .asyncMap((snapshot) async {
      final lessons = snapshot.docs
          .map((doc) => LessonModel.fromJson(doc.data()))
          .toList();

      // Загружаем прогресс для каждого урока
      for (var i = 0; i < lessons.length; i++) {
        final progressDoc = await _firestore
            .collection('user_progress')
            .doc(userId)
            .collection('lessons')
            .doc(lessons[i].id)
            .get();

        if (progressDoc.exists) {
          final data = progressDoc.data()!;
          lessons[i] = lessons[i].copyWith(
            progress: (data['progress'] as num?)?.toDouble(),
            isCompleted: data['isCompleted'] as bool? ?? false,
          );
        }
      }

      return lessons;
    });
  }
}
