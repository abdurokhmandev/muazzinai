import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color tealCyan = Color(0xFF14B8A6);
  static const Color yellowGold = Color(0xFFF59E0B);
  static const Color darkGray = Color(0xFF1F2937);
  static const Color lightGray = Color(0xFFF9FAFB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FA);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryPurple,
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
      fontFamily:
          'Inter', // Defaulting to Inter if available, standard sans-serif otherwise
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        primary: AppColors.primaryPurple,
        secondary: AppColors.tealCyan,
        surface: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.darkGray,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
