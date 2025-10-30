import 'package:flutter/foundation.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/repositories/lesson_repository.dart';

enum LessonsStatus { initial, loading, loaded, error }

class LessonsProvider extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  LessonsStatus _status = LessonsStatus.initial;
  List<LessonModel> _lessons = [];
  LessonModel? _currentLesson;
  LessonContent? _currentLessonContent;
  String? _errorMessage;

  // Фильтры
  LessonLevel? _filterLevel;
  LessonType? _filterType;

  LessonsStatus get status => _status;
  List<LessonModel> get lessons => _lessons;
  LessonModel? get currentLesson => _currentLesson;
  LessonContent? get currentLessonContent => _currentLessonContent;
  String? get errorMessage => _errorMessage;
  LessonLevel? get filterLevel => _filterLevel;
  LessonType? get filterType => _filterType;

  LessonsProvider(this._lessonRepository);

  // Загрузить все уроки
  Future<void> loadLessons() async {
    try {
      _status = LessonsStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _lessons = await _lessonRepository.getAllLessons();
      _status = LessonsStatus.loaded;
    } catch (e) {
      _status = LessonsStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  // Загрузить уроки с фильтрами
  Future<void> loadFilteredLessons() async {
    try {
      _status = LessonsStatus.loading;
      _errorMessage = null;
      notifyListeners();

      if (_filterLevel != null) {
        _lessons = await _lessonRepository.getLessonsByLevel(_filterLevel!);
      } else if (_filterType != null) {
        _lessons = await _lessonRepository.getLessonsByType(_filterType!);
      } else {
        _lessons = await _lessonRepository.getAllLessons();
      }

      _status = LessonsStatus.loaded;
    } catch (e) {
      _status = LessonsStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  // Загрузить урок по ID
  Future<void> loadLesson(String lessonId) async {
    try {
      _status = LessonsStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _currentLesson = await _lessonRepository.getLessonById(lessonId);
      _currentLessonContent = await _lessonRepository.getLessonContent(lessonId);
      _status = LessonsStatus.loaded;
    } catch (e) {
      _status = LessonsStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  // Установить фильтр по уровню
  void setLevelFilter(LessonLevel? level) {
    _filterLevel = level;
    _filterType = null;
    loadFilteredLessons();
  }

  // Установить фильтр по типу
  void setTypeFilter(LessonType? type) {
    _filterType = type;
    _filterLevel = null;
    loadFilteredLessons();
  }

  // Очистить фильтры
  void clearFilters() {
    _filterLevel = null;
    _filterType = null;
    loadLessons();
  }

  // Получить отфильтрованные уроки
  List<LessonModel> get filteredLessons {
    var filtered = List<LessonModel>.from(_lessons);

    if (_filterLevel != null) {
      filtered = filtered.where((l) => l.level == _filterLevel).toList();
    }

    if (_filterType != null) {
      filtered = filtered.where((l) => l.type == _filterType).toList();
    }

    return filtered;
  }

  // Получить доступные уроки (незаблокированные)
  List<LessonModel> get availableLessons {
    return _lessons.where((l) => !l.isLocked).toList();
  }

  // Получить завершенные уроки
  List<LessonModel> get completedLessons {
    return _lessons.where((l) => l.isCompleted).toList();
  }

  // Очистить текущий урок
  void clearCurrentLesson() {
    _currentLesson = null;
    _currentLessonContent = null;
    notifyListeners();
  }
}