
import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';

class UniversityHomeScreen extends StatefulWidget {
  const UniversityHomeScreen({super.key});

  @override
  State<UniversityHomeScreen> createState() =>
      _UniversityHomeScreenState();
}

class _UniversityHomeScreenState
    extends State<UniversityHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: _buildDashboardContent(),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeBanner(),
        const SizedBox(height: 24),
        _buildStatistics(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildStudentsByMajor(),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: _buildTrainingStatus(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildApplicationsTable(),
        const SizedBox(height: 24),
        _buildAlertsSection(),
      ],
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MasarColors.primaryBlue,
            MasarColors.darkBlue,
          ],
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
                  'مرحباً د. محمد العبدالله 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'تابع أداء الطلبة وإدارة برامج التدريب من مكان واحد.',
                  style: TextStyle(
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
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'الفصل التدريبي 2026 / 2027',
                        style: TextStyle(
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
          const SizedBox(width: 12),
          Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 54,
            ),
          ),
        ],
      ),
    );
  }

  // الإحصائيات الرئيسية
  Widget _buildStatistics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth =
            (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'إجمالي الطلاب',
                value: '1,248',
                subtitle: 'طالب مسجل',
                icon: Icons.people_alt_rounded,
                color: MasarColors.primaryBlue,
                background: MasarColors.lightBlue,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الشركات المسجلة',
                value: '86',
                subtitle: 'شركة',
                icon: Icons.business_rounded,
                color: MasarColors.primaryGreen,
                background: MasarColors.lightGreen,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الطلاب بالتدريب',
                value: '142',
                subtitle: 'طالب يتدرب حالياً',
                icon: Icons.school_rounded,
                color: MasarColors.primaryBlue,
                background: MasarColors.lightBlue,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'طلبات جديدة',
                value: '18',
                subtitle: 'تحتاج مراجعة',
                icon: Icons.assignment_rounded,
                color: MasarColors.error,
                background: const Color(0xFFFFEEEE),
              ),
            ),
          ],
        );
      },
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.5,
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

  Widget _buildStudentsByMajor() {
    final majors = [
      {'name': 'هندسة البرمجيات', 'value': 72},
      {'name': 'علوم الحاسوب', 'value': 58},
      {'name': 'نظم المعلومات', 'value': 46},
      {'name': 'الذكاء الاصطناعي', 'value': 38},
      {'name': 'الأمن السيبراني', 'value': 31},
    ];

    return _dashboardCard(
      title: 'الطلاب حسب التخصص',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: majors.map((major) {
          final int value = major['value'] as int;

          return Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Row(
              children: [
                SizedBox(
                  width: 115,
                  child: Text(
                    major['name'] as String,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: MasarColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: value / 100,
                      minHeight: 9,
                      backgroundColor: MasarColors.lightBlue,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MasarColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 35,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrainingStatus() {
    return _dashboardCard(
      title: 'حالة التدريب',
      icon: Icons.pie_chart_rounded,
      child: Column(
        children: [
          const SizedBox(height: 4),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 0.68,
                    strokeWidth: 16,
                    backgroundColor: MasarColors.lightBlue,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MasarColors.primaryGreen,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '68%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    Text(
                      'مكتمل',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _statusRow(
            'قيد التدريب',
            '142',
            MasarColors.primaryBlue,
          ),
          const SizedBox(height: 10),
          _statusRow(
            'مكتمل',
            '86',
            MasarColors.primaryGreen,
          ),
          const SizedBox(height: 10),
          _statusRow(
            'لم يبدأ',
            '34',
            MasarColors.warning,
          ),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              color: MasarColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationsTable() {
    final applications = [
      {
        'student': 'سارة أحمد',
        'company': 'شركة التقنية',
        'training': 'تطوير البرمجيات',
        'date': '25/09/2026',
        'status': 'جديد',
      },
      {
        'student': 'محمد خالد',
        'company': 'شركة الاتصالات',
        'training': 'نظم المعلومات',
        'date': '24/09/2026',
        'status': 'قيد المراجعة',
      },
      {
        'student': 'ليان محمود',
        'company': 'الحلول الرقمية',
        'training': 'تحليل البيانات',
        'date': '23/09/2026',
        'status': 'مقبول',
      },
      {
        'student': 'عمر سامي',
        'company': 'شركة البرمجيات',
        'training': 'تطوير التطبيقات',
        'date': '22/09/2026',
        'status': 'قيد المراجعة',
      },
    ];

    return _dashboardCard(
      title: 'أحدث طلبات التدريب',
      icon: Icons.assignment_rounded,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 850,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: MasarColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'الطالب',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'الشركة',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'التدريب المتوفر',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'التاريخ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'الحالة',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              ...applications.map(
                (application) => _applicationRow(application),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _applicationRow(Map<String, String> application) {
    final String status = application['status']!;

    final Color statusColor = status == 'مقبول'
        ? MasarColors.success
        : status == 'جديد'
            ? MasarColors.primaryBlue
            : MasarColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: MasarColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              application['student']!,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              application['company']!,
              style: TextStyle(
                fontSize: 11,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              application['training']!,
              style: TextStyle(
                fontSize: 11,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              application['date']!,
              style: TextStyle(
                fontSize: 10.5,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection() {
    return _dashboardCard(
      title: 'التنبيهات المهمة',
      icon: Icons.notifications_active_rounded,
      child: Column(
        children: [
          _alertItem(
            icon: Icons.assignment_rounded,
            title: 'طلبات تدريب جديدة',
            description: 'يوجد 18 طلب تدريب جديد بحاجة إلى مراجعة.',
            color: MasarColors.primaryBlue,
          ),
          _alertItem(
            icon: Icons.description_rounded,
            title: 'تقارير بحاجة للمراجعة',
            description: 'يوجد 5 تقارير تدريبية بانتظار المراجعة.',
            color: MasarColors.warning,
          ),
          _alertItem(
            icon: Icons.access_time_filled_rounded,
            title: 'طلاب قريبون من إكمال التدريب',
            description: '12 طالباً اقتربوا من إكمال 280 ساعة تدريبية.',
            color: MasarColors.primaryGreen,
          ),
          _alertItem(
            icon: Icons.check_circle_rounded,
            title: 'تدريبات مكتملة',
            description: 'تم إكمال 8 تدريبات خلال هذا الأسبوع.',
            color: MasarColors.success,
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _alertItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    bool showBorder = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(color: MasarColors.border),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: MasarColors.textSecondary,
            size: 21,
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: MasarColors.primaryBlue,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: MasarColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
