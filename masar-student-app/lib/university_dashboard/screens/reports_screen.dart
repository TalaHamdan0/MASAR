import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_reports_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = 'هذا الشهر';

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
                      UniText(
                        'التقارير والإحصائيات',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: UniColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      UniText(
                        'نظرة شاملة على أداء التدريب والطلاب',
                        style: TextStyle(
                          fontSize: 13,
                          color: UniColors.textSecondary,
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
                      color: UniColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: UniColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: UniColors.textSecondary,
                        ),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: UniColors.textPrimary,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'هذا الأسبوع',
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
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedPeriod = value;
                            });

                            _loadReports();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 20,
                color: UniColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 18),
          UniText(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: UniColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          UniText(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: UniColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          UniText(
            subtitle,
            style: TextStyle(fontSize: 10.5, color: UniColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _hoursOverview() {
    return Container(
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: UniColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: UniColors.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UniText(
                    'نظرة عامة على الساعات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: UniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  UniText(
                    'توزيع الطلاب حسب الساعات المكتملة',
                    style: TextStyle(
                      fontSize: 11,
                      color: UniColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              child: UniText(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: UniColors.textPrimary,
                ),
              ),
            ),
            UniText(
              count,
              style: TextStyle(fontSize: 11, color: UniColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 9,
            backgroundColor: UniColors.lightBlue,
            valueColor: AlwaysStoppedAnimation<Color>(UniColors.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _companyReport() {
    return Container(
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: UniColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.business_rounded,
                  color: UniColors.primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: UniText(
                  'تقرير الشركات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
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
        ],
      ),
    );
  }

  Widget _companyRow(String name, String students, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: UniText(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: UniColors.textPrimary,
                ),
              ),
            ),
            UniText(
              students,
              style: TextStyle(
                fontSize: 10.5,
                color: UniColors.textSecondary,
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
            backgroundColor: UniColors.lightGreen,
            valueColor: AlwaysStoppedAnimation<Color>(UniColors.primaryGreen),
          ),
        ),
      ],
    );
  }
}