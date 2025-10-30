import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/lesson_repository.dart';
import 'data/services/progress_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/lessons/providers/lessons_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await FirebaseService.initialize();

  // Инициализация репозиториев и сервисов
  final authRepository = AuthRepository();
  final lessonRepository = LessonRepository();
  final progressService = ProgressService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => LessonsProvider(lessonRepository, progressService),
        ),
      ],
      child: const LanguageQuestApp(),
    ),
  );
}