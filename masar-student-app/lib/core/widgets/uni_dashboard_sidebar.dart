<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
=======
import 'package:flutter/material.dart';

import '../theme/uni_dashboard_theme.dart';
import '../localization/uni_text.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class UniDashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;
<<<<<<< HEAD
=======
  final int pendingApplicationsCount;
  final int unreadNotificationsCount;
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  const UniDashboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
<<<<<<< HEAD
=======
    required this.pendingApplicationsCount,
    required this.unreadNotificationsCount,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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

<<<<<<< HEAD
=======
  Widget _buildBadge(int count, Color color) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: MasarColors.white,
        border: Border(
          left: BorderSide(color: MasarColors.border),
        ),
=======
        color: UniColors.white,
        border: Border(left: BorderSide(color: UniColors.border)),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
<<<<<<< HEAD

=======
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
<<<<<<< HEAD
                    color: MasarColors.lightBlue,
=======
                    color: UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/masar_logo.png',
                      fit: BoxFit.contain,
<<<<<<< HEAD
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.route_rounded,
                          color: MasarColors.primaryBlue,
                          size: 26,
                        );
                      },
=======
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.route_rounded,
                        color: UniColors.primaryBlue,
                        size: 26,
                      ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(
=======
                    UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      'MASAR',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
<<<<<<< HEAD
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    Text(
                      'University Dashboard',
                      style: TextStyle(
                        fontSize: 10,
                        color: MasarColors.textSecondary,
=======
                        color: UniColors.primaryBlue,
                      ),
                    ),
                    UniText(
                      'University Dashboard',
                      style: TextStyle(
                        fontSize: 10,
                        color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
<<<<<<< HEAD

          const SizedBox(height: 35),

=======
          const SizedBox(height: 35),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: menuItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
<<<<<<< HEAD
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Material(
              color: MasarColors.lightGreen,
=======
              itemBuilder: (context, index) => _buildMenuItem(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Material(
              color: UniColors.lightGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onLogout,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
<<<<<<< HEAD
                          color: MasarColors.primaryGreen,
                          size: 21,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: MasarColors.primaryGreen,
=======
                          color: UniColors.primaryGreen,
                          size: 21,
                        ),
                        const SizedBox(width: 12),
                        UniText(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index) {
<<<<<<< HEAD
    final bool isSelected = selectedIndex == index;

    return Material(
      color: isSelected
          ? MasarColors.lightBlue
          : Colors.transparent,
=======
    final isSelected = selectedIndex == index;
    final badgeCount = index == 3
        ? pendingApplicationsCount
        : index == 6
        ? unreadNotificationsCount
        : 0;

    return Material(
      color: isSelected ? UniColors.lightBlue : Colors.transparent,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
<<<<<<< HEAD
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
=======
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            child: Row(
              children: [
                Icon(
                  menuIcons[index],
                  size: 21,
                  color: isSelected
<<<<<<< HEAD
                      ? MasarColors.primaryBlue
                      : MasarColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
=======
                      ? UniColors.primaryBlue
                      : UniColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    menuItems[index],
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
<<<<<<< HEAD
                          ? MasarColors.primaryBlue
                          : MasarColors.textPrimary,
                    ),
                  ),
                ),
                if (index == 3)
                  _buildBadge('18', MasarColors.primaryGreen),
                if (index == 6)
                  _buildBadge('5', MasarColors.error),
=======
                          ? UniColors.primaryBlue
                          : UniColors.textPrimary,
                    ),
                  ),
                ),
                if (badgeCount > 0)
                  _buildBadge(
                    badgeCount,
                    index == 3 ? UniColors.primaryGreen : UniColors.error,
                  ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ],
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
=======
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
}
