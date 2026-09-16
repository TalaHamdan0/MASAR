import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import 'attendance_screen.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        title: const Text('الحضور'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _calendar(context),
          const SizedBox(height: 12),

          _todayStatus(context),
          const SizedBox(height: 20),

          _sectionTitle(context, 'سجل الحضور'),
          const SizedBox(height: 8),

          _attendanceList(context),
        ],
      ),
       bottomNavigationBar: const AppBottomNavBar(
    selectedIndex: 1,
  ),
);
    
  }

  // =========================
  // Calendar
  // =========================

  Widget _calendar(BuildContext context) {
    const days = [
      'السبت',
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
    ];

    const dates = ['20', '21', '22', '23', '24', '25', '26'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.chevron_left,
                  color: MasarColors.textSecondary,
                ),

                const Spacer(),

                Text(
                  'سبتمبر 2026',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const Spacer(),

                const Icon(
                  Icons.chevron_right,
                  color: MasarColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: List.generate(
                days.length,
                (index) => Expanded(
                  child: Column(
                    children: [
                      Text(
                        days[index].substring(0, 2),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dates[index] == '23'
                              ? MasarColors.primaryBlue
                              : Colors.transparent,
                        ),
                        child: Text(
                          dates[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: dates[index] == '23'
                                ? Colors.white
                                : MasarColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Today's Status
  // =========================

  Widget _todayStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MasarColors.lightGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: MasarColors.primaryGreen,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تم تسجيل حضورك اليوم',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MasarColors.darkGreen,
                        fontSize: 14,
                      ),
                ),
                Text(
                  'الأربعاء، 23 سبتمبر 2026',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Section Title
  // =========================

  Widget _sectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('عرض الكل'),
        ),
      ],
    );
  }

  // =========================
  // Attendance List
  // =========================

  Widget _attendanceList(BuildContext context) {
    final attendance = [
      ('الأربعاء', '23 سبتمبر 2026', true),
      ('الثلاثاء', '22 سبتمبر 2026', true),
      ('الاثنين', '21 سبتمبر 2026', false),
      ('الأحد', '20 سبتمبر 2026', true),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        child: Column(
          children: attendance.map((day) {
            final isPresent = day.$3;

            return ListTile(
              contentPadding: EdgeInsets.zero,

              leading: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPresent
                      ? MasarColors.primaryGreen
                      : MasarColors.error,
                ),
              ),

              title: Text(
                day.$1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MasarColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),

              subtitle: Text(
                day.$2,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isPresent
                      ? MasarColors.lightGreen
                      : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPresent ? 'حاضر' : 'غائب',
                  style: TextStyle(
                    color: isPresent
                        ? MasarColors.darkGreen
                        : MasarColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}