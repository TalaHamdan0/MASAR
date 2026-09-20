import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import 'weekly_report_screen.dart';
import '../../../core/widgets/training_bottom_bar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'التقارير الأسبوعية',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 6),

                Text(
                  'تابع تقارير تدريبك وأكمل التقرير الحالي.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 20),

                // الأسبوع الأول
                _reportCard(
                  context,
                  week: 1,
                  date: '12/09 - 18/09',
                  status: 'مكتمل',
                  completed: true,
                ),

                // الأسبوع الثاني
                _reportCard(
                  context,
                  week: 2,
                  date: '19/09 - 25/09',
                  status: 'مكتمل',
                  completed: true,
                ),

                // الأسبوع الحالي
                _reportCard(
                  context,
                  week: 3,
                  date: '26/09 - 02/10',
                  status: 'بانتظار التسليم',
                  completed: false,
                  current: true,
                ),

                // الأسابيع القادمة
                _reportCard(
                  context,
                  week: 4,
                  date: '03/10 - 09/10',
                  status: 'لم يبدأ',
                  completed: false,
                ),

                _reportCard(
                  context,
                  week: 5,
                  date: '10/10 - 16/10',
                  status: 'لم يبدأ',
                  completed: false,
                ),

                _reportCard(
                  context,
                  week: 6,
                  date: '17/10 - 23/10',
                  status: 'لم يبدأ',
                  completed: false,
                ),
              ],
            ),
          ),
        ),
      ),

      // شريط التنقل الخاص بالتدريب
      bottomNavigationBar: const TrainingBottomBar(
        selectedIndex: 2,
      ),
    );
  }

  Widget _reportCard(
    BuildContext context, {
    required int week,
    required String date,
    required String status,
    required bool completed,
    bool current = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          backgroundColor: completed
              ? MasarColors.lightGreen
              : current
                  ? MasarColors.lightBlue
                  : MasarColors.background,
          child: Icon(
            completed
                ? Icons.check
                : current
                    ? Icons.edit_outlined
                    : Icons.lock_outline,
            color: completed
                ? MasarColors.primaryGreen
                : current
                    ? MasarColors.primaryBlue
                    : MasarColors.textSecondary,
          ),
        ),

        title: Text(
          'تقرير الأسبوع $week',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '$date\n$status',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),

        trailing: current
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: MasarColors.primaryBlue,
              )
            : null,

        onTap: current
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WeeklyReportScreen(
                      week: week,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }
}