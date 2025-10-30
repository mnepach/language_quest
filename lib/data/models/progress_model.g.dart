// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyProgress _$DailyProgressFromJson(Map<String, dynamic> json) =>
    DailyProgress(
      date: json['date'] as String,
      lessonsCompleted: (json['lessonsCompleted'] as num).toInt(),
      experienceGained: (json['experienceGained'] as num).toInt(),
      coinsEarned: (json['coinsEarned'] as num).toInt(),
      minutesSpent: (json['minutesSpent'] as num).toInt(),
      streakMaintained: json['streakMaintained'] as bool,
    );

Map<String, dynamic> _$DailyProgressToJson(DailyProgress instance) =>
    <String, dynamic>{
      'date': instance.date,
      'lessonsCompleted': instance.lessonsCompleted,
      'experienceGained': instance.experienceGained,
      'coinsEarned': instance.coinsEarned,
      'minutesSpent': instance.minutesSpent,
      'streakMaintained': instance.streakMaintained,
    };

WeeklyProgress _$WeeklyProgressFromJson(Map<String, dynamic> json) =>
    WeeklyProgress(
      weekStart: json['weekStart'] as String,
      weekEnd: json['weekEnd'] as String,
      totalLessonsCompleted: (json['totalLessonsCompleted'] as num).toInt(),
      totalExperienceGained: (json['totalExperienceGained'] as num).toInt(),
      totalCoinsEarned: (json['totalCoinsEarned'] as num).toInt(),
      totalMinutesSpent: (json['totalMinutesSpent'] as num).toInt(),
      dailyProgress: (json['dailyProgress'] as List<dynamic>)
          .map((e) => DailyProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyProgressToJson(WeeklyProgress instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart,
      'weekEnd': instance.weekEnd,
      'totalLessonsCompleted': instance.totalLessonsCompleted,
      'totalExperienceGained': instance.totalExperienceGained,
      'totalCoinsEarned': instance.totalCoinsEarned,
      'totalMinutesSpent': instance.totalMinutesSpent,
      'dailyProgress': instance.dailyProgress,
    };

LessonProgress _$LessonProgressFromJson(Map<String, dynamic> json) =>
    LessonProgress(
      lessonId: json['lessonId'] as String,
      progress: (json['progress'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool,
      score: (json['score'] as num?)?.toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
      attemptsCount: (json['attemptsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LessonProgressToJson(LessonProgress instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'progress': instance.progress,
      'isCompleted': instance.isCompleted,
      'score': instance.score,
      'completedAt': instance.completedAt?.toIso8601String(),
      'lastAccessedAt': instance.lastAccessedAt.toIso8601String(),
      'attemptsCount': instance.attemptsCount,
    };

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      experienceReward: (json['experienceReward'] as num).toInt(),
      coinsReward: (json['coinsReward'] as num).toInt(),
    );

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'experienceReward': instance.experienceReward,
      'coinsReward': instance.coinsReward,
    };
