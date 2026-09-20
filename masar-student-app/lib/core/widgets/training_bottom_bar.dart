import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../screens/training_screens/training_dashboard_screen.dart';
import '../../screens/training_screens/attendance_screen.dart';
import '../../screens/training_screens/reports_screen.dart';
import '../../screens/training_screens/evaluation_screen.dart';

class TrainingBottomBar extends StatelessWidget {
  final int selectedIndex;

  const TrainingBottomBar({
    super.key,
    required this.selectedIndex,
  });

  void _navigate(
    BuildContext context,
    int index,
  ) {
    if (index == selectedIndex) {
      return;
    }

    Widget screen;

    switch (index) {
      case 0:
        screen = const TrainingDashboardScreen();
        break;

      case 1:
        screen = const AttendanceScreen();
        break;

      case 2:
        screen = const ReportsScreen();
        break;

      case 3:
        screen = const EvaluationScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,

      backgroundColor: Colors.white,

      indicatorColor: MasarColors.lightBlue,

      elevation: 8,

      onDestinationSelected: (index) {
        _navigate(context, index);
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.dashboard_outlined,
          ),
          selectedIcon: Icon(
            Icons.dashboard,
            color: MasarColors.primaryBlue,
          ),
          label: 'لوحة التدريب',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.calendar_month_outlined,
          ),
          selectedIcon: Icon(
            Icons.calendar_month,
            color: MasarColors.primaryBlue,
          ),
          label: 'الحضور',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.description_outlined,
          ),
          selectedIcon: Icon(
            Icons.description,
            color: MasarColors.primaryBlue,
          ),
          label: 'التقارير',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.star_outline,
          ),
          selectedIcon: Icon(
            Icons.star,
            color: MasarColors.primaryBlue,
          ),
          label: 'التقييم',
        ),
      ],
    );
  }
}