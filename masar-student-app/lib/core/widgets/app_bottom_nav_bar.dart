
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
      Icons.home_rounded,
      Icons.map_rounded,
      Icons.business_center_rounded,
      Icons.badge_rounded,
      Icons.person_rounded,
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.white,
        child: Container(
          width: double.infinity,
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
            minimum: const EdgeInsets.only(bottom: 4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final itemWidth = width / labels.length;

                final fontSize = itemWidth < 65
                    ? 9.0
                    : itemWidth < 76
                        ? 10.0
                        : 11.0;

                final iconSize = itemWidth < 65
                    ? 20.0
                    : 23.0;

                return Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: List.generate(
                    labels.length,
                    (index) {
                      final selected =
                          index == selectedIndex;

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
                              onTap: () =>
                                  _onItemTapped(context, index),
                              child: SizedBox(
                                height: 72,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 1,
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    mainAxisSize:
                                        MainAxisSize.min,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        width: itemWidth < 65
                                            ? 38
                                            : 44,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? MasarColors.lightBlue
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Icon(
                                          selected
                                              ? selectedIcons[index]
                                              : icons[index],
                                          color: color,
                                          size: iconSize,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Expanded(
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment:
                                                Alignment.topCenter,
                                            child: Text(
                                              labels[index],
                                              textAlign:
                                                  TextAlign.center,
                                              textDirection:
                                                  TextDirection.rtl,
                                              maxLines: 2,
                                              softWrap: true,
                                              overflow:
                                                  TextOverflow.visible,
                                              textScaler:
                                                  TextScaler.noScaling,
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                height: 1.25,
                                                color: color,
                                                fontWeight: selected
                                                    ? FontWeight.bold
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
