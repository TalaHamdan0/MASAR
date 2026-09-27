
import 'package:flutter/material.dart';

import 'university_login_screen.dart';
import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_header.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';

import 'university_home_screen.dart';
import 'students_screen.dart';
import 'companies_screen.dart';
import 'applications_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // الإعدادات = index 7
  static const int selectedIndex = 7;

  bool applicationNotifications = true;
  bool reportNotifications = true;
  bool trainingNotifications = true;

  void navigateTo(int index) {
    if (index == selectedIndex) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = const UniversityHomeScreen();
        break;

      case 1:
        screen = const StudentsScreen();
        break;

      case 2:
        screen = const CompaniesScreen();
        break;

      case 3:
        screen = const ApplicationsScreen();
        break;

      case 4:
        screen = const CurrentTrainingsScreen();
        break;

      case 5:
        screen = const ReportsScreen();
        break;

      case 6:
        screen = const NotificationsScreen();
        break;

      case 7:
        return;

      default:
        return;
    }

    // توحيد طريقة التنقل مع باقي صفحات الـ Dashboard
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const UniversityLoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Row(
          // مهم جداً حتى يبقى السايد بار على اليمين
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    const UniDashboardHeader(
                      title: 'الإعدادات',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _buildPageTitle(),
                            const SizedBox(height: 24),

                            _buildAccountSection(),
                            const SizedBox(height: 20),

                            _buildNotificationSection(),
                            const SizedBox(height: 20),

                            _buildGeneralSection(),
                            const SizedBox(height: 20),

                            _buildAboutSection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sidebar ثابت على اليمين
            UniDashboardSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: navigateTo,
              onLogout: logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإعدادات',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'إدارة إعدادات بوابة الجامعة وتفضيلات النظام',
          style: TextStyle(
            fontSize: 14,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _settingsCard(
      title: 'الحساب',
      icon: Icons.person_outline_rounded,
      children: [
        _profileRow(
          icon: Icons.person_rounded,
          title: 'مسؤول التدريب',
          value: 'د. محمد العبدالله',
        ),
        const Divider(height: 1),
        _profileRow(
          icon: Icons.badge_outlined,
          title: 'الرقم الوظيفي',
          value: 'UNI-1001',
        ),
        const Divider(height: 1),
        _profileRow(
          icon: Icons.account_balance_outlined,
          title: 'الجامعة',
          value: 'جامعة مسار',
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _settingsCard(
      title: 'الإشعارات',
      icon: Icons.notifications_none_rounded,
      children: [
        _switchTile(
          icon: Icons.assignment_outlined,
          title: 'طلبات التدريب',
          subtitle: 'استلام إشعار عند وصول طلب تدريب جديد',
          value: applicationNotifications,
          onChanged: (value) {
            setState(() {
              applicationNotifications = value;
            });
          },
        ),
        const Divider(height: 1),
        _switchTile(
          icon: Icons.description_outlined,
          title: 'التقارير',
          subtitle: 'التنبيه عند وجود تقرير تدريبي يحتاج إلى مراجعة',
          value: reportNotifications,
          onChanged: (value) {
            setState(() {
              reportNotifications = value;
            });
          },
        ),
        const Divider(height: 1),
        _switchTile(
          icon: Icons.school_outlined,
          title: 'التدريبات',
          subtitle: 'إشعارات حول حالة التدريبات الحالية',
          value: trainingNotifications,
          onChanged: (value) {
            setState(() {
              trainingNotifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGeneralSection() {
    return _settingsCard(
      title: 'الإعدادات العامة',
      icon: Icons.tune_rounded,
      children: [
        _optionTile(
          icon: Icons.language_rounded,
          title: 'لغة النظام',
          subtitle: 'العربية',
          trailing: const Icon(
            Icons.chevron_left_rounded,
            color: MasarColors.textSecondary,
          ),
        ),
        const Divider(height: 1),
        _optionTile(
          icon: Icons.palette_outlined,
          title: 'مظهر النظام',
          subtitle: 'الوضع الفاتح',
          trailing: const Icon(
            Icons.chevron_left_rounded,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _settingsCard(
      title: 'عن النظام',
      icon: Icons.info_outline_rounded,
      children: [
        _optionTile(
          icon: Icons.apps_rounded,
          title: 'منصة مسار',
          subtitle: 'بوابة إدارة ومتابعة برامج التدريب الميداني',
          trailing: const Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: MasarColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: MasarColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: MasarColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: MasarColors.border,
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _profileRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 17,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: MasarColors.textSecondary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 15,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: MasarColors.primaryBlue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MasarColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 17,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: MasarColors.primaryBlue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
