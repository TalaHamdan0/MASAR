<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
=======
import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_home_service.dart';
import '../../core/services/university_auth_service.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class UniversityHomeScreen extends StatefulWidget {
  const UniversityHomeScreen({super.key});

  @override
<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
            Expanded(
              flex: 3,
              child: _buildStudentsByMajor(),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: _buildTrainingStatus(),
            ),
=======
            Expanded(flex: 3, child: _buildStudentsByMajor()),
            const SizedBox(width: 20),
            Expanded(flex: 2, child: _buildTrainingStatus()),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
=======
    final staff = _mapOrEmpty(_homeData?['staff']);

    final staffName = staff['name']?.toString() ?? '';

    final termLabel =
        _homeData?['trainingTermLabel']?.toString() ??
        'الفصل التدريبي 2026 / 2027';

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
<<<<<<< HEAD
          colors: [
            MasarColors.primaryBlue,
            MasarColors.darkBlue,
          ],
=======
          colors: [UniColors.primaryBlue, UniColors.darkBlue],
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                const Text(
                  'مرحباً د. محمد العبدالله 👋',
=======
                UniText(
                  'مرحباً ${staffName.isEmpty ? 'بك' : staffName} 👋',
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
<<<<<<< HEAD
                const Text(
                  'تابع أداء الطلبة وإدارة برامج التدريب من مكان واحد.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
=======
                UniText(
                  'تابع أداء الطلبة وإدارة برامج التدريب من مكان واحد.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
=======
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
<<<<<<< HEAD
                      SizedBox(width: 8),
                      Text(
                        'الفصل التدريبي 2026 / 2027',
=======
                      const SizedBox(width: 8),
                      UniText(
                        termLabel,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        final double cardWidth =
            (constraints.maxWidth - 36) / 4;
=======
        final double cardWidth = (constraints.maxWidth - 36) / 4;
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'إجمالي الطلاب',
<<<<<<< HEAD
                value: '1,248',
                subtitle: 'طالب مسجل',
                icon: Icons.people_alt_rounded,
                color: MasarColors.primaryBlue,
                background: MasarColors.lightBlue,
              ),
            ),
=======
                value: _intValue(_statistics['totalStudents']).toString(),
                subtitle: 'طالب مسجل',
                icon: Icons.people_alt_rounded,
                color: UniColors.primaryBlue,
                background: UniColors.lightBlue,
              ),
            ),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الشركات المسجلة',
<<<<<<< HEAD
                value: '86',
                subtitle: 'شركة',
                icon: Icons.business_rounded,
                color: MasarColors.primaryGreen,
                background: MasarColors.lightGreen,
              ),
            ),
=======
                value: _intValue(_statistics['registeredCompanies']).toString(),
                subtitle: 'شركة',
                icon: Icons.business_rounded,
                color: UniColors.primaryGreen,
                background: UniColors.lightGreen,
              ),
            ),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الطلاب بالتدريب',
<<<<<<< HEAD
                value: '142',
                subtitle: 'طالب يتدرب حالياً',
                icon: Icons.school_rounded,
                color: MasarColors.primaryBlue,
                background: MasarColors.lightBlue,
              ),
            ),
=======
                value: _intValue(_statistics['studentsInTraining']).toString(),
                subtitle: 'طالب يتدرب حالياً',
                icon: Icons.school_rounded,
                color: UniColors.primaryBlue,
                background: UniColors.lightBlue,
              ),
            ),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'طلبات جديدة',
<<<<<<< HEAD
                value: '18',
                subtitle: 'تحتاج مراجعة',
                icon: Icons.assignment_rounded,
                color: MasarColors.error,
                background: const Color(0xFFFFEEEE),
=======
                value: _intValue(_statistics['newApplications']).toString(),
                subtitle: 'تحتاج مراجعة',
                icon: Icons.assignment_rounded,
                color: UniColors.error,
                background: UniColors.lightError,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
=======
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
<<<<<<< HEAD
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
=======
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
    final majors = [
      {'name': 'هندسة البرمجيات', 'value': 72},
      {'name': 'علوم الحاسوب', 'value': 58},
      {'name': 'نظم المعلومات', 'value': 46},
      {'name': 'الذكاء الاصطناعي', 'value': 38},
      {'name': 'الأمن السيبراني', 'value': 31},
    ];

