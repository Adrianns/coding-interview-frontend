import 'package:flutter/material.dart';

import 'app_spacing.dart';
export 'app_spacing.dart';

class AppColors {
  AppColors._();

  static const Color backgroundTeal = Color(0xFFD4F1F4);
  static const Color accentOrange = Color(0xFFF5A623);
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF2D3436);
  static const Color textGrey = Color(0xFF636E72);
  static const Color borderOrange = Color(0xFFF5A623);
}

ThemeData appTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundTeal,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accentOrange,
      primary: AppColors.accentOrange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),
      bodyMedium: TextStyle(color: AppColors.textDark),
      labelSmall: TextStyle(
        color: AppColors.textGrey,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    ),
  );
}
