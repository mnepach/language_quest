import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/network/api_client.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация API клиента
  final apiClient = ApiClient();

  // Инициализация репозиториев
  final authRepository = AuthRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        // Добавь другие провайдеры здесь
      ],
      child: const LanguageQuestApp(),
    ),
  );
}
