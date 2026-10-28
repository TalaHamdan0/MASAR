import 'package:flutter/material.dart';

import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final List<_RoadmapTask> _personalTasks = [];

  Future<void> _showAddTaskDialog() async {
    String title = '';

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('إضافة مهمة جديدة'),
            content: TextField(
              autofocus: true,
              textDirection: TextDirection.rtl,
              onChanged: (value) {
                title = value;
              },
              decoration: const InputDecoration(
                hintText: 'اكتب اسم المهمة',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  final trimmedTitle = title.trim();

                  if (trimmedTitle.isEmpty) {
                    return;
                  }

                  Navigator.pop(dialogContext, trimmedTitle);
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _personalTasks.add(
        _RoadmapTask(title: result),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = _personalTasks
        .where((task) => task.isCompleted)
        .length;

    final total = _personalTasks.length;

    final double progress = total == 0
        ? 0
        : completed / total;

    return Scaffold(
      backgroundColor: MasarColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MasarColors.background,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              20,
              16,
              110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'خارطة الطريق',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'خطوات عملية تساعدك على تطوير مسارك المهني والوصول إلى أهدافك.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildProgressBanner(
                  completed: completed,
                  total: total,
                  progress: progress,
                ),
                const SizedBox(height: 26),
                const Text(
                  'خطة التطوير',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'خطوات تساعدك على تطوير المهارات المرتبطة بمسارك المهني.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPathStepsNotice(),
                const SizedBox(height: 20),
                if (_personalTasks.isNotEmpty) ...[
                  const Text(
                    'مهامي الشخصية',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    _personalTasks.length,
                    (index) => _buildPersonalTask(index),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showAddTaskDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة مهمة جديدة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MasarColors.primaryBlue,
                      side: const BorderSide(
                        color: MasarColors.primaryBlue,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'المهام المضافة هنا مؤقتة خلال عرض هذه الشاشة.',
                  style: TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 1,
      ),
    );
  }

  Widget _buildProgressBanner({
    required int completed,
    required int total,
    required double progress,
  }) {
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تقدمك في المهام الشخصية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? 'لم تضف مهام شخصية بعد'
                : '$completed من أصل $total مهام مكتملة',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0 ? '—' : '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathStepsNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.route_outlined,
            color: MasarColors.primaryBlue,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'لم تُحمّل خطوات المسار المهني بعد.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTask(int index) {
    final task = _personalTasks[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: CheckboxListTile(
        value: task.isCompleted,
        activeColor: MasarColors.primaryGreen,
        title: Text(
          task.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
        subtitle: Text(
          task.isCompleted ? 'مكتملة' : 'لم تكتمل بعد',
          style: const TextStyle(
            fontSize: 12,
            color: MasarColors.textSecondary,
          ),
        ),
        onChanged: (value) {
          setState(() {
            task.isCompleted = value ?? false;
          });
        },
      ),
    );
  }
}

class _RoadmapTask {
  final String title;
  bool isCompleted;

  _RoadmapTask({
    required this.title,
    this.isCompleted = false,
  });
}