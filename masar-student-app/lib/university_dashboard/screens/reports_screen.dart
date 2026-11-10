<<<<<<< HEAD

import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
=======
import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_reports_service.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = 'هذا الشهر';

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
=======
  Map<String, dynamic> _statistics = {};

  List<Map<String, dynamic>> _hoursOverviewData = [];

  List<Map<String, dynamic>> _companyReportData = [];

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await UniversityReportsService.fetchReports(
        period: selectedPeriod,
      );

      final statisticsData = result['statistics'];
      final hoursData = result['hoursOverview'] as List? ?? [];
      final companiesData = result['companyReport'] as List? ?? [];

      if (!mounted) return;

      setState(() {
        _statistics = statisticsData is Map
            ? Map<String, dynamic>.from(statisticsData)
            : {};

        _hoursOverviewData = hoursData
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        _companyReportData = companiesData
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  int _getNumber(String key) {
    return int.tryParse(_statistics[key]?.toString() ?? '0') ?? 0;
  }

  double _getRatio(dynamic value) {
    final ratio = double.tryParse(value?.toString() ?? '0') ?? 0;
    return ratio.clamp(0.0, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
<<<<<<< HEAD
                      Text(
=======
                      UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        'التقارير والإحصائيات',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
<<<<<<< HEAD
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'نظرة شاملة على أداء التدريب والطلاب',
                        style: TextStyle(
                          fontSize: 13,
                          color: MasarColors.textSecondary,
=======
                          color: UniColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      UniText(
                        'نظرة شاملة على أداء التدريب والطلاب',
                        style: TextStyle(
                          fontSize: 13,
                          color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
<<<<<<< HEAD
                      color: MasarColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: MasarColors.border),
=======
                      color: UniColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
<<<<<<< HEAD
                          color: MasarColors.textSecondary,
=======
                          color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
<<<<<<< HEAD
                          color: MasarColors.textPrimary,
=======
                          color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'هذا الأسبوع',
<<<<<<< HEAD
                            child: Text('هذا الأسبوع'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا الشهر',
                            child: Text('هذا الشهر'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا الفصل',
                            child: Text('هذا الفصل'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا العام',
                            child: Text('هذا العام'),
=======
                            child: UniText('هذا الأسبوع'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا الشهر',
                            child: UniText('هذا الشهر'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا الفصل',
                            child: UniText('هذا الفصل'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا العام',
                            child: UniText('هذا العام'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedPeriod = value;
                            });
<<<<<<< HEAD
=======

                            _loadReports();
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
<<<<<<< HEAD
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'الطلاب المتدربون',
                      value: '346',
                      subtitle: 'طالب نشط في التدريب',
                      icon: Icons.people_alt_rounded,
                      iconColor: MasarColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'نسبة الإكمال',
                      value: '74%',
                      subtitle: 'من إجمالي التدريبات',
                      icon: Icons.donut_large_rounded,
                      iconColor: MasarColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'أكملوا 280 ساعة',
                      value: '254',
                      subtitle: 'طالب أكمل الساعات',
                      icon: Icons.check_circle_outline,
                      iconColor: MasarColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'متوسط الساعات',
                      value: '207',
                      subtitle: 'ساعة لكل طالب',
                      icon: Icons.access_time_rounded,
                      iconColor: MasarColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _hoursOverview(),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 2,
                    child: _companyReport(),
                  ),
                ],
              ),
=======

              if (_isLoading) ...[
                const SizedBox(height: 120),
                const Center(child: CircularProgressIndicator()),
              ] else if (_errorMessage != null) ...[
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      UniText(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: UniColors.error,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadReports,
                        child: const UniText('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        title: 'الطلاب المتدربون',
                        value: _getNumber('studentsInTraining').toString(),
                        subtitle: 'طالب نشط في التدريب',
                        icon: Icons.people_alt_rounded,
                        iconColor: UniColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statCard(
                        title: 'نسبة الإكمال',
                        value: '${_getNumber('completionRate')}%',
                        subtitle: 'من إجمالي التدريبات',
                        icon: Icons.donut_large_rounded,
                        iconColor: UniColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statCard(
                        title: 'أكملوا 280 ساعة',
                        value: _getNumber('completed280Hours').toString(),
                        subtitle: 'طالب أكمل الساعات',
                        icon: Icons.check_circle_outline,
                        iconColor: UniColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statCard(
                        title: 'متوسط الساعات',
                        value: _getNumber('averageHours').toString(),
                        subtitle: 'ساعة لكل طالب',
                        icon: Icons.access_time_rounded,
                        iconColor: UniColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _hoursOverview()),
                    const SizedBox(width: 18),
                    Expanded(flex: 2, child: _companyReport()),
                  ],
                ),
              ],
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
<<<<<<< HEAD
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
=======
                child: Icon(icon, color: iconColor, size: 22),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 20,
<<<<<<< HEAD
                color: MasarColors.textSecondary,
=======
                color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
            ],
          ),
          const SizedBox(height: 18),
<<<<<<< HEAD
          Text(
=======
          UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
<<<<<<< HEAD
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
=======
              color: UniColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
<<<<<<< HEAD
              color: MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.5,
              color: MasarColors.textSecondary,
            ),
=======
              color: UniColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          UniText(
            subtitle,
            style: TextStyle(fontSize: 10.5, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ],
      ),
    );
  }

  Widget _hoursOverview() {
    return Container(
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color: MasarColors.lightBlue,
=======
                  color: UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
<<<<<<< HEAD
                  color: MasarColors.primaryBlue,
=======
                  color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  Text(
=======
                  UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    'نظرة عامة على الساعات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
<<<<<<< HEAD
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'توزيع الطلاب حسب الساعات المكتملة',
                    style: TextStyle(
                      fontSize: 11,
                      color: MasarColors.textSecondary,
=======
                      color: UniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  UniText(
                    'توزيع الطلاب حسب الساعات المكتملة',
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
<<<<<<< HEAD
          const SizedBox(height: 25),
          _progressRow(
            title: 'أقل من 100 ساعة',
            value: 0.18,
            count: '62 طالب',
          ),
          const SizedBox(height: 18),
          _progressRow(
            title: '100 - 200 ساعة',
            value: 0.26,
            count: '90 طالب',
          ),
          const SizedBox(height: 18),
          _progressRow(
            title: '200 - 279 ساعة',
            value: 0.29,
            count: '100 طالب',
          ),
          const SizedBox(height: 18),
          _progressRow(
            title: '280 ساعة أو أكثر',
            value: 0.27,
            count: '94 طالب',
          ),
=======
          const SizedBox(height: 25), //
          if (_hoursOverviewData.isEmpty)
            UniText(
              'لا توجد بيانات ساعات تدريب لهذه الفترة',
              style: TextStyle(fontSize: 12, color: UniColors.textSecondary),
            )
          else
            ..._hoursOverviewData.asMap().entries.map((entry) {
              final item = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == _hoursOverviewData.length - 1 ? 0 : 18,
                ),
                child: _progressRow(
                  title: item['title'].toString(),
                  value: _getRatio(item['ratio']),
                  count: '${item['count']} طالب',
                ),
              );
            }),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ],
      ),
    );
  }

  Widget _progressRow({
    required String title,
    required double value,
    required String count,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
<<<<<<< HEAD
              child: Text(
=======
              child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
<<<<<<< HEAD
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: 11,
                color: MasarColors.textSecondary,
              ),
=======
                  color: UniColors.textPrimary,
                ),
              ),
            ),
            UniText(
              count,
              style: TextStyle(fontSize: 11, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 9,
<<<<<<< HEAD
            backgroundColor: MasarColors.lightBlue,
            valueColor: AlwaysStoppedAnimation<Color>(
              MasarColors.primaryBlue,
            ),
=======
            backgroundColor: UniColors.lightBlue,
            valueColor: AlwaysStoppedAnimation<Color>(UniColors.primaryBlue),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
      ],
    );
  }

  Widget _companyReport() {
    return Container(
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color: MasarColors.lightGreen,
=======
                  color: UniColors.lightGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.business_rounded,
<<<<<<< HEAD
                  color: MasarColors.primaryGreen,
=======
                  color: UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
<<<<<<< HEAD
                child: Text(
=======
                child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  'تقرير الشركات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
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
<<<<<<< HEAD
          const SizedBox(height: 24),
          _companyRow('شركة التقنية', '42 طالب', 0.82),
          const SizedBox(height: 18),
          _companyRow('شركة البرمجيات', '36 طالب', 0.71),
          const SizedBox(height: 18),
          _companyRow('شركة الحلول الرقمية', '29 طالب', 0.64),
          const SizedBox(height: 18),
          _companyRow('شركة المستقبل', '24 طالب', 0.52),
=======
          const SizedBox(height: 24), //
          if (_companyReportData.isEmpty)
            UniText(
              'لا توجد بيانات شركات لهذه الفترة',
              style: TextStyle(fontSize: 12, color: UniColors.textSecondary),
            )
          else
            ..._companyReportData.asMap().entries.map((entry) {
              final item = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == _companyReportData.length - 1 ? 0 : 18,
                ),
                child: _companyRow(
                  item['name'].toString(),
                  '${item['students']} طالب',
                  _getRatio(item['ratio']),
                ),
              );
            }),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _companyRow(
    String name,
    String students,
    double value,
  ) {
=======
  Widget _companyRow(String name, String students, double value) {
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
<<<<<<< HEAD
              child: Text(
=======
              child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
<<<<<<< HEAD
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
            Text(
              students,
              style: TextStyle(
                fontSize: 10.5,
                color: MasarColors.textSecondary,
=======
                  color: UniColors.textPrimary,
                ),
              ),
            ),
            UniText(
              students,
              style: TextStyle(
                fontSize: 10.5,
                color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
<<<<<<< HEAD
            backgroundColor: MasarColors.lightGreen,
            valueColor: AlwaysStoppedAnimation<Color>(
              MasarColors.primaryGreen,
            ),
=======
            backgroundColor: UniColors.lightGreen,
            valueColor: AlwaysStoppedAnimation<Color>(UniColors.primaryGreen),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
      ],
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
