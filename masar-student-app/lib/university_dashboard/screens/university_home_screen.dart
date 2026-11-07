import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_home_service.dart';
import '../../core/services/university_auth_service.dart';

class UniversityHomeScreen extends StatefulWidget {
  const UniversityHomeScreen({super.key});

  @override
  State<UniversityHomeScreen> createState() => _UniversityHomeScreenState();
}

class _UniversityHomeScreenState extends State<UniversityHomeScreen> {
  final UniversityHomeService _homeService = UniversityHomeService();

  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic>? _homeData;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _homeService.fetchHome();

      if (!mounted) return;

      setState(() {
        _homeData = data;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error is UniversityAuthException
            ? error.message
            : 'حدث خطأ أثناء تحميل البيانات.';

        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _mapOrEmpty(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int _intValue(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  double _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> get _statistics => _mapOrEmpty(_homeData?['statistics']);

  Map<String, dynamic> get _alerts => _mapOrEmpty(_homeData?['alerts']);

  int _statusCount(String status) {
    final statuses = _listOfMaps(_homeData?['internshipStatusCounts']);

    for (final item in statuses) {
      if (item['status'] == status) {
        return _intValue(item['count']);
      }
    }

    return 0;
  }

  String _formatDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(value.toString());

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');

      return '$day/$month/${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: _isLoading
              ? _buildLoadingState()
              : _errorMessage != null
              ? _buildErrorState()
              : _buildDashboardContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(50),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 45,
              color: UniColors.textSecondary,
            ),
            const SizedBox(height: 14),
            UniText(
              'تعذر تحميل بيانات الصفحة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: UniColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            UniText(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(color: UniColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _loadHomeData,
              icon: const Icon(Icons.refresh_rounded),
              label: const UniText('إعادة المحاولة'),
            ),
          ],
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
            Expanded(flex: 3, child: _buildStudentsByMajor()),
            const SizedBox(width: 20),
            Expanded(flex: 2, child: _buildTrainingStatus()),
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
    final staff = _mapOrEmpty(_homeData?['staff']);

    final staffName = staff['name']?.toString() ?? '';

    final termLabel =
        _homeData?['trainingTermLabel']?.toString() ??
        'الفصل التدريبي 2026 / 2027';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UniColors.primaryBlue, UniColors.darkBlue],
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
                UniText(
                  'مرحباً ${staffName.isEmpty ? 'بك' : staffName} 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                UniText(
                  'تابع أداء الطلبة وإدارة برامج التدريب من مكان واحد.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      UniText(
                        termLabel,
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
        final double cardWidth = (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'إجمالي الطلاب',
                value: _intValue(_statistics['totalStudents']).toString(),
                subtitle: 'طالب مسجل',
                icon: Icons.people_alt_rounded,
                color: UniColors.primaryBlue,
                background: UniColors.lightBlue,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الشركات المسجلة',
                value: _intValue(_statistics['registeredCompanies']).toString(),
                subtitle: 'شركة',
                icon: Icons.business_rounded,
                color: UniColors.primaryGreen,
                background: UniColors.lightGreen,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الطلاب بالتدريب',
                value: _intValue(_statistics['studentsInTraining']).toString(),
                subtitle: 'طالب يتدرب حالياً',
                icon: Icons.school_rounded,
                color: UniColors.primaryBlue,
                background: UniColors.lightBlue,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'طلبات جديدة',
                value: _intValue(_statistics['newApplications']).toString(),
                subtitle: 'تحتاج مراجعة',
                icon: Icons.assignment_rounded,
                color: UniColors.error,
                background: UniColors.lightError,
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
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
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
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                UniText(
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                UniText(
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
    final majors = _listOfMaps(_homeData?['studentsByMajor']);
    if (majors.isEmpty) {
      return _dashboardCard(
        title: 'الطلاب حسب التخصص',
        icon: Icons.bar_chart_rounded,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Center(
            child: UniText(
              'لا توجد بيانات طلاب لعرضها حالياً.',
              style: TextStyle(color: UniColors.textSecondary, fontSize: 13),
            ),
          ),
        ),
      );
    }
    final maxValue = majors
        .map((item) => _intValue(item['count']))
        .reduce((a, b) => a > b ? a : b);
    return _dashboardCard(
      title: 'الطلاب حسب التخصص',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: majors.map((major) {
          final name = major['major']?.toString() ?? '';
          final value = _intValue(major['count']);
          return Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Row(
              children: [
                SizedBox(
                  width: 115,
                  child: UniText(
                    name,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: UniColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: maxValue > 0 ? value / maxValue : 0,
                      minHeight: 9,
                      backgroundColor: UniColors.lightBlue,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        UniColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                SizedBox(
                  width: 35,
                  child: UniText(
                    '$value',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: UniColors.textPrimary,
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
    final percentage = _doubleValue(_homeData?['completionPercentage']);
    final progressValue = (percentage / 100).clamp(0.0, 1.0);
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
                    value: progressValue,
                    strokeWidth: 16,
                    backgroundColor: UniColors.lightBlue,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      UniColors.primaryGreen,
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UniText(
                      '${percentage.toStringAsFixed(percentage % 1 == 0 ? 0 : 1)}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: UniColors.textPrimary,
                      ),
                    ),
                    UniText(
                      'مكتمل',
                      style: TextStyle(
                        fontSize: 11,
                        color: UniColors.textSecondary,
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
            '${_statusCount('ACTIVE')}',
            UniColors.primaryBlue,
          ),
          const SizedBox(height: 10),
          _statusRow(
            'مكتمل',
            '${_statusCount('COMPLETED')}',
            UniColors.primaryGreen,
          ),
          const SizedBox(height: 10),
          _statusRow(
            'لم يبدأ',
            '${_statusCount('SELECTED')}',
            UniColors.warning,
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: UniText(
            title,
            style: TextStyle(fontSize: 11.5, color: UniColors.textSecondary),
          ),
        ),
        UniText(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: UniColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationsTable() {
    final applications = _listOfMaps(_homeData?['latestApplications']);
    return _dashboardCard(
      title: 'أحدث طلبات التدريب',
      icon: Icons.assignment_rounded,
      child: applications.isEmpty
          ? Padding(
              padding: EdgeInsets.all(25),
              child: Center(
                child: UniText(
                  'لا توجد طلبات تدريب حالياً.',
                  style: TextStyle(
                    color: UniColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
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
                        color: UniColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: UniText(
                              'الطالب',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: UniText(
                              'الشركة',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: UniText(
                              'التدريب المتوفر',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: UniText(
                              'التاريخ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: UniText(
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
                    ...applications.map((application) {
                      return _applicationRow({
                        'student':
                            application['studentName']?.toString() ?? '-',
                        'company':
                            application['companyName']?.toString() ?? '-',
                        'training':
                            application['trainingTitle']?.toString() ?? '-',
                        'date': _formatDate(application['submittedAt']),
                        'status': application['status']?.toString() ?? '-',
                      });
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _applicationRow(Map<String, String> application) {
    final String status = application['status']!;

    final Color statusColor = status == 'مقبول'
        ? UniColors.success
        : status == 'جديد'
        ? UniColors.primaryBlue
        : UniColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: UniColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: UniText(
              application['student']!,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: UniColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: UniText(
              application['company']!,
              style: TextStyle(fontSize: 11, color: UniColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: UniText(
              application['training']!,
              style: TextStyle(fontSize: 11, color: UniColors.textSecondary),
            ),
          ),
          Expanded(
            child: UniText(
              application['date']!,
              style: TextStyle(fontSize: 10.5, color: UniColors.textSecondary),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: UniText(
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
    final newApplications = _intValue(_alerts['newApplications']);
    final reportsToReview = _intValue(_alerts['reportsToReview']);
    final studentsNearCompletion = _intValue(_alerts['studentsNearCompletion']);
    final completedThisWeek = _intValue(_alerts['completedThisWeek']);
    return _dashboardCard(
      title: 'التنبيهات المهمة',
      icon: Icons.notifications_active_rounded,
      child: Column(
        children: [
          _alertItem(
            icon: Icons.assignment_rounded,
            title: 'طلبات تدريب جديدة',
            description:
                'يوجد $newApplications طلب تدريب جديد بحاجة إلى مراجعة.',
            color: UniColors.primaryBlue,
          ),
          _alertItem(
            icon: Icons.description_rounded,
            title: 'تقارير بحاجة للمراجعة',
            description: 'يوجد $reportsToReview تقرير تدريبي بانتظار المراجعة.',
            color: UniColors.warning,
          ),
          _alertItem(
            icon: Icons.access_time_filled_rounded,
            title: 'طلاب قريبون من إكمال التدريب',
            description:
                '$studentsNearCompletion طالب وصل إلى 80% أو أكثر من ساعات التدريب المطلوبة.',
            color: UniColors.primaryGreen,
          ),
          _alertItem(
            icon: Icons.check_circle_rounded,
            title: 'تدريبات مكتملة',
            description:
                'تم إكمال $completedThisWeek تدريبات خلال هذا الأسبوع.',
            color: UniColors.success,
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
            ? Border(bottom: BorderSide(color: UniColors.border))
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
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                UniText(
                  description,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: UniColors.textSecondary,
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
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
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
                  color: UniColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: UniColors.primaryBlue, size: 19),
              ),
              const SizedBox(width: 10),
              UniText(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: UniColors.textPrimary,
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
