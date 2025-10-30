// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  level: $enumDecode(_$LessonLevelEnumMap, json['level']),
  type: $enumDecode(_$LessonTypeEnumMap, json['type']),
  experienceReward: (json['experienceReward'] as num).toInt(),
  coinsReward: (json['coinsReward'] as num).toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
  isLocked: json['isLocked'] as bool? ?? false,
  isCompleted: json['isCompleted'] as bool? ?? false,
  progress: (json['progress'] as num?)?.toDouble(),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  thumbnailUrl: json['thumbnailUrl'] as String?,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'level': _$LessonLevelEnumMap[instance.level]!,
      'type': _$LessonTypeEnumMap[instance.type]!,
      'experienceReward': instance.experienceReward,
      'coinsReward': instance.coinsReward,
      'estimatedMinutes': instance.estimatedMinutes,
      'isLocked': instance.isLocked,
      'isCompleted': instance.isCompleted,
      'progress': instance.progress,
      'tags': instance.tags,
      'thumbnailUrl': instance.thumbnailUrl,
      'order': instance.order,
    };

const _$LessonLevelEnumMap = {
  LessonLevel.beginner: 'beginner',
  LessonLevel.intermediate: 'intermediate',
  LessonLevel.advanced: 'advanced',
  LessonLevel.expert: 'expert',
};

const _$LessonTypeEnumMap = {
  LessonType.vocabulary: 'vocabulary',
  LessonType.grammar: 'grammar',
  LessonType.listening: 'listening',
  LessonType.speaking: 'speaking',
  LessonType.reading: 'reading',
  LessonType.writing: 'writing',
};

LessonContent _$LessonContentFromJson(Map<String, dynamic> json) =>
    LessonContent(
      lessonId: json['lessonId'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => LessonSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      quiz: json['quiz'] == null
          ? null
          : Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonContentToJson(LessonContent instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'sections': instance.sections,
      'quiz': instance.quiz,
    };

LessonSection _$LessonSectionFromJson(Map<String, dynamic> json) =>
    LessonSection(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      examples: (json['examples'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LessonSectionToJson(LessonSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'examples': instance.examples,
    };

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
  id: json['id'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  passingScore: (json['passingScore'] as num).toInt(),
);

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
  'id': instance.id,
  'questions': instance.questions,
  'passingScore': instance.passingScore,
};

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
  id: json['id'] as String,
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
  explanation: json['explanation'] as String?,
);

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'explanation': instance.explanation,
    };
