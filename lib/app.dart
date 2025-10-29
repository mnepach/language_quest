import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

class LanguageQuestApp extends StatelessWidget {
  const LanguageQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Language Quest',
      theme: AppTheme.getTheme(isWeb: kIsWeb),
      routerConfig: AppRouter.router(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
