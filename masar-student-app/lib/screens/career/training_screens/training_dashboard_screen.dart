import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import 'attendance_screen.dart';
import 'reports_screen.dart';
import 'evaluation_screen.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

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
                const SizedBox(height: 18),

                _trainingCard(context),
                const SizedBox(height: 12),

                _progressCard(context),
                const SizedBox(height: 12),

                _statistics(context),
                const SizedBox(height: 12),

                _quickActions(context),
                const SizedBox(height: 12),

                _motivationCard(context),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const AppBottomNavBar(
  selectedIndex: 0,
),
    );
  }

  // =========================
  // Header
  // =========================

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: MasarColors.lightBlue,
          child: Icon(
            Icons.person_outline,
            color: MasarColors.primaryBlue,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً شهد 🌱',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'بالتوفيق في رحلتك التدريبية!',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  // =========================
  // Current Training
  // =========================

  Widget _trainingCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _companyLogo(),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Microsoft',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'IT Support Intern',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                _statusBadge(),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: MasarColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'عمان',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const Spacer(),

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: MasarColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '12/09/2026 - 12/12/2026',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(width: 10),

                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: MasarColors.textSecondary,
                ),
                const SizedBox(width: 3),
                Text(
                  '120 ساعة',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyLogo() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: const Icon(
        Icons.grid_view_rounded,
        color: MasarColors.primaryBlue,
        size: 28,
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: MasarColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'التدريب الحالي',
        style: TextStyle(
          color: MasarColors.darkGreen,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================
  // Progress
  // =========================

  Widget _progressCard(BuildContext context) {
    const progress = 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'نسبة الإنجاز',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MasarColors.primaryBlue,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: MasarColors.lightBlue,
                color: MasarColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Statistics
  // =========================

  Widget _statistics(BuildContext context) {
    final stats = [
      ('0', 'ساعة تدريب', Icons.access_time),
      ('0', 'أسبوع مكتمل', Icons.calendar_month_outlined),
      ('0', 'يوم حضور', Icons.person_outline),
      ('0', 'تقرير مقدم', Icons.description_outlined),
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 3,
                ),
                child: Column(
                  children: [
                    Icon(
                      stat.$3,
                      color: MasarColors.primaryBlue,
                      size: 23,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      stat.$1,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    Text(
                      stat.$2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================
  // Quick Actions
  // =========================

  Widget _quickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _action(
            context,
            Icons.calendar_month_outlined,
            'الحضور',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AttendanceScreen(),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _action(
            context,
            Icons.description_outlined,
            'التقارير الأسبوعية',
            () {
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const ReportsScreen(),
  ),
);
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _action(
            context,
            Icons.star_outline,
            'التقييمات',
            () {
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const EvaluationScreen(),
  ),
);
              // شاشة التقييمات لاحقًا
            },
          ),
        ),
      ],
    );
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                icon,
                color: MasarColors.primaryBlue,
                size: 25,
              ),

              const SizedBox(height: 7),

              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 5),

              const Icon(
                Icons.arrow_forward_ios,
                size: 11,
                color: MasarColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Motivation
  // =========================

  Widget _motivationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.format_quote,
            color: MasarColors.primaryBlue,
            size: 24,
          ),

          const SizedBox(width: 6),

          Text(
            'خطوة بخطوة... نصنع مستقبلك.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  // =========================
  // Bottom Navigation
  // =========================

  NavigationBar _bottomNavigation() {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {},
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(Icons.business_center_outlined),
          selectedIcon: Icon(Icons.business_center),
          label: 'فرص التدريب',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description),
          label: 'تقاريري',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_none),
          selectedIcon: Icon(Icons.notifications),
          label: 'الإشعارات',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'ملفي',
        ),
      ],
    );
  }
}