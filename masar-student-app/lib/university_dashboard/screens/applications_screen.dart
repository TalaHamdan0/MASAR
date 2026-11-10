import 'package:flutter/material.dart';
import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_applications_service.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedStatus = 'الكل';

  List<Map<String, dynamic>> applications = [];

  Map<String, dynamic> statistics = {};

  bool isLoading = true;

  String? errorMessage;

  final Set<String> _processingApplicationIds = <String>{};

  @override
  void initState() {
    super.initState();

    _loadApplications();
  }

  Future<void> _loadApplications({bool showLoading = true}) async {
    setState(() {
      if (showLoading) {
        isLoading = true;
      }
      errorMessage = null;
    });

    try {
      final result = await UniversityApplicationsService.fetchApplications();
      final applicationsData = result['applications'] as List? ?? [];
      final statisticsData = result['statistics'];

      if (!mounted) return;

      setState(() {
        applications = applicationsData
            .map((application) => Map<String, dynamic>.from(application as Map))
            .toList();

        statistics = statisticsData is Map
            ? Map<String, dynamic>.from(statisticsData)
            : {};

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _confirmApplicationDecision(
    Map<String, dynamic> application,
    String decision,
  ) async {
    final applicationId = application['applicationId']?.toString() ?? '';
    if (applicationId.isEmpty || application['canReview'] != true) {
      return;
    }

    final accepted = decision == 'ACCEPT';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: UniColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: UniText(
              accepted ? 'تأكيد قبول الطلب' : 'تأكيد رفض الطلب',
              style: TextStyle(
                color: UniColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: UniText(
              accepted
                  ? 'هل أنت متأكدة من قبول طلب التدريب لهذا الطالب؟'
                  : 'هل أنت متأكدة من رفض طلب التدريب لهذا الطالب؟',
              style: TextStyle(color: UniColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const UniText('إلغاء'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accepted
                      ? UniColors.primaryGreen
                      : UniColors.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: UniText(accepted ? 'تأكيد القبول' : 'تأكيد الرفض'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _processingApplicationIds.add(applicationId));

    try {
      await UniversityApplicationsService.updateApplicationDecision(
        applicationId: applicationId,
        decision: decision,
      );

      // Refresh both the row statuses and the four statistic cards from Oracle.
      await _loadApplications(showLoading: false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: UniText(
            accepted ? 'تم قبول طلب التدريب بنجاح' : 'تم رفض طلب التدريب بنجاح',
          ),
          backgroundColor: accepted
              ? UniColors.primaryGreen
              : UniColors.textPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: UniText('تعذر تحديث حالة الطلب: ${e.toString()}'),
          backgroundColor: UniColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _processingApplicationIds.remove(applicationId));
      }
    }
  }

  Widget _buildDecisionActions(Map<String, dynamic> application) {
    final applicationId = application['applicationId']?.toString() ?? '';
    final canReview =
        application['canReview'] == true && applicationId.isNotEmpty;

    if (!canReview) {
      final note = application['reviewNote']?.toString() ?? '';
      return UniText(
        note.isEmpty ? '—' : note,
        style: TextStyle(color: UniColors.textSecondary, fontSize: 11),
      );
    }

    final isProcessing = _processingApplicationIds.contains(applicationId);
    if (isProcessing) {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: () => _confirmApplicationDecision(application, 'ACCEPT'),
          icon: const Icon(Icons.check_rounded, size: 16),
          label: const UniText('قبول'),
          style: FilledButton.styleFrom(
            backgroundColor: UniColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _confirmApplicationDecision(application, 'REJECT'),
          icon: const Icon(Icons.close_rounded, size: 16),
          label: const UniText('رفض'),
          style: OutlinedButton.styleFrom(
            foregroundColor: UniColors.error,
            side: BorderSide(color: UniColors.error.withValues(alpha: 0.65)),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  int _getNumber(String key) {
    final value = statistics[key];

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  List<Map<String, dynamic>> get filteredApplications {
    final query = searchController.text.trim().toLowerCase();

    return applications.where((application) {
      final matchesSearch =
          application['name'].toString().toLowerCase().contains(query) ||
          application['id'].toString().toLowerCase().contains(query) ||
          application['training'].toString().toLowerCase().contains(query) ||
          application['company'].toString().toLowerCase().contains(query);

      final matchesStatus =
          selectedStatus == 'الكل' || application['status'] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),

      child: Container(
        color: UniColors.background,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildPageTitle(),

              const SizedBox(height: 24),

              _buildStatistics(),

              const SizedBox(height: 28),

              _buildSearchAndFilter(),

              const SizedBox(height: 20),

              _buildApplicationsTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        UniText(
          'طلبات التدريب',

          style: TextStyle(
            fontSize: 25,

            fontWeight: FontWeight.bold,

            color: UniColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        UniText(
          'متابعة طلبات الطلاب والاطلاع على تفاصيل كل طلب وحالته.',

          style: TextStyle(fontSize: 14, color: UniColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 600
            ? 2
            : 1;

        final cardWidth = (constraints.maxWidth - (columns - 1) * 12) / columns;

        return Wrap(
          spacing: 12,

          runSpacing: 12,

          children: [
            SizedBox(
              width: cardWidth,

              child: _statCard(
                title: 'إجمالي الطلبات',

                value: _getNumber('totalApplications').toString(),

                icon: Icons.assignment_outlined,

                color: UniColors.primaryBlue,
              ),
            ),

            SizedBox(
              width: cardWidth,

              child: _statCard(
                title: 'قيد المراجعة',

                value: _getNumber('pendingApplications').toString(),

                icon: Icons.pending_actions,

                color: Colors.orange,
              ),
            ),

            SizedBox(
              width: cardWidth,

              child: _statCard(
                title: 'الطلبات المقبولة',

                value: _getNumber('acceptedApplications').toString(),

                icon: Icons.check_circle_outline,

                color: UniColors.primaryGreen,
              ),
            ),

            SizedBox(
              width: cardWidth,

              child: _statCard(
                title: 'الطلبات المرفوضة',

                value: _getNumber('rejectedApplications').toString(),

                icon: Icons.cancel_outlined,

                color: UniColors.error,
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

    required IconData icon,

    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: UniColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: UniColors.border),
      ),

      child: Row(
        children: [
          Container(
            width: 48,

            height: 48,

            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: color, size: 25),
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

                const SizedBox(height: 7),

                UniText(
                  value,

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,

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

  Widget _buildSearchAndFilter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 550;

        final searchField = TextField(
          controller: searchController,

          onChanged: (_) => setState(() {}),

          decoration: InputDecoration(
            hintText: UniLocalizations.translate(
              'ابحث باسم الطالب أو رقمه أو الشركة أو التدريب',
            ),

            prefixIcon: const Icon(Icons.search),

            filled: true,

            fillColor: UniColors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,

              vertical: 14,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: UniColors.border),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: UniColors.border),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: UniColors.primaryBlue),
            ),
          ),
        );

        final filter = DropdownButtonFormField<String>(
          value: selectedStatus,

          isExpanded: true,

          decoration: InputDecoration(
            labelText: UniLocalizations.translate('حالة الطلب'),

            filled: true,

            fillColor: UniColors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,

              vertical: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: UniColors.border),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: UniColors.border),
            ),
          ),

          items: const [
            DropdownMenuItem(value: 'الكل', child: UniText('كل الحالات')),

            DropdownMenuItem(
              value: 'قيد المراجعة',

              child: UniText('قيد المراجعة'),
            ),

            DropdownMenuItem(value: 'مقبول', child: UniText('مقبول')),

            DropdownMenuItem(value: 'مرفوض', child: UniText('مرفوض')),
          ],

          onChanged: (value) {
            if (value != null) {
              setState(() => selectedStatus = value);
            }
          },
        );

        if (isNarrow) {
          return Column(
            children: [searchField, const SizedBox(height: 12), filter],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: searchField),

            const SizedBox(width: 14),

            Expanded(flex: 1, child: filter),
          ],
        );
      },
    );
  }

  Widget _buildApplicationsTable() {
    final items = filteredApplications;

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: UniColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: UniColors.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.all(20),

            child: Row(
              children: [
                Expanded(
                  child: UniText(
                    'قائمة طلبات التدريب',

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.bold,

                      color: UniColors.textPrimary,
                    ),
                  ),
                ),

                UniText(
                  '${items.length} طلب',

                  style: TextStyle(
                    fontSize: 13,

                    color: UniColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: UniColors.border),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(35),

              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(28),

              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,

                      size: 42,

                      color: UniColors.error,
                    ),

                    const SizedBox(height: 10),

                    UniText(
                      errorMessage!,

                      textAlign: TextAlign.center,

                      style: TextStyle(color: UniColors.textSecondary),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: _loadApplications,

                      child: const UniText('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            )
          else if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(35),

              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,

                      size: 42,

                      color: UniColors.textSecondary,
                    ),

                    const SizedBox(height: 10),

                    UniText(
                      'لا توجد طلبات مطابقة للبحث',

                      style: TextStyle(
                        color: UniColors.textSecondary,

                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: DataTable(
                headingRowColor: WidgetStateProperty.all(UniColors.lightBlue),

                headingTextStyle: TextStyle(
                  color: UniColors.textPrimary,

                  fontWeight: FontWeight.bold,

                  fontSize: 13,
                ),

                dataTextStyle: TextStyle(
                  color: UniColors.textPrimary,

                  fontSize: 13,
                ),

                columnSpacing: 28,

                horizontalMargin: 20,

                columns: const [
                  DataColumn(label: UniText('الطالب')),

                  DataColumn(label: UniText('الرقم الجامعي')),

                  DataColumn(label: UniText('الشركة')),

                  DataColumn(label: UniText('التدريب')),

                  DataColumn(label: UniText('تاريخ الطلب')),

                  DataColumn(label: UniText('الحالة')),

                  DataColumn(label: UniText('الإجراء')),

                  DataColumn(label: UniText('التفاصيل')),
                ],

                rows: items.map((application) {
                  return DataRow(
                    cells: [
                      DataCell(UniText(application['name'].toString())),

                      DataCell(UniText(application['id'].toString())),

                      DataCell(UniText(application['company'].toString())),

                      DataCell(UniText(application['training'].toString())),

                      DataCell(UniText(application['date'].toString())),

                      DataCell(_statusBadge(application['status'].toString())),

                      DataCell(_buildDecisionActions(application)),

                      DataCell(
                        TextButton.icon(
                          onPressed: () => _showApplicationDetails(application),

                          icon: const Icon(Icons.visibility_outlined, size: 18),

                          label: const UniText('عرض'),

                          style: TextButton.styleFrom(
                            foregroundColor: UniColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    Color background;

    switch (status) {
      case 'مقبول':
        color = UniColors.primaryGreen;

        background = UniColors.lightGreen;

        break;

      case 'مرفوض':
        color = UniColors.error;

        background = UniColors.error.withValues(alpha: 0.10);

        break;

      default:
        color = Colors.orange.shade800;

        background = Colors.orange.withValues(alpha: 0.12);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(20),
      ),

      child: UniText(
        status,

        style: TextStyle(
          color: color,

          fontWeight: FontWeight.w600,

          fontSize: 12,
        ),
      ),
    );
  }

  void _showApplicationDetails(Map<String, dynamic> application) {
    showDialog<void>(
      context: context,

      builder: (dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),

          child: AlertDialog(
            backgroundColor: UniColors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            title: Row(
              children: [
                Icon(
                  Icons.assignment_ind_outlined,

                  color: UniColors.primaryBlue,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: UniText(
                    'تفاصيل طلب التدريب',

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            content: SizedBox(
              width: 480,

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _detailSection('معلومات الطالب', Icons.person_outline, [
                      _detailItem('اسم الطالب', application['name']),

                      _detailItem('الرقم الجامعي', application['id']),

                      _detailItem('التخصص', application['major']),

                      _detailItem('المعدل التراكمي', application['gpa']),
                    ]),

                    const SizedBox(height: 20),

                    _detailSection('معلومات الطلب', Icons.business_outlined, [
                      _detailItem('الشركة', application['company']),

                      _detailItem('التدريب المطلوب', application['training']),

                      _detailItem('تاريخ التقديم', application['date']),

                      _detailItem('حالة الطلب', application['status']),
                    ]),

                    const SizedBox(height: 20),

                    _detailSection('الوثائق المرفقة', Icons.attach_file, [
                      _detailItem('الوثائق', application['documents']),
                    ]),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: UniColors.lightBlue,

                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Icon(
                            Icons.info_outline,

                            color: UniColors.primaryBlue,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: UniText(
                              'تعرض هذه الصفحة تفاصيل الطلب وحالته الحالية.',

                              style: TextStyle(
                                color: UniColors.textPrimary,

                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),

                child: UniText(
                  'إغلاق',

                  style: TextStyle(color: UniColors.primaryBlue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Icon(icon, color: UniColors.primaryBlue, size: 20),

            const SizedBox(width: 8),

            UniText(
              title,

              style: TextStyle(
                color: UniColors.textPrimary,

                fontSize: 15,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: UniColors.background,

            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            flex: 2,

            child: UniText(
              label,

              style: TextStyle(color: UniColors.textSecondary, fontSize: 13),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 3,

            child: UniText(
              value,

              textAlign: TextAlign.start,

              style: TextStyle(
                color: UniColors.textPrimary,

                fontSize: 13,

                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
