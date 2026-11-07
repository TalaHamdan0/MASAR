import 'package:flutter/material.dart';

import '../theme/uni_dashboard_theme.dart';
import '../localization/uni_text.dart';

class UniDashboardHeader extends StatelessWidget {
  final String title;
  final String staffName;
  final int unreadNotificationsCount;
  final VoidCallback onNotificationsTap;

  const UniDashboardHeader({
    super.key,
    required this.title,
    required this.staffName,
    required this.unreadNotificationsCount,
    required this.onNotificationsTap,
  });

  Widget _countBadge(int count) {
    if (count <= 0) return const SizedBox.shrink();
    return Positioned(
      top: -5,
      right: -5,
      child: Container(
        constraints: const BoxConstraints(minWidth: 17),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: UniColors.error,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UniColors.white, width: 1.5),
        ),
        child: Text(
          count > 99 ? '99+' : '$count',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: UniColors.white,
        border: Border(bottom: BorderSide(color: UniColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: UniText(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: UniColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Material(
            color: UniColors.background,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onNotificationsTap,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: UniColors.textPrimary,
                        size: 22,
                      ),
                    ),
                    _countBadge(unreadNotificationsCount),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: UniColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_rounded,
              color: UniColors.primaryGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          SizedBox(
            width: 175,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniText(
                  staffName.isEmpty ? 'مسؤول التدريب' : staffName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                UniText(
                  'مسؤول التدريب',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
