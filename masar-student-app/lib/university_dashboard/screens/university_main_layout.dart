import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/state/university_dashboard_preferences.dart';
import '../../core/widgets/uni_dashboard_header.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';
import '../../core/services/university_auth_service.dart';
import '../../core/services/university_settings_service.dart';
import '../../core/services/university_dashboard_service.dart';

import 'university_home_screen.dart';
import 'students_screen.dart';
import 'companies_screen.dart';
import 'applications_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'university_login_screen.dart';

class UniversityMainLayout extends StatefulWidget {
  const UniversityMainLayout({super.key});

  @override
  State<UniversityMainLayout> createState() => _UniversityMainLayoutState();
}

class _UniversityMainLayoutState extends State<UniversityMainLayout> {
  int selectedIndex = 0;
  int pendingApplicationsCount = 0;
  int unreadNotificationsCount = 0;
  bool _isRefreshingBadges = false;
  Timer? _badgeRefreshTimer;

  static const List<String> pageTitles = [
    'الرئيسية',
    'الطلاب',
    'الشركات',
    'طلبات التدريب',
    'التدريبات الحالية',
    'التقارير',
    'الإشعارات',
    'الإعدادات',
  ];

  // These page widgets are intentionally created as fresh (non-const)
  // instances. When language/theme preferences change, the surrounding
  // AnimatedBuilder rebuilds this list. Fresh widget instances make Flutter
  // rebuild each existing page while preserving its State (filters, scroll
  // position, and loaded data), so UniColors and UniText are recalculated
  // immediately without requiring logout/login.
  List<Widget> get pages => [
    UniversityHomeScreen(),
    StudentsScreen(),
    CompaniesScreen(),
    ApplicationsScreen(),
    CurrentTrainingsScreen(),
    ReportsScreen(),
    NotificationsScreen(onCountsChanged: _refreshDashboardBadges),
    SettingsScreen(),
  ];

  String get _staffName =>
      UniversityAuthService.currentStaff?['name']?.toString().trim() ?? '';

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _refreshDashboardBadges();
    _badgeRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refreshDashboardBadges(),
    );
  }

  @override
  void dispose() {
    _badgeRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedPreferences() async {
    try {
      final data = await UniversitySettingsService.fetchSettings();
      final preferences = data['preferences'];
      if (preferences is! Map) return;

      UniversityDashboardPreferences.instance.apply(
        languageCode: preferences['languageCode']?.toString() ?? 'ar',
        themeMode: preferences['themeMode']?.toString() ?? 'LIGHT',
      );
    } catch (_) {
      // Keep the safe default Arabic/light appearance when settings are unavailable.
    }
  }

  Future<void> _refreshDashboardBadges() async {
    if (_isRefreshingBadges || !mounted) return;
    _isRefreshingBadges = true;

    try {
      final counts = await UniversityDashboardService.fetchBadgeCounts();
      if (!mounted) return;

      final pending = counts['pendingApplications'] ?? 0;
      final unread = counts['unreadNotifications'] ?? 0;
      if (pending != pendingApplicationsCount ||
          unread != unreadNotificationsCount) {
        setState(() {
          pendingApplicationsCount = pending;
          unreadNotificationsCount = unread;
        });
      }
    } catch (_) {
      // Keep the last successful counts visible if the API is temporarily unavailable.
    } finally {
      _isRefreshingBadges = false;
    }
  }

  void _selectPage(int index) {
    if (index < 0 || index >= pageTitles.length) return;
    setState(() => selectedIndex = index);
    if (index == 3 || index == 6) {
      _refreshDashboardBadges();
    }
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: UniversityDashboardPreferences.instance.textDirection,
          child: AlertDialog(
            title: const UniText('تسجيل الخروج'),
            content: const UniText(
              'هل أنت متأكد أنك تريد تسجيل الخروج من لوحة التحكم؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const UniText('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await UniversityAuthService.logout();
                  UniversityDashboardPreferences.instance.apply(
                    languageCode: 'ar',
                    themeMode: 'LIGHT',
                  );
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const UniversityLoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const UniText('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UniversityDashboardPreferences.instance,
      builder: (context, _) {
        final preferences = UniversityDashboardPreferences.instance;
        return Directionality(
          textDirection: preferences.textDirection,
          child: Scaffold(
            backgroundColor: UniColors.background,
            body: Row(
              // Keep the sidebar on the right in both Arabic and English layouts.
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: preferences.textDirection,
                    child: Column(
                      children: [
                        UniDashboardHeader(
                          title: pageTitles[selectedIndex],
                          staffName: _staffName,
                          unreadNotificationsCount: unreadNotificationsCount,
                          onNotificationsTap: () => _selectPage(6),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: selectedIndex,
                            children: pages.map((page) {
                              return Container(
                                color: UniColors.background,
                                child: page,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UniDashboardSidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: _selectPage,
                  onLogout: _showLogoutDialog,
                  pendingApplicationsCount: pendingApplicationsCount,
                  unreadNotificationsCount: unreadNotificationsCount,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}