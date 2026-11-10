import 'package:flutter/material.dart';
import '../state/university_dashboard_preferences.dart';

/// Colors used by the university dashboard. The blue/green identity stays
/// the same in both modes; only surfaces, borders and text adapt to dark mode.
class UniColors {
  static bool get _dark => UniversityDashboardPreferences.instance.isDark;

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color primaryGreen = Color(0xFF2EAD72);
  static const Color darkGreen = Color(0xFF16845A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF2EAD72);

  static Color get lightBlue => _dark
      ? const Color(0xFF1E3A5F)
      : const Color(0xFFEAF3FF);
  static Color get lightGreen => _dark
      ? const Color(0xFF173D32)
      : const Color(0xFFEAF8F1);
  static Color get lightError => _dark
      ? const Color(0xFF482A2A)
      : const Color(0xFFFFEEEE);
  static Color get background => _dark
      ? const Color(0xFF111827)
      : const Color(0xFFF8FAFC);
  static Color get white => _dark
      ? const Color(0xFF1F2937)
      : Colors.white;
  static Color get textPrimary => _dark
      ? const Color(0xFFF1F5F9)
      : const Color(0xFF172033);
  static Color get textSecondary => _dark
      ? const Color(0xFFB6C2D1)
      : const Color(0xFF6B7280);
  static Color get border => _dark
      ? const Color(0xFF374151)
      : const Color(0xFFE2E8F0);
}

class UniDashboardTheme {
  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final background = dark
        ? const Color(0xFF111827)
        : const Color(0xFFF8FAFC);
    final surface = dark
        ? const Color(0xFF1F2937)
        : Colors.white;
    final text = dark
        ? const Color(0xFFF1F5F9)
        : const Color(0xFF172033);
    final muted = dark
        ? const Color(0xFFB6C2D1)
        : const Color(0xFF6B7280);
    final border = dark
        ? const Color(0xFF374151)
        : const Color(0xFFE2E8F0);

    final scheme = ColorScheme.fromSeed(
      seedColor: UniColors.primaryBlue,
      brightness: brightness,
      primary: UniColors.primaryBlue,
      secondary: UniColors.primaryGreen,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Cairo',
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UniColors.primaryBlue, width: 2),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Cairo', color: text),
        bodyMedium: TextStyle(fontFamily: 'Cairo', color: muted),
        bodySmall: TextStyle(fontFamily: 'Cairo', color: muted),
        titleLarge: TextStyle(fontFamily: 'Cairo', color: text),
        titleMedium: TextStyle(fontFamily: 'Cairo', color: text),
      ),
    );
  }
}