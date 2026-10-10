import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/masar_theme.dart';
import 'company_main_layout.dart';
import '../../core/widgets/company_dashboard_sidebar.dart';
import '../../core/widgets/company_dashboard_header.dart';
import 'applicants_monthly_details_screen.dart';
import 'internships_screen.dart';
import 'interviews_screen.dart';
import 'pending_applications_screen.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  bool _showAllApplicants = false;
  bool _showAllOpportunities = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeBanner(),
          const SizedBox(height: 24),
          _buildStatistics(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildApplicantsChart()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _buildApplicantsStatus()),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildRecentApplicantsTable()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _buildOpportunityPerformance()),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildQuickActions()),
              const SizedBox(width: 20),
              Expanded(child: _buildRecentActivities()),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بنر الترحيب
  // ============================================================

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MasarColors.primaryBlue, MasarColors.darkBlue],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً سارة 👋',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لنصنع معاً فرصة أفضل لمستقبل الشباب.',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'الأحد، 5 أيلول 2026',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.domain_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // الإحصائيات الرئيسية
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'متدرب حالي',
            value: '28',
            subtitle: 'على رأس العمل',
            icon: Icons.person_pin_rounded,
            color: MasarColors.primaryGreen,
            background: MasarColors.lightGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            title: 'في المقابلة',
            value: '45',
            subtitle: 'تمت الجدولة',
            icon: Icons.event_rounded,
            color: MasarColors.primaryBlue,
            background: MasarColors.lightBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            title: 'إجمالي المتقدمين',
            value: '248',
            subtitle: 'طلب مكتمل',
            icon: Icons.groups_rounded,
            color: MasarColors.primaryBlue,
            background: MasarColors.lightBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            title: 'فرصة نشطة',
            value: '12',
            subtitle: 'شاغر متوفر',
            icon: Icons.work_rounded,
            color: MasarColors.warning,
            background: const Color(0xFFFFFBEB),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // مخطط أعداد المتقدمين شهرياً
  // ============================================================

  Widget _buildApplicantsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: MasarColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: MasarColors.primaryBlue,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'أعداد المتقدمين شهرياً',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ApplicantsMonthlyDetailsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MasarColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: MasarColors.textSecondary,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'يناير',
                          'فبراير',
                          'مارس',
                          'أبريل',
                          'مايو',
                        ];

                        if (value.toInt() >= 0 &&
                            value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                color: MasarColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                minX: 0,
                maxX: 4,
                minY: 0,
                maxY: 80,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 36),
                      FlSpot(2, 42),
                      FlSpot(3, 57),
                      FlSpot(4, 68),
                    ],
                    isCurved: true,
                    color: MasarColors.primaryBlue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2.5,
                          strokeColor: MasarColors.primaryBlue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          MasarColors.primaryBlue.withOpacity(0.25),
                          MasarColors.primaryBlue.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // حالة المتقدمين
  // ============================================================

  Widget _buildApplicantsStatus() {
    return _dashboardCard(
      title: 'حالة المتقدمين',
      icon: Icons.pie_chart_rounded,
      child: Column(
        children: [
          const SizedBox(height: 4),
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 14,
                    backgroundColor: MasarColors.lightBlue,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MasarColors.primaryBlue,
                    ),
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '248',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    Text(
                      'متقدم',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _statusRow('قيد المراجعة (40%)', '98', MasarColors.warning),
          const SizedBox(height: 8),
          _statusRow('في المقابلة (18%)', '45', Colors.lightBlue),
          const SizedBox(height: 8),
          _statusRow('مقبول (12%)', '30', MasarColors.primaryGreen),
          const SizedBox(height: 8),
          _statusRow('مرفوض (30%)', '75', MasarColors.error),
        ],
      ),
    );
  }

  Widget _statusRow(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5,
              color: MasarColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // أحدث المتقدمين
  // ============================================================

  Widget _buildRecentApplicantsTable() {
    final applicants = [
      {
        'name': 'أحمد محمد',
        'major': 'علوم الحاسوب',
        'date': '2026/05/10',
        'status': 'قيد المراجعة',
      },
      {
        'name': 'نورة خالد',
        'major': 'هندسة برمجيات',
        'date': '2026/05/09',
        'status': 'في المقابلة',
      },
      {
        'name': 'عبدالله فيصل',
        'major': 'إدارة أعمال',
        'date': '2026/05/08',
        'status': 'مقبول',
      },
      {
        'name': 'رغد علي',
        'major': 'علوم البيانات',
        'date': '2026/05/07',
        'status': 'قيد المراجعة',
      },
      if (_showAllApplicants) ...[
        {
          'name': 'عمر التميمي',
          'major': 'هندسة شبكات',
          'date': '2026/05/06',
          'status': 'في المقابلة',
        },
        {
          'name': 'أحمد خالد',
          'major': 'تسويق',
          'date': '2026/05/05',
          'status': 'قيد المراجعة',
        },
      ],
    ];

    return _dashboardCard(
      title: 'أحدث المتقدمين',
      icon: Icons.recent_actors_rounded,
      actionText: _showAllApplicants ? 'عرض أقل' : 'عرض الكل',
      onAction: () {
        setState(() {
          _showAllApplicants = !_showAllApplicants;
        });
      },
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: MasarColors.border)),
            ),
            children: const [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'الطالب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'التخصص',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'التاريخ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'الحالة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          ...applicants.map(
            (item) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  child: Text(
                    item['name']!,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  child: Text(
                    item['major']!,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  child: Text(
                    item['date']!,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 10.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item['status']!).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['status']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: _getStatusColor(item['status']!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'قيد المراجعة':
        return MasarColors.warning;
      case 'في المقابلة':
        return MasarColors.primaryBlue;
      case 'مقبول':
        return MasarColors.primaryGreen;
      default:
        return MasarColors.textSecondary;
    }
  }

  // ============================================================
  // أداء الفرص التدريبية
  // ============================================================

  Widget _buildOpportunityPerformance() {
    final opportunities = [
      {'title': 'تطوير البرمجيات', 'count': 120, 'progress': 1.0},
      {'title': 'تحليل البيانات', 'count': 85, 'progress': 0.74},
      {'title': 'إدارة المشاريع', 'count': 60, 'progress': 0.54},
      {'title': 'التصميم', 'count': 40, 'progress': 0.37},
      if (_showAllOpportunities) ...[
        {'title': 'الشبكات', 'count': 35, 'progress': 0.42},
        {'title': 'التسويق', 'count': 30, 'progress': 0.36},
      ],
    ];

    return _dashboardCard(
      title: 'أداء الفرص التدريبية',
      icon: Icons.bar_chart_outlined,
      actionText: _showAllOpportunities ? 'عرض أقل' : 'عرض الكل',
      onAction: () {
        setState(() {
          _showAllOpportunities = !_showAllOpportunities;
        });
      },
      child: Column(
        children: opportunities.map((op) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      op['title'] as String,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${op['count']}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: op['progress'] as double,
                  minHeight: 6,
                  backgroundColor: MasarColors.lightBlue,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    MasarColors.primaryBlue,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // الإجراءات السريعة
  // ============================================================

  Widget _buildQuickActions() {
    final actions = [
      {'title': 'فرصة تدريبية جديدة', 'icon': Icons.add_task_rounded},
      {'title': 'مراجعة الطلبات الجديدة', 'icon': Icons.rate_review_rounded},
      {'title': 'جدولة مقابلة', 'icon': Icons.event_available_rounded},
    ];

    return _dashboardCard(
      title: 'إجراءات سريعة',
      icon: Icons.flash_on_rounded,
      child: Column(
        children: actions.map((act) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              // الإجراء ظاهر في لوحة التحكم فقط حالياً، دون الانتقال
              // إلى شاشة إدارة المتقدمين عند الضغط عليه.
              onTap: () {
                if (act['title'] == 'فرصة تدريبية جديدة') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddInternshipScreen(),
                    ),
                  );
                } else if (act['title'] == 'جدولة مقابلة') {
                  showInterviewScheduleDialog(
                    context,
                    onSave: (interview) {
                      // حفظ المقابلة في نفس القائمة التي تستخدمها شاشة المقابلات.
                      InterviewsScreen.addSharedInterview(interview);
                    },
                    onMessage: (message) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    },
                  );
                } else if (act['title'] == 'مراجعة الطلبات الجديدة') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingApplicationsScreen(),
                    ),
                  );
                }
              },

              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: MasarColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MasarColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      act['icon'] as IconData,
                      color: MasarColors.primaryBlue,
                      size: 19,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        act['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: MasarColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // آخر الأنشطة
  // ============================================================

  Widget _buildRecentActivities() {
    final activities = [
      {
        'title': 'تقديم 5 طلاب على فرصة تطوير البرمجيات',
        'time': 'منذ 15 دقيقة',
        'icon': Icons.person_add_alt_1_rounded,
        'color': MasarColors.primaryBlue,
      },
      {
        'title': 'تم قبول الطالب عبدالله فيصل',
        'time': 'منذ ساعة',
        'icon': Icons.check_circle_rounded,
        'color': MasarColors.primaryGreen,
      },
      {
        'title': 'تم جدولة مقابلة مع نورة خالد',
        'time': 'منذ 3 ساعات',
        'icon': Icons.calendar_month_rounded,
        'color': MasarColors.primaryBlue,
      },
      {
        'title': 'تم نشر فرصة تدريبية',
        'time': 'منذ 5 ساعات',
        'icon': Icons.campaign_rounded,
        'color': MasarColors.primaryBlue,
      },
    ];

    return _dashboardCard(
      title: 'آخر الأنشطة',
      icon: Icons.history_rounded,
      child: Column(
        children: activities.map((act) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: (act['color'] as Color).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    act['icon'] as IconData,
                    color: act['color'] as Color,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        act['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      Text(
                        act['time'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 9.5,
                          color: MasarColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // البطاقة العامة
  // ============================================================

  Widget _dashboardCard({
    required String title,
    required IconData icon,
    required Widget child,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: MasarColors.primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ),
              if (actionText != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MasarColors.primaryBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
