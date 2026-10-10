
import 'package:flutter/material.dart';

import '../../core/widgets/company_dashboard_sidebar.dart';
import '../../core/widgets/company_dashboard_header.dart';

import 'company_home_screen.dart';
import 'internships_screen.dart';
import 'applicants_screen.dart';
import 'smart_matching_screen.dart';
import 'interviews_screen.dart';
import 'trainees_screen.dart';
import 'evaluations_screen.dart';
import 'company_reports_screen.dart';
import 'company_settings_screen.dart';

class CompanyMainLayout extends StatefulWidget {
  const CompanyMainLayout({super.key});

  @override
  State<CompanyMainLayout> createState() =>
      _CompanyMainLayoutState();
}

class _CompanyMainLayoutState extends State<CompanyMainLayout> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const CompanyHomeScreen(),
    const InternshipsScreen(),
    const ApplicantsScreen(),
    const SmartMatchingScreen(),
    const InterviewsScreen(),
    const TraineesScreen(),
    const EvaluationsScreen(),
    const CompanyReportsScreen(),
    const CompanySettingsScreen(),
  ];

  void _openScreen(int index) {
    if (index < 0 || index >= _screens.length) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // القائمة الجانبية ثابتة
            CompanyDashboardSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: _openScreen,
            ),

            // محتوى الشاشة يتغير حسب الزر المختار
            Expanded(
              child: Column(
                children: [
                  const CompanyDashboardHeader(),

                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: _screens,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
