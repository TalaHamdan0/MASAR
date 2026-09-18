import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';

import '../../screens/profile/home_screen.dart';
import '../../screens/career/skill_mirror_screen.dart';
import '../../screens/career/my_cv_screen.dart';
import '../../screens/profile/profile_screen.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: MasarColors.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _navItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'الرئيسية',
              ),

              _navItem(
                context: context,
                index: 1,
                icon: Icons.map_outlined,
                selectedIcon: Icons.map,
                label: 'خارطة الطريق',
              ),

              _navItem(
                context: context,
                index: 2,
                icon: Icons.business_center_outlined,
                selectedIcon: Icons.business_center,
                label: 'الفرص',
              ),

              _navItem(
                context: context,
                index: 3,
                icon: Icons.badge_outlined,
                selectedIcon: Icons.badge,
                label: 'الملف المهني',
              ),

              _navItem(
                context: context,
                index: 4,
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'الملف الشخصي',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          switch (index) {
            case 0:
              // الرئيسية
              if (selectedIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
              break;

            case 1:
              // خارطة الطريق
              if (selectedIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SkillMirrorScreen(),
                  ),
                );
              }
              break;

            case 2:
              // الفرص
              // لاحقًا: نضيف شاشة OpportunitiesScreen
              break;

            case 3:
              // الملف المهني
              if (selectedIndex != 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyCvScreen(),
                  ),
                );
              }
              break;

            case 4:
              // الملف الشخصي
              if (selectedIndex != 4) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 23,
              color: isSelected
                  ? MasarColors.primaryBlue
                  : MasarColors.textSecondary,
            ),

            const SizedBox(height: 3),

            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: isSelected
                    ? MasarColors.primaryBlue
                    : MasarColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}