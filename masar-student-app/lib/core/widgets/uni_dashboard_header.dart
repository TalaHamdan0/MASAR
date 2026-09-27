
import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';

class UniDashboardHeader extends StatelessWidget {
  final String title;

  const UniDashboardHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: MasarColors.white,
        border: Border(
          bottom: BorderSide(
            color: MasarColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: MasarColors.textPrimary,
            ),
          ),

          const Spacer(),

          // Notifications
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: MasarColors.textPrimary,
                    size: 22,
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: MasarColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Admin profile
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MasarColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_rounded,
              color: MasarColors.primaryGreen,
              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'د. محمد العبدالله',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: MasarColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'مسؤول التدريب',
                style: TextStyle(
                  fontSize: 10.5,
                  color: MasarColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
