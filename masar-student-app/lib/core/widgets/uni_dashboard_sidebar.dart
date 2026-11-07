import 'package:flutter/material.dart';

import '../theme/uni_dashboard_theme.dart';
import '../localization/uni_text.dart';

class UniDashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;
  final int pendingApplicationsCount;
  final int unreadNotificationsCount;

  const UniDashboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
    required this.pendingApplicationsCount,
    required this.unreadNotificationsCount,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      decoration: BoxDecoration(
        color: UniColors.white,
        border: Border(left: BorderSide(color: UniColors.border)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: UniColors.lightBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/masar_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.route_rounded,
                        color: UniColors.primaryBlue,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UniText(
                      'MASAR',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: UniColors.primaryBlue,
                      ),
                    ),
                    UniText(
                      'University Dashboard',
                      style: TextStyle(
                        fontSize: 10,
                        color: UniColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: menuItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) => _buildMenuItem(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Material(
              color: UniColors.lightGreen,
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
                          color: UniColors.primaryGreen,
                          size: 21,
                        ),
                        const SizedBox(width: 12),
                        UniText(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: UniColors.primaryGreen,
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
    final isSelected = selectedIndex == index;
    final badgeCount = index == 3
        ? pendingApplicationsCount
        : index == 6
        ? unreadNotificationsCount
        : 0;

    return Material(
      color: isSelected ? UniColors.lightBlue : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  menuIcons[index],
                  size: 21,
                  color: isSelected
                      ? UniColors.primaryBlue
                      : UniColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: UniText(
                    menuItems[index],
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
