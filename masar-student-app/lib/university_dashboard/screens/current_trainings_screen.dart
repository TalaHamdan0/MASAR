import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_current_trainings_service.dart';

class CurrentTrainingsScreen extends StatefulWidget {
  const CurrentTrainingsScreen({super.key});

  @override
  State<CurrentTrainingsScreen> createState() => _CurrentTrainingsScreenState();
}

class _CurrentTrainingsScreenState extends State<CurrentTrainingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'الكل';

  List<Map<String, dynamic>> _trainings = [];

  Map<String, dynamic> _statistics = {};

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  Future<void> _loadTrainings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await UniversityCurrentTrainingsService.fetchTrainings();

      final trainingsData = result['trainings'] as List? ?? [];
      final statisticsData = result['statistics'];

      if (!mounted) return;

      setState(() {
        _trainings = trainingsData
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        _statistics = statisticsData is Map
            ? Map<String, dynamic>.from(statisticsData)
            : {};

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  int _getStat(String key) {
    return int.tryParse(_statistics[key]?.toString() ?? '0') ?? 0;
  }

  int get _totalTrainings => _getStat('totalTrainings');

  int get _ongoingTrainings => _getStat('ongoingTrainings');

  int get _nearCompletionTrainings => _getStat('nearCompletionTrainings');

  int get _completedTrainings => _getStat('completedTrainings');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
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
    );
  }

  Widget _buildPageIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UniText(
          'التدريبات الحالية',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: UniColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        UniText(
          'متابعة الطلاب المسجلين حاليًا في برامج التدريب الميداني',
          style: TextStyle(fontSize: 14, color: UniColors.textSecondary),
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
            color: UniColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'تدريبات مستمرة',
            value: '$_ongoingTrainings',
            icon: Icons.play_circle_outline_rounded,
            color: UniColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'قريبة من الإنجاز',
            value: '$_nearCompletionTrainings',
            icon: Icons.timelapse_rounded,
            color: UniColors.warning,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'مكتملة',
            value: '$_completedTrainings',
            icon: Icons.check_circle_outline_rounded,
            color: UniColors.success,
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
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
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
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                UniText(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: UniLocalizations.translate(
                  'ابحث باسم الطالب أو الرقم الجامعي أو الشركة...',
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: UniColors.background,
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
                labelText: UniLocalizations.translate('حالة التدريب'),
                filled: true,
                fillColor: UniColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'الكل', child: UniText('الكل')),
                DropdownMenuItem(value: 'مستمر', child: UniText('مستمر')),
                DropdownMenuItem(
                  value: 'قريب من الإنجاز',
                  child: UniText('قريب من الإنجاز'),
                ),
                DropdownMenuItem(value: 'مكتمل', child: UniText('مكتمل')),
                DropdownMenuItem(value: 'متأخر', child: UniText('متأخر')),
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
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UniText(
            'قائمة التدريبات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: UniColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  UniText(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: UniColors.error, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadTrainings,
                    child: const UniText('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          else if (trainings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: UniText(
                  'لا توجد تدريبات مطابقة للبحث أو الفلتر',
                  style: TextStyle(
                    color: UniColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowHeight: 52,
                      dataRowMinHeight: 68,
                      dataRowMaxHeight: 78,
                      columnSpacing: 28,
                      headingTextStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: UniColors.textPrimary,
                      ),
                      columns: const [
                        DataColumn(label: UniText('الطالب')),
                        DataColumn(label: UniText('الشركة')),
                        DataColumn(label: UniText('المسار')),
                        DataColumn(label: UniText('الفترة')),
                        DataColumn(label: UniText('ساعات التدريب')),
                        DataColumn(label: UniText('التقييم السري')),
                        DataColumn(label: UniText('الحالة')),
                        DataColumn(label: UniText('التفاصيل')),
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
                                  UniText(
                                    training['studentName'].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: UniColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  UniText(
                                    training['studentId'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: UniColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(UniText(training['company'].toString())),
                            DataCell(
                              UniText(training['careerPath'].toString()),
                            ),
                            DataCell(
                              UniText(
                                '${training['startDate']} - ${training['endDate']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: UniColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UniText(
                                    '$hours / $totalHours',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: UniColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 100,
                                    child: LinearProgressIndicator(
                                      value: hours / totalHours,
                                      minHeight: 6,
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor: UniColors.border,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        UniColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              evaluationReceived
                                  ? OutlinedButton.icon(
                                      onPressed: () =>
                                          _showSecretEvaluation(training),
                                      icon: const Icon(
                                        Icons.lock_outline_rounded,
                                        size: 16,
                                      ),
                                      label: const UniText('عرض التقييم'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: UniColors.primaryGreen,
                                        side: BorderSide(
                                          color: UniColors.primaryGreen
                                              .withOpacity(0.45),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 9,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    )
                                  : _buildEvaluationNotReceived(),
                            ),
                            DataCell(
                              _buildStatusChip(training['status'].toString()),
                            ),
                            DataCell(
                              IconButton(
                                tooltip: UniLocalizations.translate(
                                  'عرض التفاصيل',
                                ),
                                icon: Icon(
                                  Icons.visibility_outlined,
                                  color: UniColors.primaryBlue,
                                ),
                                onPressed: () => _showTrainingDetails(training),
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
        ],
      ),
    );
  }

  Widget _buildEvaluationNotReceived() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: UniColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: UniColors.textSecondary,
          ),
          const SizedBox(width: 5),
          UniText(
            'لم يصل',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: UniColors.textSecondary,
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
        color = UniColors.primaryGreen;
        background = UniColors.lightGreen;
        break;
      case 'قريب من الإنجاز':
        color = UniColors.warning;
        background = UniColors.warning.withOpacity(0.10);
        break;
      case 'مكتمل':
        color = UniColors.primaryBlue;
        background = UniColors.lightBlue;
        break;
      case 'متأخر':
        color = UniColors.error;
        background = UniColors.error.withOpacity(0.08);
        break;
      default:
        color = UniColors.textSecondary;
        background = UniColors.background;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: UniText(
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
      builder: (dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: UniColors.white,
            titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            title: Row(
              children: [
                Expanded(
                  child: UniText(
                    'تفاصيل التدريب',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: UniColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
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
                          training['studentName'].toString(),
                        ),
                        _buildDetailRow(
                          'الرقم الجامعي',
                          training['studentId'].toString(),
                        ),
                        _buildDetailRow('التخصص', training['major'].toString()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDetailSection(
                      title: 'بيانات التدريب',
                      icon: Icons.business_center_outlined,
                      children: [
                        _buildDetailRow(
                          'جهة التدريب',
                          training['company'].toString(),
                        ),
                        _buildDetailRow(
                          'المسار المهني',
                          training['careerPath'].toString(),
                        ),
                        _buildDetailRow(
                          'تاريخ البداية',
                          training['startDate'].toString(),
                        ),
                        _buildDetailRow(
                          'تاريخ النهاية',
                          training['endDate'].toString(),
                        ),
                        _buildDetailRow(
                          'حالة التدريب',
                          training['status'].toString(),
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
                            UniText(
                              '$hours / $totalHours ساعة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: UniColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            UniText(
                              '${((hours / totalHours) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: UniColors.textSecondary,
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
                          backgroundColor: UniColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            UniColors.primaryBlue,
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

  Widget _buildSecretEvaluationPreview(Map<String, dynamic> training) {
    final evaluation = training['evaluation'] as Map<String, dynamic>;
    final received = evaluation['status'] == 'وصل';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: UniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: received
              ? UniColors.primaryGreen.withOpacity(0.35)
              : UniColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_rounded, color: UniColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: UniText(
                  'تقييم جهة التدريب السري',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
              ),
              if (received)
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSecretEvaluation(training);
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const UniText('عرض التقييم'),
                ),
            ],
          ),
          const SizedBox(height: 6),
          UniText(
            'التقييم سري وغير متاح للطالب',
            style: TextStyle(fontSize: 12, color: UniColors.textSecondary),
          ),
          const SizedBox(height: 14),
          if (!received)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: UniColors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: UniText(
                'لم يتم استلام التقييم السري من جهة التدريب حتى الآن.',
                style: TextStyle(fontSize: 13, color: UniColors.textSecondary),
              ),
            )
          else
            UniText(
              'تم استلام التقييم السري. اضغط على "عرض التقييم" لعرض التفاصيل.',
              style: TextStyle(fontSize: 13, color: UniColors.textPrimary),
            ),
        ],
      ),
    );
  }

  void _showSecretEvaluation(Map<String, dynamic> training) {
    final evaluation = training['evaluation'] as Map<String, dynamic>;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: UniColors.white,
            titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            title: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: UniColors.primaryGreen.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: UniColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UniText(
                        'التقييم السري',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: UniColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      UniText(
                        'تقييم جهة التدريب - سري عن الطالب',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: UniColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
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
                        color: UniColors.lightGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business_rounded,
                            color: UniColors.darkGreen,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UniText(
                                  training['company'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: UniColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                UniText(
                                  '${training['studentName']} • ${training['studentId']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: UniColors.textSecondary,
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
                      rating: evaluation['overallRating'] as int,
                    ),
                    const SizedBox(height: 12),
                    _buildEvaluationRatingCard(
                      title: 'الالتزام والانضباط',
                      rating: evaluation['commitmentRating'] as int,
                    ),
                    if (evaluation['notes'].toString().trim().isNotEmpty) ...[
                      const SizedBox(height: 18),
                      UniText(
                        'ملاحظات جهة التدريب',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: UniColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: UniColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: UniColors.border),
                        ),
                        child: UniText(
                          evaluation['notes'].toString(),
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: UniColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                    if (evaluation['date'].toString().trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'تاريخ إرسال التقييم',
                        evaluation['date'].toString(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: UniColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UniColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: UniText(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: UniColors.textPrimary,
              ),
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                size: 21,
                color: index < rating ? UniColors.warning : UniColors.border,
              );
            }),
          ),
          const SizedBox(width: 8),
          UniText(
            '$rating / 5',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: UniColors.textSecondary,
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
        color: UniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UniColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: UniColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              UniText(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: UniColors.textPrimary,
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
            child: UniText(
              label,
              style: TextStyle(fontSize: 13, color: UniColors.textSecondary),
            ),
          ),
          Expanded(
            child: UniText(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: UniColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