=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    return _dashboardCard(
      title: 'الطلاب حسب التخصص',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: majors.map((major) {
<<<<<<< HEAD
          final int value = major['value'] as int;

=======
          final name = major['major']?.toString() ?? '';
          final value = _intValue(major['count']);
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          return Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Row(
              children: [
                SizedBox(
                  width: 115,
<<<<<<< HEAD
                  child: Text(
                    major['name'] as String,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: MasarColors.textPrimary,
=======
                  child: UniText(
                    name,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
<<<<<<< HEAD
=======

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
<<<<<<< HEAD
                      value: value / 100,
                      minHeight: 9,
                      backgroundColor: MasarColors.lightBlue,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MasarColors.primaryBlue,
=======
                      value: maxValue > 0 ? value / maxValue : 0,
                      minHeight: 9,
                      backgroundColor: UniColors.lightBlue,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
<<<<<<< HEAD
                SizedBox(
                  width: 35,
                  child: Text(
=======

                SizedBox(
                  width: 35,
                  child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    '$value',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
<<<<<<< HEAD
                      color: MasarColors.textPrimary,
=======
                      color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
=======
    final percentage = _doubleValue(_homeData?['completionPercentage']);
    final progressValue = (percentage / 100).clamp(0.0, 1.0);
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
            '142',
            MasarColors.primaryBlue,
=======
            '${_statusCount('ACTIVE')}',
            UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          const SizedBox(height: 10),
          _statusRow(
            'مكتمل',
<<<<<<< HEAD
            '86',
            MasarColors.primaryGreen,
=======
            '${_statusCount('COMPLETED')}',
            UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          const SizedBox(height: 10),
          _statusRow(
            'لم يبدأ',
<<<<<<< HEAD
            '34',
            MasarColors.warning,
=======
            '${_statusCount('SELECTED')}',
            UniColors.warning,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
<<<<<<< HEAD
            color: MasarColors.textPrimary,
=======
            color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationsTable() {
<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    );
  }

  Widget _applicationRow(Map<String, String> application) {
    final String status = application['status']!;

    final Color statusColor = status == 'مقبول'
<<<<<<< HEAD
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
=======
        ? UniColors.success
        : status == 'جديد'
        ? UniColors.primaryBlue
        : UniColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: UniColors.border)),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
<<<<<<< HEAD
            child: Text(
=======
            child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              application['student']!,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
<<<<<<< HEAD
                color: MasarColors.textPrimary,
=======
                color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
            ),
          ),
          Expanded(
            flex: 2,
<<<<<<< HEAD
            child: Text(
              application['company']!,
              style: TextStyle(
                fontSize: 11,
                color: MasarColors.textSecondary,
              ),
=======
            child: UniText(
              application['company']!,
              style: TextStyle(fontSize: 11, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ),
          ),
          Expanded(
            flex: 2,
<<<<<<< HEAD
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
=======
            child: UniText(
              application['training']!,
              style: TextStyle(fontSize: 11, color: UniColors.textSecondary),
            ),
          ),
          Expanded(
            child: UniText(
              application['date']!,
              style: TextStyle(fontSize: 10.5, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
<<<<<<< HEAD
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
=======
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
<<<<<<< HEAD
                child: Text(
=======
                child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
=======
    final newApplications = _intValue(_alerts['newApplications']);
    final reportsToReview = _intValue(_alerts['reportsToReview']);
    final studentsNearCompletion = _intValue(_alerts['studentsNearCompletion']);
    final completedThisWeek = _intValue(_alerts['completedThisWeek']);
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    return _dashboardCard(
      title: 'التنبيهات المهمة',
      icon: Icons.notifications_active_rounded,
      child: Column(
        children: [
          _alertItem(
            icon: Icons.assignment_rounded,
            title: 'طلبات تدريب جديدة',
<<<<<<< HEAD
            description: 'يوجد 18 طلب تدريب جديد بحاجة إلى مراجعة.',
            color: MasarColors.primaryBlue,
=======
            description:
                'يوجد $newApplications طلب تدريب جديد بحاجة إلى مراجعة.',
            color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          _alertItem(
            icon: Icons.description_rounded,
            title: 'تقارير بحاجة للمراجعة',
<<<<<<< HEAD
            description: 'يوجد 5 تقارير تدريبية بانتظار المراجعة.',
            color: MasarColors.warning,
=======
            description: 'يوجد $reportsToReview تقرير تدريبي بانتظار المراجعة.',
            color: UniColors.warning,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          _alertItem(
            icon: Icons.access_time_filled_rounded,
            title: 'طلاب قريبون من إكمال التدريب',
<<<<<<< HEAD
            description: '12 طالباً اقتربوا من إكمال 280 ساعة تدريبية.',
            color: MasarColors.primaryGreen,
=======
            description:
                '$studentsNearCompletion طالب وصل إلى 80% أو أكثر من ساعات التدريب المطلوبة.',
            color: UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          _alertItem(
            icon: Icons.check_circle_rounded,
            title: 'تدريبات مكتملة',
<<<<<<< HEAD
            description: 'تم إكمال 8 تدريبات خلال هذا الأسبوع.',
            color: MasarColors.success,
=======
            description:
                'تم إكمال $completedThisWeek تدريبات خلال هذا الأسبوع.',
            color: UniColors.success,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
            ? Border(
                bottom: BorderSide(color: MasarColors.border),
              )
=======
            ? Border(bottom: BorderSide(color: UniColors.border))
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                Text(
=======
                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
<<<<<<< HEAD
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: MasarColors.textSecondary,
=======
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                UniText(
                  description,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
<<<<<<< HEAD
            color: MasarColors.textSecondary,
=======
            color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
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
=======
                  color: UniColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: UniColors.primaryBlue, size: 19),
              ),
              const SizedBox(width: 10),
              UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
<<<<<<< HEAD
                  color: MasarColors.textPrimary,
=======
                  color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
