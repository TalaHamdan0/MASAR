import 'package:flutter/material.dart';

import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';

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

  // =========================
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    final int completedTasks = tasks
        .where((task) => task['status'] == 'completed')
        .length;

    final int totalTasks = tasks.length;

    final double progress =
        totalTasks == 0 ? 0 : completedTasks / totalTasks;

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
                // =========================
                // PAGE HEADER
                // =========================

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

                // =========================
                // PROGRESS
                // =========================

                _buildProgressBanner(
                  completedTasks,
                  totalTasks,
                  progress,
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
                  'خطوات عملية تساعدك على سد فجوة المهارات والوصول إلى هدفك المهني.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
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

  // =========================
  // Progress Banner
  // =========================

  Widget _buildProgressBanner(
    int completed,
    int total,
    double progress,
  ) {
    final int percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            MasarColors.primaryBlue,
            MasarColors.primaryGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
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

          const SizedBox(height: 7),

          Text(
            '$completed من أصل $total مهام مكتملة',
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
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 7),

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

  // =========================
  // Task Card
  // =========================

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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  task['icon'],
                  color: statusColor,
                  size: 19,
                ),
              ),

              if (index != tasks.length - 1)
                Container(
                  width: 2,
                  height: 95,
                  color: MasarColors.border,
                ),
            ],
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
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
                            fontSize: 14,
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

                  const SizedBox(height: 9),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
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

                  // SQL
                  if (task['title'] == 'تطوير مهارات SQL' &&
                      status == 'inProgress') ...[
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showSqlLearningBottomSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              MasarColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'عرض المحتوى المقترح',
                        ),
                      ),
                    ),
                  ],

                  // SQL completed
                  if (task['title'] == 'تطوير مهارات SQL' &&
                      status == 'completed') ...[
                    const SizedBox(height: 10),

                    const Row(
                      children: [
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: MasarColors.primaryGreen,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'تم اجتياز اختبار المهارة',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                MasarColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Locked
                  if (status == 'locked') ...[
                    const SizedBox(height: 10),

                    const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 15,
                          color:
                              MasarColors.textSecondary,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'أكمل المهمة السابقة أولاً للانتقال إلى هذه الخطوة.',
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  MasarColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Power BI unlocked
                  if (task['title'] ==
                          'بناء لوحة معلومات باستخدام Power BI' &&
                      status == 'inProgress') ...[
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'سيتم عرض محتوى Power BI المقترح.',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              MasarColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'عرض المحتوى المقترح',
                        ),
                      ),
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

  // =========================
  // SQL Learning Bottom Sheet
  // =========================

  void _showSqlLearningBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(sheetContext).size.height * 0.82,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                24,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: MasarColors.border,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: MasarColors.lightBlue,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.storage_outlined,
                          color:
                              MasarColors.primaryBlue,
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 11),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تطوير مهارات SQL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    MasarColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'خطة مقترحة لسد فجوة المهارة',
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    MasarColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSkillLevelBox(
                          title: 'مستواك',
                          value: '30%',
                          color: MasarColors.warning,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: _buildSkillLevelBox(
                          title: 'المطلوب',
                          value: '70%',
                          color:
                              MasarColors.primaryGreen,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: _buildSkillLevelBox(
                          title: 'الفجوة',
                          value: '40%',
                          color: MasarColors.error,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'خطة التعلم',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildLearningItem(
                    title: 'أساسيات SQL',
                    description:
                        'SELECT و WHERE و ORDER BY و DISTINCT',
                    icon: Icons.school_outlined,
                  ),

                  _buildLearningItem(
                    title: 'تحليل البيانات',
                    description:
                        'GROUP BY و HAVING والدوال التجميعية COUNT و SUM و AVG',
                    icon: Icons.analytics_outlined,
                  ),

                  _buildLearningItem(
                    title: 'ربط البيانات',
                    description:
                        'INNER JOIN و LEFT JOIN وفهم العلاقات بين الجداول',
                    icon: Icons.account_tree_outlined,
                  ),

                  _buildLearningItem(
                    title: 'الاستعلامات المتقدمة',
                    description:
                        'Subqueries و CASE WHEN والتعامل مع NULL',
                    icon: Icons.code_outlined,
                  ),

                  _buildLearningItem(
                    title: 'تطبيق عملي',
                    description:
                        'تحليل بيانات مبيعات واستخراج أهم المؤشرات باستخدام SQL.',
                    icon:
                        Icons.assignment_turned_in_outlined,
                    isLast: true,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: MasarColors.lightGreen,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          color:
                              MasarColors.primaryGreen,
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'بعد إكمال المحتوى، حل الاختبار القصير لتقييم مهارتك.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color:
                                  MasarColors.textPrimary,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _showSqlQuiz();
                      },
                      icon: const Icon(
                        Icons.quiz_outlined,
                      ),
                      label: const Text(
                        'ابدأ اختبار SQL',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MasarColors.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(
                          color:
                              MasarColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================
  // Skill Level Box
  // =========================

  Widget _buildSkillLevelBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: MasarColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Learning Item
  // =========================

  Widget _buildLearningItem({
    required String title,
    required String description,
    required IconData icon,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: MasarColors.primaryBlue,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 47,
                color: MasarColors.border,
              ),
          ],
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 13,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // SQL Quiz
  // =========================

  void _showSqlQuiz() {
    int currentQuestion = 0;
    int correctAnswers = 0;

    final List<Map<String, dynamic>> questions = [
      {
        'question': 'أي أمر يُستخدم لاختيار البيانات من جدول؟',
        'options': [
          'SELECT',
          'DELETE',
          'UPDATE',
          'DROP',
        ],
        'answer': 0,
      },
      {
        'question':
            'أي أمر يُستخدم لتصفية النتائج حسب شرط معين؟',
        'options': [
          'ORDER BY',
          'WHERE',
          'GROUP BY',
          'JOIN',
        ],
        'answer': 1,
      },
      {
        'question':
            'أي دالة تُستخدم لحساب عدد السجلات؟',
        'options': [
          'SUM()',
          'AVG()',
          'COUNT()',
          'MAX()',
        ],
        'answer': 2,
      },
      {
        'question':
            'أي JOIN يعرض السجلات المشتركة بين الجدولين؟',
        'options': [
          'INNER JOIN',
          'LEFT JOIN',
          'RIGHT JOIN',
          'FULL JOIN',
        ],
        'answer': 0,
      },
      {
        'question':
            'أي أمر يُستخدم لترتيب النتائج؟',
        'options': [
          'GROUP BY',
          'WHERE',
          'ORDER BY',
          'HAVING',
        ],
        'answer': 2,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final question = questions[currentQuestion];

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.78,
                ),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  25,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: MasarColors.border,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'اختبار SQL',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  MasarColors.textPrimary,
                            ),
                          ),

                          Text(
                            '${currentQuestion + 1}/${questions.length}',
                            style: const TextStyle(
                              color:
                                  MasarColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      LinearProgressIndicator(
                        value:
                            (currentQuestion + 1) /
                                questions.length,
                        minHeight: 7,
                        borderRadius:
                            BorderRadius.circular(10),
                        backgroundColor:
                            MasarColors.lightBlue,
                        valueColor:
                            const AlwaysStoppedAnimation(
                          MasarColors.primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          color:
                              MasarColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...List.generate(
                        question['options'].length,
                        (index) {
                          return Container(
                            margin:
                                const EdgeInsets.only(
                              bottom: 10,
                            ),
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (index ==
                                    question['answer']) {
                                  correctAnswers++;
                                }

                                if (currentQuestion <
                                    questions.length - 1) {
                                  setSheetState(() {
                                    currentQuestion++;
                                  });
                                } else {
                                  Navigator.pop(
                                    sheetContext,
                                  );

                                  _showQuizResult(
                                    correctAnswers,
                                    questions.length,
                                  );
                                }
                              },
                              style:
                                  OutlinedButton.styleFrom(
                                alignment:
                                    Alignment.centerRight,
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                                side: const BorderSide(
                                  color:
                                      MasarColors.border,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),
                              ),
                              child: Text(
                                question['options'][index],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color:
                                      MasarColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================
  // Quiz Result
  // =========================

  void _showQuizResult(
    int correct,
    int total,
  ) {
    final int percentage =
        ((correct / total) * 100).round();

    final bool passed = percentage >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  passed
                      ? Icons.check_circle
                      : Icons.refresh,
                  color: passed
                      ? MasarColors.primaryGreen
                      : MasarColors.warning,
                ),

                const SizedBox(width: 8),

                Text(
                  passed
                      ? 'أحسنت! 🎉'
                      : 'حاول مرة أخرى',
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'نتيجتك: $percentage%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        MasarColors.primaryBlue,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  passed
                      ? 'لقد اجتزت اختبار SQL ويمكنك الانتقال إلى الخطوة التالية.'
                      : 'تحتاج إلى 70% على الأقل لاجتياز الاختبار. يمكنك مراجعة المحتوى والمحاولة مرة أخرى.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color:
                        MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              if (!passed)
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _showSqlLearningBottomSheet();
                  },
                  child: const Text(
                    'مراجعة المحتوى',
                  ),
                ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  if (passed) {
                    _completeSqlTask();
                  } else {
                    _showSqlQuiz();
                  }
                },
                child: Text(
                  passed
                      ? 'إكمال المهمة'
                      : 'إعادة الاختبار',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // Complete SQL
  // =========================

  void _completeSqlTask() {
    setState(() {
      for (final task in tasks) {
        if (task['title'] == 'تطوير مهارات SQL') {
          task['status'] = 'completed';
        }

        if (task['title'] ==
            'بناء لوحة معلومات باستخدام Power BI') {
          task['status'] = 'inProgress';
        }
      }
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.celebration_outlined,
                  color: MasarColors.primaryGreen,
                ),
                SizedBox(width: 8),
                Text('تم إنجاز المهمة'),
              ],
            ),
            content: const Text(
              'ممتاز! تم إكمال مهمة SQL وفتح الخطوة التالية في خارطة الطريق.',
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'متابعة',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // Add Task
  // =========================

  void _showAddTaskDialog() {
    final TextEditingController controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(
              'إضافة مهمة جديدة',
            ),
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
                  Navigator.pop(dialogContext);
                },
                child: const Text('إلغاء'),
              ),

              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    return;
                  }

                  setState(() {
                    tasks.add({
                      'title': controller.text.trim(),
                      'description':
                          'مهمة مضافة إلى خارطة التطوير الخاصة بك.',
                      'status': 'upcoming',
                      'icon': Icons.task_alt,
                    });
                  });

                  Navigator.pop(dialogContext);
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
        );
      },
    );
  }
}