import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../data/models/lesson_model.dart';
import '../providers/lessons_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_widget.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonsProvider>().loadLessons();
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
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterChips(),
              Expanded(child: _buildLessonsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Lessons',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: AppDimensions.iconXl),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<LessonsProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
          child: Row(
            children: [
              _buildFilterChip(
                label: 'All',
                isSelected: provider.filterLevel == null && provider.filterType == null,
                onTap: () => provider.clearFilters(),
              ),
              SizedBox(width: AppDimensions.spacingS),
              ...LessonType.values.map((type) => Padding(
                padding: EdgeInsets.only(right: AppDimensions.spacingS),
                child: _buildFilterChip(
                  label: _getLessonTypeName(type),
                  isSelected: provider.filterType == type,
                  onTap: () => provider.setTypeFilter(
                    provider.filterType == type ? null : type,
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withOpacity(0.2),
      backgroundColor: AppColors.cardBg,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildLessonsList() {
    return Consumer<LessonsProvider>(
      builder: (context, provider, child) {
        if (provider.status == LessonsStatus.loading) {
          return const LoadingIndicator(message: 'Loading lessons...');
        }

        if (provider.status == LessonsStatus.error) {
          return CustomErrorWidget(
            message: provider.errorMessage ?? 'Failed to load lessons',
            onRetry: () => provider.loadLessons(),
          );
        }

        final lessons = provider.filteredLessons;

        if (lessons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: AppDimensions.iconXxl * 2,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                SizedBox(height: AppDimensions.spacingL),
                Text(
                  'No lessons available',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppDimensions.spacingL),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            return _buildLessonCard(lessons[index]);
          },
        );
      },
    );
  }

  Widget _buildLessonCard(LessonModel lesson) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: InkWell(
        onTap: lesson.isLocked ? null : () {
          // TODO: Navigate to lesson detail
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: lesson.isLocked
                            ? [Colors.grey, Colors.grey.shade400]
                            : [
                          _getLevelColor(lesson.level),
                          _getLevelColor(lesson.level).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Icon(
                      lesson.isLocked ? Icons.lock : _getTypeIcon(lesson.type),
                      color: Colors.white,
                      size: AppDimensions.iconL,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacingM),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          lesson.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Status
                  if (lesson.isCompleted)
                    Container(
                      padding: EdgeInsets.all(AppDimensions.spacingS),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.success,
                        size: AppDimensions.iconM,
                      ),
                    ),
                ],
              ),
              if (lesson.progress != null && lesson.progress! > 0) ...[
                SizedBox(height: AppDimensions.spacingM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                  child: LinearProgressIndicator(
                    value: lesson.progress! / 100,
                    minHeight: AppDimensions.progressBarHeight,
                    backgroundColor: AppColors.bgSecondary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getLevelColor(lesson.level),
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppDimensions.spacingM),
              // Tags
              Row(
                children: [
                  _buildTag(
                    _getLessonLevelName(lesson.level),
                    _getLevelColor(lesson.level),
                  ),
                  SizedBox(width: AppDimensions.spacingS),
                  _buildTag(
                    '${lesson.estimatedMinutes} min',
                    AppColors.textSecondary,
                  ),
                  SizedBox(width: AppDimensions.spacingS),
                  _buildTag(
                    '+${lesson.experienceReward} XP',
                    AppColors.primary,
                  ),
                  SizedBox(width: AppDimensions.spacingS),
                  _buildTag(
                    '+${lesson.coinsReward} coins',
                    AppColors.coin,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getLevelColor(LessonLevel level) {
    switch (level) {
      case LessonLevel.beginner:
        return AppColors.levelBeginner;
      case LessonLevel.intermediate:
        return AppColors.levelIntermediate;
      case LessonLevel.advanced:
        return AppColors.levelAdvanced;
      case LessonLevel.expert:
        return AppColors.levelExpert;
    }
  }

  IconData _getTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.vocabulary:
        return Icons.abc;
      case LessonType.grammar:
        return Icons.edit_note;
      case LessonType.listening:
        return Icons.headphones;
      case LessonType.speaking:
        return Icons.mic;
      case LessonType.reading:
        return Icons.menu_book;
      case LessonType.writing:
        return Icons.edit;
    }
  }

  String _getLessonTypeName(LessonType type) {
    switch (type) {
      case LessonType.vocabulary:
        return 'Vocabulary';
      case LessonType.grammar:
        return 'Grammar';
      case LessonType.listening:
        return 'Listening';
      case LessonType.speaking:
        return 'Speaking';
      case LessonType.reading:
        return 'Reading';
      case LessonType.writing:
        return 'Writing';
    }
  }

  String _getLessonLevelName(LessonLevel level) {
    switch (level) {
      case LessonLevel.beginner:
        return 'Beginner';
      case LessonLevel.intermediate:
        return 'Intermediate';
      case LessonLevel.advanced:
        return 'Advanced';
      case LessonLevel.expert:
        return 'Expert';
    }
  }
}
