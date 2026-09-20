import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import '../../../core/widgets/training_bottom_bar.dart';

class TrainingDashboardScreen extends StatelessWidget {
  const TrainingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _header(context),
                const SizedBox(height: 16),
                _motivationCard(context),
                const SizedBox(height: 16),
                _trainingCard(context),
                const SizedBox(height: 16),
                _progressCard(context),
                const SizedBox(height: 16),
                _statistics(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const TrainingBottomBar(
        selectedIndex: 0,
      ),
    );
  }

  // =========================================================
  // Header
  // =========================================================

  Widget _header(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          tooltip: 'الرئيسية',
        ),

        const SizedBox(width: 4),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: MasarColors.lightBlue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.school_outlined,
            color: MasarColors.primaryBlue,
            size: 26,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بك 👋',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MasarColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'لوحة التدريب',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // Motivation Card
  // =========================================================

  Widget _motivationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MasarColors.lightGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Center(
              child: Text(
                '🏆',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ابدأ تدريبك بقوة 💪',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: MasarColors.darkGreen,
                      ),
                ),

                const SizedBox(height: 5),

                Text(
                  'تابع حضورك وتقاريرك وتقدمك خلال فترة التدريب.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MasarColors.darkGreen,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Training Information
  // =========================================================

  Widget _trainingCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات التدريب',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _companyLogo(),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Microsoft',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'تدريب ميداني',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                _statusBadge(),
              ],
            ),

            const SizedBox(height: 18),

            const Divider(),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'الموقع',
                    value: 'عمّان',
                  ),
                ),

                Expanded(
                  child: _infoItem(
                    context,
                    icon: Icons.calendar_month_outlined,
                    title: 'المدة',
                    value: '6 أسابيع',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Company Logo
  // =========================================================

  Widget _companyLogo() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'M',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MasarColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Status Badge
  // =========================================================

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: MasarColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'نشط',
        style: TextStyle(
          color: MasarColors.darkGreen,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================
  // Info Item
  // =========================================================

  Widget _infoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: MasarColors.primaryBlue,
          size: 21,
        ),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MasarColors.textSecondary,
                  ),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // Progress
  // =========================================================

  Widget _progressCard(BuildContext context) {
    const double progress = 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'تقدم التدريب',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MasarColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 9,
                backgroundColor: MasarColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  MasarColors.primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'لم يتم تسجيل أي نشاط تدريبي بعد',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MasarColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Statistics
  // =========================================================

  Widget _statistics(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات التدريب',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _statItem(
                    context,
                    icon: Icons.access_time_outlined,
                    value: '0',
                    label: 'ساعة تدريب',
                  ),
                ),

                Expanded(
                  child: _statItem(
                    context,
                    icon: Icons.date_range_outlined,
                    value: '0',
                    label: 'أسبوع مكتمل',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _statItem(
                    context,
                    icon: Icons.event_available_outlined,
                    value: '0',
                    label: 'يوم حضور',
                  ),
                ),

                Expanded(
                  child: _statItem(
                    context,
                    icon: Icons.description_outlined,
                    value: '0',
                    label: 'تقرير مقدم',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Statistics Item
  // =========================================================

  Widget _statItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: MasarColors.primaryBlue,
            size: 23,
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: MasarColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}