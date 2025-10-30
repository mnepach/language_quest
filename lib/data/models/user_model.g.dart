// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      level: (json['level'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      coins: (json['coins'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      progress: json['progress'] == null
          ? null
          : UserProgress.fromJson(json['progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'level': instance.level,
      'experience': instance.experience,
      'coins': instance.coins,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'progress': instance.progress,
    };

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
      completedLessons: (json['completedLessons'] as num).toInt(),
      totalLessons: (json['totalLessons'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      skillLevels: Map<String, int>.from(json['skillLevels'] as Map),
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'completedLessons': instance.completedLessons,
      'totalLessons': instance.totalLessons,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'skillLevels': instance.skillLevels,
    };
