import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import '../../../core/widgets/training_bottom_bar.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        title: const Text('الحضور'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _calendar(context),
            const SizedBox(height: 16),

            _todayStatus(context),
            const SizedBox(height: 20),

            _sectionTitle(context, 'سجل الحضور'),
            const SizedBox(height: 8),

            _attendanceList(context),

            const SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: const TrainingBottomBar(
        selectedIndex: 1,
      ),
    );
  }

  // =========================
  // Calendar
  // =========================

  Widget _calendar(BuildContext context) {
    const days = [
      'س',
      'ح',
      'ن',
      'ث',
      'ر',
      'خ',
      'ج',
    ];

    const dates = [
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
        child: Column(
          children: [
            // Month Header
            Row(
              children: [
                _calendarArrow(
                  Icons.chevron_left,
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      'سبتمبر 2026',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                _calendarArrow(
                  Icons.chevron_right,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Days of week
            Row(
              children: List.generate(
                days.length,
                (index) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        days[index],
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: MasarColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Dates
            Row(
              children: List.generate(
                dates.length,
                (index) {
                  final date = dates[index];

                  final bool isSelected = date == '23';

                  final bool isPresent =
                      date == '20' ||
                      date == '21' ||
                      date == '23';

                  final bool isAbsent = date == '22';

                  return Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? MasarColors.primaryBlue
                                : MasarColors.background,
                            border: Border.all(
                              color: isSelected
                                  ? MasarColors.primaryBlue
                                  : MasarColors.border,
                            ),
                          ),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : MasarColors.textPrimary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Attendance indicator
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPresent
                                ? MasarColors.primaryGreen
                                : isAbsent
                                    ? MasarColors.error
                                    : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _calendarLegend(
                  color: MasarColors.primaryGreen,
                  text: 'حاضر',
                ),
                const SizedBox(width: 20),
                _calendarLegend(
                  color: MasarColors.error,
                  text: 'غائب',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarArrow(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Icon(
        icon,
        size: 20,
        color: MasarColors.textSecondary,
      ),
    );
  }

  Widget _calendarLegend({
    required Color color,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color: MasarColors.darkGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 3),
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

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
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