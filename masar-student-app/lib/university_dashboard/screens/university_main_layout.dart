
import 'package:flutter/material.dart';

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
import 'settings_screen.dart';
import 'university_login_screen.dart';

class UniversityMainLayout extends StatefulWidget {
  const UniversityMainLayout({super.key});

  @override
  State<UniversityMainLayout> createState() =>
      _UniversityMainLayoutState();
}

class _UniversityMainLayoutState
    extends State<UniversityMainLayout> {
  int selectedIndex = 0;

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

  // الصفحات تُبنى مرة واحدة للحفاظ على حالتها عند التنقل.
  late final List<Widget> pages = [
    const UniversityHomeScreen(),
    const StudentsScreen(),
    const CompaniesScreen(),
    const ApplicationsScreen(),
    const CurrentTrainingsScreen(),
    const ReportsScreen(),
    const NotificationsScreen(),
    const SettingsScreen(),
  ];

void _selectPage(int index) {
  if (index < 0 || index >= pages.length) return;

  setState(() {
    selectedIndex = index;
  });
}


  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text(
              'هل أنت متأكد أنك تريد تسجيل الخروج من لوحة التحكم؟',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const UniversityLoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Row(
          textDirection: TextDirection.ltr,
          children: [
            // منطقة المحتوى: الهيدر ثابت والمحتوى يتبدل.
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    UniDashboardHeader(
                      title: pageTitles[selectedIndex],
                    ),
                    
                    Expanded(
  child: IndexedStack(
    index: selectedIndex,
    children: pages.map((page) {
      return Container(
        color: MasarColors.background,
        child: page,
      );
    }).toList(),
  ),
),
                  ],
                ),
              ),
            ),

            // السايد بار يبقى موجودًا أثناء التنقل.
            UniDashboardSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: _selectPage,
              onLogout: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }
}
