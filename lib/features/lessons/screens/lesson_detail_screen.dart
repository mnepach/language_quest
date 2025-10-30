import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../data/models/lesson_model.dart';
import '../providers/lessons_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/mascot_widget.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int _currentSectionIndex = 0;
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;
  int _correctAnswers = 0;
  bool _isQuizMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonsProvider>().loadLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgPrimary,
              AppColors.bgSecondary.withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<LessonsProvider>(
            builder: (context, provider, child) {
              if (provider.status == LessonsStatus.loading) {
                return const LoadingIndicator(message: 'Loading lesson...');
              }

              if (provider.status == LessonsStatus.error) {
                return CustomErrorWidget(
                  message: provider.errorMessage ?? 'Failed to load lesson',
                  onRetry: () => provider.loadLesson(widget.lessonId),
                );
              }

              final lesson = provider.currentLesson;
              final content = provider.currentLessonContent;

              if (lesson == null) {
                return const CustomErrorWidget(
                  message: 'Lesson not found',
                );
              }

              return Column(
                children: [
                  _buildHeader(lesson),
                  _buildProgressBar(content),
                  Expanded(
                    child: _isQuizMode
                        ? _buildQuizContent(content)
                        : _buildLessonContent(content),
                  ),
                  _buildNavigationButtons(lesson, content),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LessonModel lesson) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${lesson.estimatedMinutes} min • ${lesson.experienceReward} XP',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(LessonContent? content) {
    if (content == null) return const SizedBox.shrink();

    final totalSteps = content.sections.length + (content.quiz != null ? 1 : 0);
    final currentStep = _isQuizMode
        ? content.sections.length + 1
        : _currentSectionIndex + 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${((currentStep / totalSteps) * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingS),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            child: LinearProgressIndicator(
              value: currentStep / totalSteps,
              minHeight: AppDimensions.progressBarHeight,
              backgroundColor: AppColors.bgSecondary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonContent(LessonContent? content) {
    if (content == null || content.sections.isEmpty) {
      return const Center(
        child: Text('No content available'),
      );
    }

    final section = content.sections[_currentSectionIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascot
          Center(
            child: MascotWidget(
              emotion: MascotEmotion.happy,
              size: MascotSize.medium,
              message: _currentSectionIndex == 0
                  ? "Let's start learning!"
                  : "Great progress!",
            ),
          ),
          SizedBox(height: AppDimensions.spacingXl),
          // Section Title
          Text(
            section.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: AppDimensions.spacingL),
          // Section Content
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacingL),
              child: Text(
                section.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          if (section.imageUrl != null) ...[
            SizedBox(height: AppDimensions.spacingL),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: Image.network(
                section.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: AppColors.bgSecondary,
                    child: const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  );
                },
              ),
            ),
          ],
          if (section.examples != null && section.examples!.isNotEmpty) ...[
            SizedBox(height: AppDimensions.spacingL),
            Text(
              'Examples:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.spacingM),
            ...section.examples!.map((example) => Card(
              margin: EdgeInsets.only(bottom: AppDimensions.spacingS),
              color: AppColors.accent.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacingM),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.accent,
                      size: AppDimensions.iconM,
                    ),
                    SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: Text(
                        example,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizContent(LessonContent? content) {
    if (content?.quiz == null) {
      return const Center(child: Text('No quiz available'));
    }

    final quiz = content!.quiz!;
    final question = quiz.questions[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascot
          Center(
            child: MascotWidget(
              emotion: _showExplanation
                  ? (_selectedAnswerIndex == question.correctAnswerIndex
                  ? MascotEmotion.celebrating
                  : MascotEmotion.thinking)
                  : MascotEmotion.happy,
              size: MascotSize.medium,
              message: _showExplanation
                  ? (_selectedAnswerIndex == question.correctAnswerIndex
                  ? "Correct! 🎉"
                  : "Let's try again!")
                  : "Choose the correct answer",
            ),
          ),
          SizedBox(height: AppDimensions.spacingXl),
          // Question
          Card(
            color: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${quiz.questions.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingM),
                  Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingL),
          // Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswerIndex == index;
            final isCorrect = index == question.correctAnswerIndex;
            final showResult = _showExplanation;

            Color? backgroundColor;
            Color? borderColor;
            IconData? icon;

            if (showResult) {
              if (isCorrect) {
                backgroundColor = AppColors.success.withOpacity(0.1);
                borderColor = AppColors.success;
                icon = Icons.check_circle;
              } else if (isSelected) {
                backgroundColor = AppColors.error.withOpacity(0.1);
                borderColor = AppColors.error;
                icon = Icons.cancel;
              }
            } else if (isSelected) {
              backgroundColor = AppColors.primary.withOpacity(0.1);
              borderColor = AppColors.primary;
            }

            return GestureDetector(
              onTap: _showExplanation
                  ? null
                  : () {
                setState(() {
                  _selectedAnswerIndex = index;
                });
              },
              child: Card(
                margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  side: BorderSide(
                    color: borderColor ?? Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spacingL),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: borderColor),
                        SizedBox(width: AppDimensions.spacingM),
                      ],
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_showExplanation && question.explanation != null) ...[
            SizedBox(height: AppDimensions.spacingL),
            Card(
              color: AppColors.accent.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacingL),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.accent,
                      size: AppDimensions.iconL,
                    ),
                    SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: Text(
                        question.explanation!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
      LessonModel lesson,
      LessonContent? content,
      ) {
    if (content == null) return const SizedBox.shrink();

    final isLastSection = _currentSectionIndex == content.sections.length - 1;
    final hasQuiz = content.quiz != null;
    final isLastQuestion = hasQuiz &&
        _currentQuestionIndex == content.quiz!.questions.length - 1;

    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentSectionIndex > 0 || _isQuizMode)
            Expanded(
              child: OutlinedButton(
                onPressed: _handleBack,
                child: const Text('Back'),
              ),
            ),
          if (_currentSectionIndex > 0 || _isQuizMode)
            SizedBox(width: AppDimensions.spacingM),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isQuizMode
                  ? (_showExplanation
                  ? _handleNextQuestion
                  : _handleCheckAnswer)
                  : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isQuizMode && !_showExplanation
                    ? AppColors.accent
                    : AppColors.primary,
              ),
              child: Text(_getButtonText(isLastSection, hasQuiz, isLastQuestion)),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(bool isLastSection, bool hasQuiz, bool isLastQuestion) {
    if (_isQuizMode) {
      if (_showExplanation) {
        return isLastQuestion ? 'Finish' : 'Next Question';
      }
      return 'Check Answer';
    }
    if (isLastSection && hasQuiz) {
      return 'Start Quiz';
    }
    if (isLastSection && !hasQuiz) {
      return 'Complete Lesson';
    }
    return 'Next';
  }

  void _handleBack() {
    setState(() {
      if (_isQuizMode) {
        if (_currentQuestionIndex > 0) {
          _currentQuestionIndex--;
          _selectedAnswerIndex = null;
          _showExplanation = false;
        } else {
          _isQuizMode = false;
          _currentSectionIndex =
              context.read<LessonsProvider>().currentLessonContent!.sections.length - 1;
        }
      } else {
        _currentSectionIndex--;
      }
    });
  }

  void _handleNext() {
    final content = context.read<LessonsProvider>().currentLessonContent!;

    setState(() {
      if (_currentSectionIndex < content.sections.length - 1) {
        _currentSectionIndex++;
      } else if (content.quiz != null) {
        _isQuizMode = true;
        _currentQuestionIndex = 0;
        _selectedAnswerIndex = null;
        _showExplanation = false;
      } else {
        _completeLesson();
      }
    });
  }

  void _handleCheckAnswer() {
    if (_selectedAnswerIndex == null) return;

    final quiz = context.read<LessonsProvider>().currentLessonContent!.quiz!;
    final question = quiz.questions[_currentQuestionIndex];

    setState(() {
      _showExplanation = true;
      if (_selectedAnswerIndex == question.correctAnswerIndex) {
        _correctAnswers++;
      }
    });
  }

  void _handleNextQuestion() {
    final quiz = context.read<LessonsProvider>().currentLessonContent!.quiz!;

    setState(() {
      if (_currentQuestionIndex < quiz.questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _showExplanation = false;
      } else {
        _completeLesson();
      }
    });
  }

  Future<void> _completeLesson() async {
    final lesson = context.read<LessonsProvider>().currentLesson!;
    final userId = context.read<AuthProvider>().user!.id;
    final quiz = context.read<LessonsProvider>().currentLessonContent?.quiz;

    int score = 100;
    if (quiz != null) {
      score = ((_correctAnswers / quiz.questions.length) * 100).toInt();
    }

    // TODO: Сохранить прогресс в Firestore
    // await context.read<LessonsProvider>().completeLesson(
    //   userId: userId,
    //   lessonId: lesson.id,
    //   score: score,
    // );

    if (!mounted) return;

    // Показываем диалог с результатами
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MascotWidget(
              emotion: score >= 70
                  ? MascotEmotion.celebrating
                  : MascotEmotion.happy,
              size: MascotSize.medium,
            ),
            SizedBox(height: AppDimensions.spacingL),
            Text(
              'Lesson Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: AppDimensions.spacingM),
            Text(
              'Score: $score%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.spacingL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRewardBadge(
                  icon: Icons.stars,
                  label: '+${lesson.experienceReward} XP',
                  color: AppColors.primary,
                ),
                _buildRewardBadge(
                  icon: Icons.paid,
                  label: '+${lesson.coinsReward}',
                  color: AppColors.coin,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Back to lesson list
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppDimensions.iconL),
          SizedBox(height: AppDimensions.spacingXs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}