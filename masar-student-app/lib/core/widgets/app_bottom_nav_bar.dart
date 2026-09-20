import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
import '../../screens/profile/home_screen.dart';
import '../../screens/career/roadmap_screen.dart';
import '../../screens/training_screens/company_selection_screen.dart';
import '../../screens/career/my_cv_screen.dart';
import '../../screens/profile/profile_screen.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget screen;

    switch (index) {
      // الرئيسية
      case 0:
        screen = const HomeScreen();
        break;

      // خارطة الطريق
      case 1:
        screen = const RoadmapScreen();
        break;

      // التدريب الميداني
      case 2:
        screen = const SelectCompanyScreen();
        break;

      // الملف المهني
      case 3:
        screen = const MyCvScreen();
        break;

      // الملف الشخصي
      case 4:
        screen = const ProfileScreen();
        break;

      default:
        screen = const HomeScreen();
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
      onDestinationSelected: (index) {
        _onItemTapped(context, index);
      },
      backgroundColor: Colors.white,
      indicatorColor: MasarColors.lightBlue,
      elevation: 0,

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'الرئيسية',
        ),

        NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: 'خارطة الطريق',
        ),

        NavigationDestination(
          icon: Icon(Icons.business_center_outlined),
          selectedIcon: Icon(Icons.business_center),
          label: 'التدريب الميداني',
        ),

        NavigationDestination(
          icon: Icon(Icons.badge_outlined),
          selectedIcon: Icon(Icons.badge),
          label: 'الملف المهني',
        ),

        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'الملف الشخصي',
        ),
      ],
    );
  }
}