import 'package:flutter/material.dart';

/// In-memory state for the signed-in university dashboard.
/// The database remains the source of truth; this object keeps every
/// dashboard screen in sync after a preference is changed.
class UniversityDashboardPreferences extends ChangeNotifier {
  UniversityDashboardPreferences._();

  static final UniversityDashboardPreferences instance =
      UniversityDashboardPreferences._();

  String _languageCode = 'ar';
  String _themeMode = 'LIGHT';

  String get languageCode => _languageCode;
  String get themeMode => _themeMode;
  bool get isEnglish => _languageCode == 'en';
  bool get isDark => _themeMode == 'DARK';
  ThemeMode get materialThemeMode => isDark ? ThemeMode.dark : ThemeMode.light;
  TextDirection get textDirection =>
      isEnglish ? TextDirection.ltr : TextDirection.rtl;

  void apply({String? languageCode, String? themeMode}) {
    var changed = false;

    if (languageCode != null) {
      final normalized = languageCode.toLowerCase() == 'en' ? 'en' : 'ar';
      if (normalized != _languageCode) {
        _languageCode = normalized;
        changed = true;
      }
    }

    if (themeMode != null) {
      final normalized = themeMode.toUpperCase() == 'DARK' ? 'DARK' : 'LIGHT';
      if (normalized != _themeMode) {
        _themeMode = normalized;
        changed = true;
      }
    }

    if (changed) notifyListeners();
  }
}
