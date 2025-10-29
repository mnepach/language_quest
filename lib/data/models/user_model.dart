import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final int level;
  final int experience;
  final int coins;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserProgress? progress;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.level,
    required this.experience,
    required this.coins,
    required this.createdAt,
    this.lastLoginAt,
    this.progress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    int? level,
    int? experience,
    int? coins,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserProgress? progress,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      coins: coins ?? this.coins,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      progress: progress ?? this.progress,
    );
  }
}

@JsonSerializable()
class UserProgress {
  final int completedLessons;
  final int totalLessons;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> skillLevels;

  UserProgress({
    required this.completedLessons,
    required this.totalLessons,
    required this.currentStreak,
    required this.longestStreak,
    required this.skillLevels,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  double get progressPercentage =>
      totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0;
}
