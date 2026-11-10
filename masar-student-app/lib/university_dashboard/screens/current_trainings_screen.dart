<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
=======
import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_current_trainings_service.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class CurrentTrainingsScreen extends StatefulWidget {
  const CurrentTrainingsScreen({super.key});

  @override
<<<<<<< HEAD
  State<CurrentTrainingsScreen> createState() =>
      _CurrentTrainingsScreenState();
=======
  State<CurrentTrainingsScreen> createState() => _CurrentTrainingsScreenState();
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
}

class _CurrentTrainingsScreenState extends State<CurrentTrainingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'الكل';

<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTrainings {
    final query = _searchController.text.trim().toLowerCase();

    return _trainings.where((training) {
<<<<<<< HEAD
      final matchesSearch = query.isEmpty ||
=======
      final matchesSearch =
          query.isEmpty ||
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          training['studentName'].toString().toLowerCase().contains(query) ||
          training['studentId'].toString().toLowerCase().contains(query) ||
          training['company'].toString().toLowerCase().contains(query) ||
          training['careerPath'].toString().toLowerCase().contains(query);

<<<<<<< HEAD
      final matchesStatus = _selectedStatus == 'الكل' ||
=======
      final matchesStatus =
          _selectedStatus == 'الكل' ||
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          training['status'].toString() == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

<<<<<<< HEAD
  int get _totalTrainings => _trainings.length;

  int get _ongoingTrainings =>
      _trainings.where((e) => e['status'] == 'مستمر').length;

  int get _nearCompletionTrainings =>
      _trainings.where((e) => e['status'] == 'قريب من الإنجاز').length;

  int get _completedTrainings =>
      _trainings.where((e) => e['status'] == 'مكتمل').length;
=======
  int _getStat(String key) {
    return int.tryParse(_statistics[key]?.toString() ?? '0') ?? 0;
  }

  int get _totalTrainings => _getStat('totalTrainings');

  int get _ongoingTrainings => _getStat('ongoingTrainings');

  int get _nearCompletionTrainings => _getStat('nearCompletionTrainings');

  int get _completedTrainings => _getStat('completedTrainings');
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  @override
  Widget build(BuildContext context) {
    return Directionality(
<<<<<<< HEAD
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
=======
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        Text(
=======
        UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          'التدريبات الحالية',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
<<<<<<< HEAD
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
=======
            color: UniColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        UniText(
          'متابعة الطلاب المسجلين حاليًا في برامج التدريب الميداني',
          style: TextStyle(fontSize: 14, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
            color: MasarColors.primaryBlue,
=======
            color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'تدريبات مستمرة',
            value: '$_ongoingTrainings',
            icon: Icons.play_circle_outline_rounded,
<<<<<<< HEAD
            color: MasarColors.primaryGreen,
=======
            color: UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'قريبة من الإنجاز',
            value: '$_nearCompletionTrainings',
            icon: Icons.timelapse_rounded,
<<<<<<< HEAD
            color: MasarColors.warning,
=======
            color: UniColors.warning,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'مكتملة',
            value: '$_completedTrainings',
            icon: Icons.check_circle_outline_rounded,
<<<<<<< HEAD
            color: MasarColors.success,
=======
            color: UniColors.success,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
=======
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  value,
                  style: TextStyle(
                    fontSize: 24,
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(18),
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
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
<<<<<<< HEAD
                hintText: 'ابحث باسم الطالب أو الرقم الجامعي أو الشركة...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: MasarColors.background,
=======
                hintText: UniLocalizations.translate(
                  'ابحث باسم الطالب أو الرقم الجامعي أو الشركة...',
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                labelText: 'حالة التدريب',
                filled: true,
                fillColor: MasarColors.background,
=======
                labelText: UniLocalizations.translate('حالة التدريب'),
                filled: true,
                fillColor: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
<<<<<<< HEAD
                DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                DropdownMenuItem(value: 'مستمر', child: Text('مستمر')),
                DropdownMenuItem(
                  value: 'قريب من الإنجاز',
                  child: Text('قريب من الإنجاز'),
                ),
                DropdownMenuItem(value: 'مكتمل', child: Text('مكتمل')),
                DropdownMenuItem(value: 'متأخر', child: Text('متأخر')),
=======
                DropdownMenuItem(value: 'الكل', child: UniText('الكل')),
                DropdownMenuItem(value: 'مستمر', child: UniText('مستمر')),
                DropdownMenuItem(
                  value: 'قريب من الإنجاز',
                  child: UniText('قريب من الإنجاز'),
                ),
                DropdownMenuItem(value: 'مكتمل', child: UniText('مكتمل')),
                DropdownMenuItem(value: 'متأخر', child: UniText('متأخر')),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
          Text(
=======
          UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            'قائمة التدريبات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
<<<<<<< HEAD
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
                                  training['studentName'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: MasarColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  training['studentId'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MasarColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(training['company'].toString())),
                          DataCell(Text(training['careerPath'].toString())),
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
                                    onPressed: () =>
                                        _showSecretEvaluation(training),
                                    icon: const Icon(
                                      Icons.lock_outline_rounded,
                                      size: 16,
                                    ),
                                    label: const Text('عرض التقييم'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          MasarColors.primaryGreen,
                                      side: BorderSide(
                                        color: MasarColors.primaryGreen
                                            .withOpacity(0.45),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 9,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                              tooltip: 'عرض التفاصيل',
                              icon: Icon(
                                Icons.visibility_outlined,
                                color: MasarColors.primaryBlue,
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
          if (trainings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Text(
                  'لا توجد تدريبات مطابقة للبحث أو الفلتر',
                  style: TextStyle(
                    color: MasarColors.textSecondary,
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    fontSize: 14,
                  ),
                ),
              ),
<<<<<<< HEAD
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ),
        ],
      ),
    );
  }

  Widget _buildEvaluationNotReceived() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: MasarColors.background,
=======
        color: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 15,
<<<<<<< HEAD
            color: MasarColors.textSecondary,
          ),
          const SizedBox(width: 5),
          Text(
=======
            color: UniColors.textSecondary,
          ),
          const SizedBox(width: 5),
          UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            'لم يصل',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
<<<<<<< HEAD
              color: MasarColors.textSecondary,
=======
              color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
<<<<<<< HEAD
      child: Text(
=======
      child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: MasarColors.white,
=======
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: UniColors.white,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            title: Row(
              children: [
                Expanded(
<<<<<<< HEAD
                  child: Text(
=======
                  child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    'تفاصيل التدريب',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
<<<<<<< HEAD
                      color: MasarColors.textPrimary,
=======
                      color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                        _buildDetailRow('اسم الطالب', training['studentName'].toString()),
                        _buildDetailRow('الرقم الجامعي', training['studentId'].toString()),
=======
                        _buildDetailRow(
                          'اسم الطالب',
                          training['studentName'].toString(),
                        ),
                        _buildDetailRow(
                          'الرقم الجامعي',
                          training['studentId'].toString(),
                        ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        _buildDetailRow('التخصص', training['major'].toString()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDetailSection(
                      title: 'بيانات التدريب',
                      icon: Icons.business_center_outlined,
                      children: [
<<<<<<< HEAD
                        _buildDetailRow('جهة التدريب', training['company'].toString()),
                        _buildDetailRow('المسار المهني', training['careerPath'].toString()),
                        _buildDetailRow('تاريخ البداية', training['startDate'].toString()),
                        _buildDetailRow('تاريخ النهاية', training['endDate'].toString()),
                        _buildDetailRow('حالة التدريب', training['status'].toString()),
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDetailSection(
                      title: 'ساعات التدريب',
                      icon: Icons.access_time_rounded,
                      children: [
                        Row(
                          children: [
<<<<<<< HEAD
                            Text(
=======
                            UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                              '$hours / $totalHours ساعة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
<<<<<<< HEAD
                                color: MasarColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${((hours / totalHours) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: MasarColors.textSecondary,
=======
                                color: UniColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            UniText(
                              '${((hours / totalHours) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                          backgroundColor: MasarColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            MasarColors.primaryBlue,
=======
                          backgroundColor: UniColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
    final evaluation =
        training['evaluation'] as Map<String, dynamic>;
=======
    final evaluation = training['evaluation'] as Map<String, dynamic>;
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    final received = evaluation['status'] == 'وصل';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: received
              ? MasarColors.primaryGreen.withOpacity(0.35)
              : MasarColors.border,
=======
        color: UniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: received
              ? UniColors.primaryGreen.withOpacity(0.35)
              : UniColors.border,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
<<<<<<< HEAD
              Icon(
                Icons.lock_rounded,
                color: MasarColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
=======
              Icon(Icons.lock_rounded, color: UniColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  'تقييم جهة التدريب السري',
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
              if (received)
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSecretEvaluation(training);
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 17),
<<<<<<< HEAD
                  label: const Text('عرض التقييم'),
=======
                  label: const UniText('عرض التقييم'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
            ],
          ),
          const SizedBox(height: 6),
<<<<<<< HEAD
          Text(
            'التقييم سري وغير متاح للطالب',
            style: TextStyle(
              fontSize: 12,
              color: MasarColors.textSecondary,
            ),
=======
          UniText(
            'التقييم سري وغير متاح للطالب',
            style: TextStyle(fontSize: 12, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          const SizedBox(height: 14),
          if (!received)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
<<<<<<< HEAD
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ),
        ],
      ),
    );
  }

  void _showSecretEvaluation(Map<String, dynamic> training) {
<<<<<<< HEAD
    final evaluation =
        training['evaluation'] as Map<String, dynamic>;
=======
    final evaluation = training['evaluation'] as Map<String, dynamic>;
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
<<<<<<< HEAD
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: MasarColors.white,
=======
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: UniColors.white,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            title: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
<<<<<<< HEAD
                    color: MasarColors.primaryGreen.withOpacity(0.10),
=======
                    color: UniColors.primaryGreen.withOpacity(0.10),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
<<<<<<< HEAD
                    color: MasarColors.primaryGreen,
=======
                    color: UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
<<<<<<< HEAD
                      Text(
=======
                      UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        'التقييم السري',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
<<<<<<< HEAD
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
=======
                          color: UniColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        'تقييم جهة التدريب - سري عن الطالب',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
<<<<<<< HEAD
                          color: MasarColors.textSecondary,
=======
                          color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                        color: MasarColors.lightGreen,
=======
                        color: UniColors.lightGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business_rounded,
<<<<<<< HEAD
                            color: MasarColors.darkGreen,
=======
                            color: UniColors.darkGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
<<<<<<< HEAD
                                Text(
=======
                                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                  training['company'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
<<<<<<< HEAD
                                    color: MasarColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${training['studentName']} • ${training['studentId']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MasarColors.textSecondary,
=======
                                    color: UniColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                UniText(
                                  '${training['studentName']} • ${training['studentId']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                      Text(
=======
                      UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        'ملاحظات جهة التدريب',
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
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
<<<<<<< HEAD
                          color: MasarColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MasarColors.border),
                        ),
                        child: Text(
=======
                          color: UniColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: UniColors.border),
                        ),
                        child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          evaluation['notes'].toString(),
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
<<<<<<< HEAD
                            color: MasarColors.textPrimary,
=======
                            color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Row(
        children: [
          Expanded(
<<<<<<< HEAD
            child: Text(
=======
            child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
<<<<<<< HEAD
                color: MasarColors.textPrimary,
=======
                color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
<<<<<<< HEAD
                index < rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 21,
                color: index < rating
                    ? MasarColors.warning
                    : MasarColors.border,
=======
                index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                size: 21,
                color: index < rating ? UniColors.warning : UniColors.border,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              );
            }),
          ),
          const SizedBox(width: 8),
<<<<<<< HEAD
          Text(
=======
          UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            '$rating / 5',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
<<<<<<< HEAD
              color: MasarColors.textSecondary,
=======
              color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
<<<<<<< HEAD
              Icon(icon, color: MasarColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
=======
              Icon(icon, color: UniColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                title,
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
<<<<<<< HEAD
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
=======
            child: UniText(
              label,
              style: TextStyle(fontSize: 13, color: UniColors.textSecondary),
            ),
          ),
          Expanded(
            child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              value,
              style: TextStyle(
                fontSize: 13,
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
  }
}
