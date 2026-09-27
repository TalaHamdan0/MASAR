
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';
import '../../core/widgets/uni_dashboard_header.dart';
import 'university_home_screen.dart';
import 'students_screen.dart';
import 'companies_screen.dart';

import 'applications_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'university_login_screen.dart';

class CurrentTrainingsScreen extends StatefulWidget {
  const CurrentTrainingsScreen({super.key});

  @override
  State<CurrentTrainingsScreen> createState() =>
      _CurrentTrainingsScreenState();
}

class _CurrentTrainingsScreenState extends State<CurrentTrainingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'الكل';

  final List<Map<String, dynamic>> _trainings = [
    {
      'studentName': 'تالا حمدان',
      'studentId': '20231001',
      'major': 'هندسة البرمجيات',
      'company': 'Data Solutions',
      'careerPath': 'تحليل البيانات',
      'startDate': '01/09/2026',
      'endDate': '30/11/2026',
      'hours': 164,
      'totalHours': 280,
      'status': 'مستمر',
      'evaluation': {
        'status': 'لم يصل',
        'overallRating': 0,
        'commitmentRating': 0,
        'notes': '',
        'date': '',
      },
    },
    {
      'studentName': 'ليان أحمد',
      'studentId': '20231002',
      'major': 'علوم الحاسوب',
      'company': 'Creative Hub',
      'careerPath': 'التصميم',
      'startDate': '01/09/2026',
      'endDate': '30/11/2026',
      'hours': 210,
      'totalHours': 280,
      'status': 'قريب من الإنجاز',
      'evaluation': {
        'status': 'وصل',
        'overallRating': 4,
        'commitmentRating': 5,
        'notes': 'الطالبة ملتزمة بالحضور وتؤدي المهام المطلوبة بشكل جيد.',
        'date': '20/09/2026',
      },
    },
    {
      'studentName': 'رنا سمير',
      'studentId': '20231003',
      'major': 'هندسة البرمجيات',
      'company': 'شركة التقنية المتقدمة',
      'careerPath': 'تطوير التطبيقات',
      'startDate': '01/09/2026',
      'endDate': '30/11/2026',
      'hours': 245,
      'totalHours': 280,
      'status': 'قريب من الإنجاز',
      'evaluation': {
        'status': 'وصل',
        'overallRating': 5,
        'commitmentRating': 5,
        'notes': 'أداء ممتاز والتزام واضح خلال فترة التدريب.',
        'date': '22/09/2026',
      },
    },
    {
      'studentName': 'محمد يوسف',
      'studentId': '20231004',
      'major': 'الأمن السيبراني',
      'company': 'SecureNet',
      'careerPath': 'الأمن السيبراني',
      'startDate': '05/09/2026',
      'endDate': '30/11/2026',
      'hours': 98,
      'totalHours': 280,
      'status': 'مستمر',
      'evaluation': {
        'status': 'لم يصل',
        'overallRating': 0,
        'commitmentRating': 0,
        'notes': '',
        'date': '',
      },
    },
    {
      'studentName': 'نور علي',
      'studentId': '20231005',
      'major': 'هندسة البرمجيات',
      'company': 'Quality First',
      'careerPath': 'ضمان الجودة',
      'startDate': '01/08/2026',
      'endDate': '30/10/2026',
      'hours': 280,
      'totalHours': 280,
      'status': 'مكتمل',
      'evaluation': {
        'status': 'وصل',
        'overallRating': 4,
        'commitmentRating': 4,
        'notes': 'التزام جيد طوال فترة التدريب.',
        'date': '25/10/2026',
      },
    },
    {
      'studentName': 'أحمد محمد',
      'studentId': '20231006',
      'major': 'علوم الحاسوب',
      'company': 'Jordan Tech',
      'careerPath': 'تطوير الويب',
      'startDate': '10/09/2026',
      'endDate': '10/12/2026',
      'hours': 132,
      'totalHours': 280,
      'status': 'متأخر',
      'evaluation': {
        'status': 'لم يصل',
        'overallRating': 0,
        'commitmentRating': 0,
        'notes': '',
        'date': '',
      },
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    if (index == 4) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = const UniversityHomeScreen();
        break;

      case 1:
        screen = const StudentsScreen();
        break;

      case 2:
        screen = const CompaniesScreen();
        break;

      case 3:
        screen = const ApplicationsScreen();
        break;

      case 4:
        return;

      case 5:
        screen = const ReportsScreen();
        break;

      case 6:
        screen = const NotificationsScreen();
        break;

      case 7:
        screen = const SettingsScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const UniversityLoginScreen(),
      ),
      (route) => false,
    );
  }

  List<Map<String, dynamic>> get _filteredTrainings {
    final query = _searchController.text.trim().toLowerCase();

    return _trainings.where((training) {
      final matchesSearch =
          query.isEmpty ||
          training['studentName'].toString().toLowerCase().contains(query) ||
          training['studentId'].toString().toLowerCase().contains(query) ||
          training['company'].toString().toLowerCase().contains(query) ||
          training['careerPath'].toString().toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatus == 'الكل' ||
          training['status'].toString() == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  int get _totalTrainings => _trainings.length;

  int get _ongoingTrainings =>
      _trainings.where((e) => e['status'] == 'مستمر').length;

  int get _nearCompletionTrainings =>
      _trainings.where((e) => e['status'] == 'قريب من الإنجاز').length;

  int get _completedTrainings =>
      _trainings.where((e) => e['status'] == 'مكتمل').length;

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
                    const UniDashboardHeader(
                      title: 'التدريبات الحالية',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPageIntro(),
                            const SizedBox(height: 24),
                            _buildStatistics(),
                            const SizedBox(height: 24),
                            _buildFilters(),
                            const SizedBox(height: 20),
                            _buildTrainingsTable(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UniDashboardSidebar(
              selectedIndex: 4,
              onItemSelected: _navigateTo,
              onLogout: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التدريبات الحالية',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'متابعة الطلاب المسجلين حاليًا في برامج التدريب الميداني',
          style: TextStyle(
            fontSize: 14,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'إجمالي التدريبات',
            value: '$_totalTrainings',
            icon: Icons.school_rounded,
            color: MasarColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'تدريبات مستمرة',
            value: '$_ongoingTrainings',
            icon: Icons.play_circle_outline_rounded,
            color: MasarColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'قريبة من الإنجاز',
            value: '$_nearCompletionTrainings',
            icon: Icons.timelapse_rounded,
            color: MasarColors.warning,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'مكتملة',
            value: '$_completedTrainings',
            icon: Icons.check_circle_outline_rounded,
            color: MasarColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: MasarColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: MasarColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'ابحث باسم الطالب أو الرقم الجامعي أو الشركة...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: MasarColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 190,
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'حالة التدريب',
                filled: true,
                fillColor: MasarColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'الكل',
                  child: Text('الكل'),
                ),
                DropdownMenuItem(
                  value: 'مستمر',
                  child: Text('مستمر'),
                ),
                DropdownMenuItem(
                  value: 'قريب من الإنجاز',
                  child: Text('قريب من الإنجاز'),
                ),
                DropdownMenuItem(
                  value: 'مكتمل',
                  child: Text('مكتمل'),
                ),
                DropdownMenuItem(
                  value: 'متأخر',
                  child: Text('متأخر'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value ?? 'الكل';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingsTable() {
    final trainings = _filteredTrainings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قائمة التدريبات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: DataTable(
                    headingRowHeight: 52,
                    dataRowMinHeight: 68,
                    dataRowMaxHeight: 78,
                    columnSpacing: 28,
                    headingTextStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MasarColors.textPrimary,
                    ),
                    columns: const [
                      DataColumn(label: Text('الطالب')),
                      DataColumn(label: Text('الشركة')),
                      DataColumn(label: Text('المسار')),
                      DataColumn(label: Text('الفترة')),
                      DataColumn(label: Text('ساعات التدريب')),
                      DataColumn(label: Text('التقييم السري')),
                      DataColumn(label: Text('الحالة')),
                      DataColumn(label: Text('التفاصيل')),
                    ],
                    rows: trainings.map((training) {
                      final hours = training['hours'] as int;
                      final totalHours = training['totalHours'] as int;

                      final evaluation =
                          training['evaluation'] as Map<String, dynamic>;

                      final evaluationReceived =
                          evaluation['status'] == 'وصل';

                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  training['studentName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: MasarColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  training['studentId'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MasarColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              training['company'],
                              style: TextStyle(
                                color: MasarColors.textPrimary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              training['careerPath'],
                              style: TextStyle(
                                color: MasarColors.textPrimary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${training['startDate']} - ${training['endDate']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: MasarColors.textSecondary,
                              ),
                            ),
                          ),
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$hours / $totalHours',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: MasarColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    value: hours / totalHours,
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: MasarColors.border,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      MasarColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            evaluationReceived
                                ? OutlinedButton.icon(
                                    onPressed: () {
                                      _showSecretEvaluation(
                                        training,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.lock_outline_rounded,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'عرض التقييم',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          MasarColors.primaryGreen,
                                      side: BorderSide(
                                        color: MasarColors.primaryGreen
                                            .withOpacity(0.45),
                                      ),
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 9,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                  )
                                : _buildEvaluationNotReceived(),
                          ),
                          DataCell(
                            _buildStatusChip(
                              training['status'].toString(),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              tooltip: 'عرض التفاصيل',
                              icon: Icon(
                                Icons.visibility_outlined,
                                color: MasarColors.primaryBlue,
                              ),
                              onPressed: () {
                                _showTrainingDetails(training);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          if (trainings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Text(
                  'لا توجد تدريبات مطابقة للبحث أو الفلتر',
                  style: TextStyle(
                    color: MasarColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEvaluationNotReceived() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: MasarColors.textSecondary,
          ),
          const SizedBox(width: 5),
          Text(
            'لم يصل',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    Color background;

    switch (status) {
      case 'مستمر':
        color = MasarColors.primaryGreen;
        background = MasarColors.lightGreen;
        break;
      case 'قريب من الإنجاز':
        color = MasarColors.warning;
        background = MasarColors.warning.withOpacity(0.10);
        break;
      case 'مكتمل':
        color = MasarColors.primaryBlue;
        background = MasarColors.lightBlue;
        break;
      case 'متأخر':
        color = MasarColors.error;
        background = MasarColors.error.withOpacity(0.08);
        break;
      default:
        color = MasarColors.textSecondary;
        background = MasarColors.background;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _showTrainingDetails(Map<String, dynamic> training) {
    final hours = training['hours'] as int;
    final totalHours = training['totalHours'] as int;

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: MasarColors.white,
            titlePadding: const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              8,
            ),
            contentPadding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              24,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'تفاصيل التدريب',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            content: SizedBox(
              width: 700,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection(
                      title: 'بيانات الطالب',
                      icon: Icons.person_outline_rounded,
                      children: [
                        _buildDetailRow(
                          'اسم الطالب',
                          training['studentName'],
                        ),
                        _buildDetailRow(
                          'الرقم الجامعي',
                          training['studentId'],
                        ),
                        _buildDetailRow(
                          'التخصص',
                          training['major'],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDetailSection(
                      title: 'بيانات التدريب',
                      icon: Icons.business_center_outlined,
                      children: [
                        _buildDetailRow(
                          'جهة التدريب',
                          training['company'],
                        ),
                        _buildDetailRow(
                          'المسار المهني',
                          training['careerPath'],
                        ),
                        _buildDetailRow(
                          'تاريخ البداية',
                          training['startDate'],
                        ),
                        _buildDetailRow(
                          'تاريخ النهاية',
                          training['endDate'],
                        ),
                        _buildDetailRow(
                          'حالة التدريب',
                          training['status'],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDetailSection(
                      title: 'ساعات التدريب',
                      icon: Icons.access_time_rounded,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$hours / $totalHours ساعة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: MasarColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${((hours / totalHours) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: MasarColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: hours / totalHours,
                          minHeight: 9,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: MasarColors.border,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(
                            MasarColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSecretEvaluationPreview(training),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecretEvaluationPreview(
    Map<String, dynamic> training,
  ) {
    final evaluation =
        training['evaluation'] as Map<String, dynamic>;

    final received = evaluation['status'] == 'وصل';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: received
              ? MasarColors.primaryGreen.withOpacity(0.35)
              : MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_rounded,
                color: MasarColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تقييم جهة التدريب السري',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ),
              if (received)
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSecretEvaluation(training);
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 17,
                  ),
                  label: const Text('عرض التقييم'),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'التقييم سري وغير متاح للطالب',
            style: TextStyle(
              fontSize: 12,
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          if (!received)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: MasarColors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                'لم يتم استلام التقييم السري من جهة التدريب حتى الآن.',
                style: TextStyle(
                  fontSize: 13,
                  color: MasarColors.textSecondary,
                ),
              ),
            )
          else
            Text(
              'تم استلام التقييم السري. اضغط على "عرض التقييم" لعرض التفاصيل.',
              style: TextStyle(
                fontSize: 13,
                color: MasarColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  void _showSecretEvaluation(
    Map<String, dynamic> training,
  ) {
    final evaluation =
        training['evaluation'] as Map<String, dynamic>;

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: MasarColors.white,
            titlePadding: const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              8,
            ),
            contentPadding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              24,
            ),
            title: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        MasarColors.primaryGreen.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: MasarColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التقييم السري',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'تقييم جهة التدريب - سري عن الطالب',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: MasarColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            content: SizedBox(
              width: 620,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MasarColors.lightGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business_rounded,
                            color: MasarColors.darkGreen,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  training['company'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        MasarColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${training['studentName']} • ${training['studentId']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        MasarColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEvaluationRatingCard(
                      title: 'التقييم العام',
                      rating:
                          evaluation['overallRating'] as int,
                    ),
                    const SizedBox(height: 12),
                    _buildEvaluationRatingCard(
                      title: 'الالتزام والانضباط',
                      rating:
                          evaluation['commitmentRating'] as int,
                    ),
                    if (evaluation['notes']
                        .toString()
                        .trim()
                        .isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Text(
                        'ملاحظات جهة التدريب',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: MasarColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: MasarColors.border,
                          ),
                        ),
                        child: Text(
                          evaluation['notes'],
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: MasarColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                    if (evaluation['date']
                        .toString()
                        .trim()
                        .isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'تاريخ إرسال التقييم',
                        evaluation['date'],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEvaluationRatingCard({
    required String title,
    required int rating,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MasarColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
          Row(
            children: List.generate(
              5,
              (index) {
                return Icon(
                  index < rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 21,
                  color: index < rating
                      ? MasarColors.warning
                      : MasarColors.border,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$rating / 5',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: MasarColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: MasarColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

