import 'package:json_annotation/json_annotation.dart';

part 'progress_model.g.dart';

@JsonSerializable()
class DailyProgress {
  final String date;
  final int lessonsCompleted;
  final int experienceGained;
  final int coinsEarned;
  final int minutesSpent;
  final bool streakMaintained;

  DailyProgress({
    required this.date,
    required this.lessonsCompleted,
    required this.experienceGained,
    required this.coinsEarned,
    required this.minutesSpent,
    required this.streakMaintained,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) =>
      _$DailyProgressFromJson(json);

  Map<String, dynamic> toJson() => _$DailyProgressToJson(this);
}

@JsonSerializable()
class WeeklyProgress {
  final String weekStart;
  final String weekEnd;
  final int totalLessonsCompleted;
  final int totalExperienceGained;
  final int totalCoinsEarned;
  final int totalMinutesSpent;
  final List<DailyProgress> dailyProgress;

  WeeklyProgress({
    required this.weekStart,
    required this.weekEnd,
    required this.totalLessonsCompleted,
    required this.totalExperienceGained,
    required this.totalCoinsEarned,
    required this.totalMinutesSpent,
    required this.dailyProgress,
  });

  factory WeeklyProgress.fromJson(Map<String, dynamic> json) =>
      _$WeeklyProgressFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyProgressToJson(this);

  double get averageDailyMinutes =>
      dailyProgress.isEmpty ? 0 : totalMinutesSpent / dailyProgress.length;
}

@JsonSerializable()
class LessonProgress {
  final String lessonId;
  final double progress;
  final bool isCompleted;
  final int? score;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final int attemptsCount;

  LessonProgress({
    required this.lessonId,
    required this.progress,
    required this.isCompleted,
    this.score,
    this.completedAt,
    required this.lastAccessedAt,
    this.attemptsCount = 0,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) =>
      _$LessonProgressFromJson(json);

  Map<String, dynamic> toJson() => _$LessonProgressToJson(this);

  LessonProgress copyWith({
    String? lessonId,
    double? progress,
    bool? isCompleted,
    int? score,
    DateTime? completedAt,
    DateTime? lastAccessedAt,
    int? attemptsCount,
  }) {
    return LessonProgress(
      lessonId: lessonId ?? this.lessonId,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      attemptsCount: attemptsCount ?? this.attemptsCount,
    );
  }
}

@JsonSerializable()
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int experienceReward;
  final int coinsReward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.isUnlocked,
    this.unlockedAt,
    required this.experienceReward,
    required this.coinsReward,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementToJson(this);
}
