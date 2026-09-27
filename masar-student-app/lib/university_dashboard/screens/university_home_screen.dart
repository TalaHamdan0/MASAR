
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';

import 'students_screen.dart';
import 'companies_screen.dart';
import 'applications_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'university_login_screen.dart';

class UniversityHomeScreen extends StatefulWidget {
  const UniversityHomeScreen({super.key});

  @override
  State<UniversityHomeScreen> createState() =>
      _UniversityHomeScreenState();
}

class _UniversityHomeScreenState extends State<UniversityHomeScreen> {
  int selectedIndex = 0;

  final List<String> menuItems = [
    'الرئيسية',
    'الطلاب',
    'الشركات',
    'طلبات التدريب',
    'التدريبات الحالية',
    'التقارير',
    'الإشعارات',
    'الإعدادات',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: _buildDashboardContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UniDashboardSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: _handleMenuSelection,
              onLogout: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: MasarColors.white,
        border: Border(
          bottom: BorderSide(
            color: MasarColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            menuItems[selectedIndex],
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: MasarColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            width: 260,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MasarColors.border,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث...',
                hintStyle: TextStyle(
                  color: MasarColors.textSecondary,
                  fontSize: 12,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MasarColors.textSecondary,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: MasarColors.primaryBlue,
                  size: 22,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: MasarColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 1,
            height: 34,
            color: MasarColors.border,
          ),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'د. محمد العبدالله',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: MasarColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'مسؤول التدريب',
                style: TextStyle(
                  fontSize: 10,
                  color: MasarColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: MasarColors.primaryBlue,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(int index) {
    if (index == 0) {
      setState(() {
        selectedIndex = 0;
      });
      return;
    }

    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 1:
        _openScreen(const StudentsScreen());
        break;
      case 2:
        _openScreen(const CompaniesScreen());
        break;
      case 3:
        _openScreen(const ApplicationsScreen());
        break;
      case 4:
        _openScreen(const CurrentTrainingsScreen());
        break;
      case 5:
        _openScreen(const ReportsScreen());
        break;
      case 6:
        _openScreen(const NotificationsScreen());
        break;
      case 7:
        _openScreen(const SettingsScreen());
        break;
    }
  }

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    ).then((_) {
      if (!mounted) return;

      setState(() {
        selectedIndex = 0;
      });
    });
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

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'إجمالي الطلاب',
            value: '1,248',
            subtitle: 'طالب مسجل',
            icon: Icons.people_alt_rounded,
            color: MasarColors.primaryBlue,
            background: MasarColors.lightBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            title: 'الشركات المسجلة',
            value: '86',
            subtitle: 'شركة',
            icon: Icons.business_rounded,
            color: MasarColors.primaryGreen,
            background: MasarColors.lightGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
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
        border: Border.all(
          color: MasarColors.border,
        ),
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
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: MasarColors.textPrimary,
                  ),
                ),
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
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

  Widget _statusRow(
    String title,
    String value,
    Color color,
  ) {
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
    );
  }

  Widget _applicationRow(
    Map<String, String> application,
  ) {
    final String status = application['status']!;

    Color statusColor;

    if (status == 'مقبول') {
      statusColor = MasarColors.success;
    } else if (status == 'جديد') {
      statusColor = MasarColors.primaryBlue;
    } else {
      statusColor = MasarColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MasarColors.border,
          ),
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
            description:
                'يوجد 18 طلب تدريب جديد بحاجة إلى مراجعة.',
            color: MasarColors.primaryBlue,
          ),
          _alertItem(
            icon: Icons.description_rounded,
            title: 'تقارير بحاجة للمراجعة',
            description:
                'يوجد 5 تقارير تدريبية بانتظار المراجعة.',
            color: MasarColors.warning,
          ),
          _alertItem(
            icon: Icons.access_time_filled_rounded,
            title: 'طلاب قريبون من إكمال التدريب',
            description:
                '12 طالباً اقتربوا من إكمال 280 ساعة تدريبية.',
            color: MasarColors.primaryGreen,
          ),
          _alertItem(
            icon: Icons.check_circle_rounded,
            title: 'تدريبات مكتملة',
            description:
                'تم إكمال 8 تدريبات خلال هذا الأسبوع.',
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
                bottom: BorderSide(
                  color: MasarColors.border,
                ),
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
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius:
                      BorderRadius.circular(10),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'تسجيل الخروج',
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد تسجيل الخروج من لوحة التحكم؟',
            textAlign: TextAlign.right,
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
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UniversityLoginScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    MasarColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}
