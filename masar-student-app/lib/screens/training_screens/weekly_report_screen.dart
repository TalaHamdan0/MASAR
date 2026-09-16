import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';

class WeeklyReportScreen extends StatefulWidget {
  final int week;

  const WeeklyReportScreen({super.key, required this.week});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  final TextEditingController tasksController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    tasksController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (tasksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى كتابة المهام التي أنجزتها هذا الأسبوع'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال التقرير بنجاح ✓'),
        backgroundColor: MasarColors.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تقرير الأسبوع ${widget.week}')),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _reportHeader(context),

                const SizedBox(height: 16),

                _tasksSection(context),

                const SizedBox(height: 16),

                _notesSection(context),

                const SizedBox(height: 24),

                _submitButton(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
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
      ),
    );
  }

  Widget _reportHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
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
                    'تقرير الأسبوع ${widget.week}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'قم بتسجيل المهام التي أنجزتها خلال هذا الأسبوع',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tasksSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المهام الأسبوعية',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 6),

            Text(
              'اكتب المهام التي أنجزتها خلال هذا الأسبوع',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: tasksController,
              maxLines: 8,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText:
                    '1. المهمة الأولى\n'
                    '2. المهمة الثانية\n'
                    '3. المهمة الثالثة\n'
                    '...\n'
                    '7. المهمة السابعة',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملاحظات إضافية',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 6),

            Text(
              'هذا الحقل اختياري',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: notesController,
              maxLines: 5,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'اكتب أي ملاحظات أو صعوبات واجهتك...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return FilledButton.icon(
      onPressed: _submitReport,
      icon: const Icon(Icons.send_outlined),
      label: const Text('إرسال التقرير'),
    );
  }
}
