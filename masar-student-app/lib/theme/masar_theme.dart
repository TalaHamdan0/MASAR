import 'package:flutter/material.dart';

class MasarColors {
  // =========================
  // Primary Colors
  // =========================

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFFEAF3FF);

  // =========================
  // Green Colors
  // =========================

  static const Color primaryGreen = Color(0xFF2EAD72);
  static const Color darkGreen = Color(0xFF16845A);
  static const Color lightGreen = Color(0xFFEAF8F1);

  // =========================
  // Background
  // =========================

  static const Color background = Color(0xFFF8FAFC);
  static const Color white = Colors.white;

  // =========================
  // Text
  // =========================

  static const Color textPrimary = Color(0xFF172033);
  static const Color textSecondary = Color(0xFF6B7280);

  // =========================
  // Other
  // =========================

  static const Color border = Color(0xFFE2E8F0);

  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF2EAD72);
}


class MasarTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // =========================
      // Color Scheme
      // =========================

      colorScheme: ColorScheme.fromSeed(
        seedColor: MasarColors.primaryBlue,
        primary: MasarColors.primaryBlue,
        secondary: MasarColors.primaryGreen,
        surface: MasarColors.white,
      ),

      // =========================
      // General
      // =========================

      scaffoldBackgroundColor: MasarColors.background,

      fontFamily: 'Cairo',

      // =========================
      // App Bar
      // =========================

      appBarTheme: const AppBarTheme(
        backgroundColor: MasarColors.background,
        foregroundColor: MasarColors.textPrimary,
        elevation: 0,
        centerTitle: true,

        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MasarColors.textPrimary,
        ),
      ),

      // =========================
      // Text
      // =========================

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: MasarColors.textPrimary,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: MasarColors.textPrimary,
        ),

        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MasarColors.textPrimary,
        ),

        titleMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MasarColors.textPrimary,
        ),

        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: MasarColors.textPrimary,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: MasarColors.textSecondary,
        ),

        bodySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          color: MasarColors.textSecondary,
        ),
      ),

      // =========================
      // Cards
      // =========================

      cardTheme: CardThemeData(
        color: MasarColors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),

          side: const BorderSide(
            color: MasarColors.border,
            width: 1,
          ),
        ),

        margin: EdgeInsets.zero,
      ),

      // =========================
      // Elevated Button
      // =========================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MasarColors.primaryBlue,
          foregroundColor: Colors.white,

          minimumSize: const Size(
            double.infinity,
            52,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // Filled Button
      // =========================

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: MasarColors.primaryGreen,
          foregroundColor: Colors.white,

          minimumSize: const Size(
            double.infinity,
            52,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // Text Fields
      // =========================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: MasarColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: MasarColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: MasarColors.primaryBlue,
            width: 2,
          ),
        ),

        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: MasarColors.textSecondary,
        ),
      ),

      // =========================
      // Navigation Bar
      // =========================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,

        indicatorColor: MasarColors.lightBlue,

        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme: WidgetStateProperty.all(
          const IconThemeData(
            size: 24,
          ),
        ),
      ),

      // =========================
      // Divider
      // =========================

      dividerTheme: const DividerThemeData(
        color: MasarColors.border,
        thickness: 1,
      ),
    );
  }
}