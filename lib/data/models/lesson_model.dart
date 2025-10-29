import 'package:json_annotation/json_annotation.dart';

part 'lesson_model.g.dart';

enum LessonLevel { beginner, intermediate, advanced, expert }

enum LessonType { vocabulary, grammar, listening, speaking, reading, writing }

@JsonSerializable()
class LessonModel {
  final String id;
  final String title;
  final String description;
  final LessonLevel level;
  final LessonType type;
  final int experienceReward;
  final int coinsReward;
  final int estimatedMinutes;
  final bool isLocked;
  final bool isCompleted;
  final double? progress;
  final List<String> tags;
  final String? thumbnailUrl;
  final int order;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.type,
    required this.experienceReward,
    required this.coinsReward,
    required this.estimatedMinutes,
    this.isLocked = false,
    this.isCompleted = false,
    this.progress,
    this.tags = const [],
    this.thumbnailUrl,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonModelToJson(this);

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    LessonLevel? level,
    LessonType? type,
    int? experienceReward,
    int? coinsReward,
    int? estimatedMinutes,
    bool? isLocked,
    bool? isCompleted,
    double? progress,
    List<String>? tags,
    String? thumbnailUrl,
    int? order,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      type: type ?? this.type,
      experienceReward: experienceReward ?? this.experienceReward,
      coinsReward: coinsReward ?? this.coinsReward,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      order: order ?? this.order,
    );
  }
}

@JsonSerializable()
class LessonContent {
  final String lessonId;
  final List<LessonSection> sections;
  final Quiz? quiz;

  LessonContent({
    required this.lessonId,
    required this.sections,
    this.quiz,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) =>
      _$LessonContentFromJson(json);

  Map<String, dynamic> toJson() => _$LessonContentToJson(this);
}

@JsonSerializable()
class LessonSection {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? audioUrl;
  final List<String>? examples;

  LessonSection({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.audioUrl,
    this.examples,
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) =>
      _$LessonSectionFromJson(json);

  Map<String, dynamic> toJson() => _$LessonSectionToJson(this);
}

@JsonSerializable()
class Quiz {
  final String id;
  final List<QuizQuestion> questions;
  final int passingScore;

  Quiz({
    required this.id,
    required this.questions,
    required this.passingScore,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

@JsonSerializable()
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}
