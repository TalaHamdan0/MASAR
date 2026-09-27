
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class UniDashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;

  const UniDashboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  static const List<String> menuItems = [
    'الرئيسية',
    'الطلاب',
    'الشركات',
    'طلبات التدريب',
    'التدريبات الحالية',
    'التقارير',
    'الإشعارات',
    'الإعدادات',
  ];

  static const List<IconData> menuIcons = [
    Icons.dashboard_rounded,
    Icons.people_alt_rounded,
    Icons.business_rounded,
    Icons.assignment_rounded,
    Icons.work_rounded,
    Icons.bar_chart_rounded,
    Icons.notifications_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      decoration: BoxDecoration(
        color: MasarColors.white,
        border: Border(
          left: BorderSide(
            color: MasarColors.border,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),

          // Logo + MASAR
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: MasarColors.lightBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/masar_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Icon(
                          Icons.route_rounded,
                          color: MasarColors.primaryBlue,
                          size: 26,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MASAR',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    Text(
                      'University Dashboard',
                      style: TextStyle(
                        fontSize: 10,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          // Menu
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 6,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      onItemSelected(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? MasarColors.lightBlue
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            menuIcons[index],
                            size: 21,
                            color: isSelected
                                ? MasarColors.primaryBlue
                                : MasarColors.textSecondary,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              menuItems[index],
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? MasarColors.primaryBlue
                                    : MasarColors.textPrimary,
                              ),
                            ),
                          ),

                          // طلبات التدريب
                          if (index == 3)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: MasarColors.primaryGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '18',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          // الإشعارات
                          if (index == 6)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: MasarColors.error,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.all(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onLogout,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: MasarColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: MasarColors.primaryGreen,
                      size: 21,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: MasarColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

