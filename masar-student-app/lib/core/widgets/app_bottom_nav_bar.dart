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

    final Widget screen;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const RoadmapScreen();
        break;
      case 2:
        screen = const SelectCompanyScreen();
        break;
      case 3:
        screen = const MyCvScreen();
        break;
      case 4:
        screen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    const labels = [
      'الرئيسية',
      'خارطة\nالطريق',
      'التدريب\nالميداني',
      'الملف\nالمهني',
      'الملف\nالشخصي',
    ];

    const semanticLabels = [
      'الرئيسية',
      'خارطة الطريق',
      'التدريب الميداني',
      'الملف المهني',
      'الملف الشخصي',
    ];

    const icons = [
      Icons.home_outlined,
      Icons.map_outlined,
      Icons.business_center_outlined,
      Icons.badge_outlined,
      Icons.person_outline,
    ];

    const selectedIcons = [
      Icons.home,
      Icons.map,
      Icons.business_center,
      Icons.badge,
      Icons.person,
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.white,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: MasarColors.border),
            ),
          ),
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fontSize =
                    constraints.maxWidth < 360 ? 10.5 : 11.5;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(labels.length, (index) {
                    final selected = index == selectedIndex;
                    final color = selected
                        ? MasarColors.primaryBlue
                        : MasarColors.textSecondary;

                    return Expanded(
                      child: Semantics(
                        selected: selected,
                        button: true,
                        label: semanticLabels[index],
                        excludeSemantics: true,
                        child: Tooltip(
                          message: semanticLabels[index],
                          child: InkWell(
                            onTap: () => _onItemTapped(context, index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 180),
                                    width: 48,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? MasarColors.lightBlue
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      selected
                                          ? selectedIcons[index]
                                          : icons[index],
                                      color: color,
                                      size: 23,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    index == 0
                                        ? '${labels[index]}\n'
                                        : labels[index],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      height: 1.35,
                                      color: color,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}