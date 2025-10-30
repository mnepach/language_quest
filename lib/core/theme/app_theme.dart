import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

class AppTheme {
  static ThemeData getTheme({required bool isWeb}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBg,
        error: AppColors.error,
      ),

      // Typography - Game style
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: isWeb ? 56 : 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'GameFont',
          color: AppColors.textPrimary,
          shadows: [
            Shadow(
              color: AppColors.secondary.withOpacity(0.5),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        displayMedium: TextStyle(
          fontSize: isWeb ? 48 : 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'GameFont',
          color: AppColors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: isWeb ? 36 : 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'GameFont',
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: isWeb ? 32 : 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'GameFont',
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: isWeb ? 24 : 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: isWeb ? 22 : 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: isWeb ? 18 : 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: isWeb ? 18 : 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: isWeb ? 16 : 14,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: isWeb ? 14 : 12,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: isWeb ? 16 : 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),

      // Button Theme - Game style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? AppDimensions.spacingXxl : AppDimensions.spacingL,
            vertical: isWeb ? AppDimensions.spacingL : AppDimensions.spacingM,
          ),
          minimumSize: Size(
            AppDimensions.buttonMinWidth,
            isWeb ? AppDimensions.buttonHeight : AppDimensions.buttonHeightSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isWeb ? AppDimensions.radiusXl : AppDimensions.radiusL,
            ),
          ),
          elevation: AppDimensions.cardElevation,
          shadowColor: AppColors.primary.withOpacity(0.5),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          foregroundColor: AppColors.primary,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? AppDimensions.spacingXl : AppDimensions.spacingL,
            vertical: isWeb ? AppDimensions.spacingL : AppDimensions.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isWeb ? AppDimensions.radiusXl : AppDimensions.radiusL,
            ),
          ),
          side: const BorderSide(color: AppColors.primary, width: 2),
          foregroundColor: AppColors.primary,
        ),
      ),

      // Card Theme (ИСПРАВЛЕНО: CardTheme -> CardThemeData)
      cardTheme: CardThemeData(
        elevation: AppDimensions.cardElevation,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isWeb ? AppDimensions.radiusXl : AppDimensions.radiusL,
          ),
          side: BorderSide(
            color: AppColors.secondary.withOpacity(0.3),
            width: 2,
          ),
        ),
        margin: EdgeInsets.all(AppDimensions.spacingM),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: TextStyle(
          fontSize: isWeb ? 24 : 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'GameFont',
          color: AppColors.textPrimary,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.bgSecondary,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgSecondary,
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        padding: EdgeInsets.all(AppDimensions.spacingS),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
      ),

      // Dialog Theme (ИСПРАВЛЕНО: DialogTheme -> DialogThemeData)
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        elevation: AppDimensions.cardElevation,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.textSecondary.withOpacity(0.2),
        thickness: 1,
        space: AppDimensions.spacingL,
      ),
    );
  }
}