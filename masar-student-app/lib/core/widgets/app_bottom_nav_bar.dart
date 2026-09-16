import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';

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
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'الرئيسية',
              ),

              _navItem(
                index: 1,
                icon: Icons.map_outlined,
                selectedIcon: Icons.map,
                label: 'خارطة الطريق',
              ),

              _navItem(
                index: 2,
                icon: Icons.business_center_outlined,
                selectedIcon: Icons.business_center,
                label: 'الفرص',
              ),

              _navItem(
                index: 3,
                icon: Icons.badge_outlined,
                selectedIcon: Icons.badge,
                label: 'الملف المهني',
              ),

              _navItem(
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
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          // سيتم ربط التنقل لاحقًا
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