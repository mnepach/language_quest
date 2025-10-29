import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await FirebaseService.initialize();

  // Инициализация репозиториев
  final authRepository = AuthRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
      ],
      child: const LanguageQuestApp(),
    ),
  );
}