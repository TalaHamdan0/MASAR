import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'تعلم أساسيات Python',
      'description':
          'تطوير أساس قوي في لغة Python واستخدامها في تحليل البيانات.',
      'status': 'completed',
      'icon': Icons.code,
    },
    {
      'title': 'تطوير مهارات SQL',
      'description':
          'تعلم كتابة الاستعلامات والتعامل مع قواعد البيانات وتحليل البيانات.',
      'status': 'inProgress',
      'icon': Icons.storage_outlined,
    },
    {
      'title': 'بناء لوحة معلومات باستخدام Power BI',
      'description':
          'إنشاء مشروع عملي لعرض وتحليل البيانات بطريقة احترافية.',
      'status': 'locked',
      'icon': Icons.bar_chart_rounded,
    },
    {
      'title': 'إضافة المشروع إلى الملف المهني',
      'description':
          'توثيق المشروع وإضافته إلى ملفك المهني لإظهار مهاراتك العملية.',
      'status': 'upcoming',
      'icon': Icons.badge_outlined,
    },
    {
      'title': 'إعادة تقييم الجاهزية المهنية',
      'description':
          'قياس تطور مهاراتك ومراجعة الفجوات بعد إكمال خطوات التطوير.',
      'status': 'upcoming',
      'icon': Icons.analytics_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int completedTasks = tasks
        .where((task) => task['status'] == 'completed')
        .length;

    final int totalTasks = tasks.length;

    final double progress =
        totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        appBar: AppBar(
          backgroundColor: MasarColors.background,
          elevation: 0,
          title: const Text(
            'خارطة الطريق',
            style: TextStyle(
              color: MasarColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressBanner(
                completedTasks,
                totalTasks,
                progress,
              ),

              const SizedBox(height: 28),

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
                'خطوات عملية تساعدك على سد فجوة المهارات والوصول إلى هدفك المهني.',
                style: TextStyle(
                  fontSize: 13,
                  color: MasarColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              ...List.generate(
                tasks.length,
                (index) => _buildTaskCard(
                  tasks[index],
                  index,
                ),
              ),

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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MasarColors.primaryBlue,
          unselectedItemColor: MasarColors.textSecondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'خارطة الطريق',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'الفرص',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge_outlined),
              activeIcon: Icon(Icons.badge),
              label: 'الملف المهني',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBanner(
    int completed,
    int total,
    double progress,
  ) {
    final int percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MasarColors.primaryBlue,
            MasarColors.primaryGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تقدمك في خارطة الطريق',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$completed من أصل $total مهام مكتملة',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$percentage% من خارطة الطريق مكتمل',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    Map<String, dynamic> task,
    int index,
  ) {
    final String status = task['status'];

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        statusColor = MasarColors.primaryGreen;
        statusText = 'مكتملة';
        statusIcon = Icons.check_circle;
        break;

      case 'inProgress':
        statusColor = MasarColors.primaryBlue;
        statusText = 'قيد التنفيذ';
        statusIcon = Icons.play_circle_fill;
        break;

      case 'locked':
        statusColor = MasarColors.textSecondary;
        statusText = 'مغلقة';
        statusIcon = Icons.lock_outline;
        break;

      default:
        statusColor = MasarColors.warning;
        statusText = 'قادمة';
        statusIcon = Icons.schedule;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  task['icon'],
                  color: statusColor,
                  size: 20,
                ),
              ),

              if (index != tasks.length - 1)
                Container(
                  width: 2,
                  height: 90,
                  color: MasarColors.border,
                ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: MasarColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: MasarColors.textPrimary,
                          ),
                        ),
                      ),

                      Icon(
                        statusIcon,
                        size: 17,
                        color: statusColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    task['description'],
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (status == 'inProgress') ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'سيتم عرض المحتوى المقترح لتطوير هذه المهارة.',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              MasarColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'عرض المحتوى المقترح',
                        ),
                      ),
                    ),
                  ],

                  if (status == 'locked') ...[
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 15,
                          color: MasarColors.textSecondary,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'أكمل المهمة السابقة أولاً للانتقال إلى هذه الخطوة.',
                            style: TextStyle(
                              fontSize: 11,
                              color: MasarColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مهمة جديدة'),
          content: TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              hintText: 'اكتب اسم المهمة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                setState(() {
                  tasks.add({
                    'title': controller.text.trim(),
                    'description':
                        'مهمة مضافة إلى خارطة التطوير الخاصة بك.',
                    'status': 'upcoming',
                    'icon': Icons.task_alt,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }
}