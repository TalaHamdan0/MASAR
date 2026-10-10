
import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedStatus = 'الكل';

  final List<Map<String, dynamic>> applications = [
    {
      'name': 'تالا حمدان',
      'id': '20231001',
      'major': 'هندسة البرمجيات',
      'company': 'Data Solutions',
      'training': 'تحليل البيانات',
      'date': '24/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية + كشف العلامات',
      'gpa': '3.65',
    },
    {
      'name': 'ليان أحمد',
      'id': '20231002',
      'major': 'علم الحاسوب',
      'company': 'Creative Hub',
      'training': 'تصميم UI/UX',
      'date': '23/09/2026',
      'status': 'مقبول',
      'documents': 'السيرة الذاتية + ملف الأعمال',
      'gpa': '3.82',
    },
    {
      'name': 'رنا سمير',
      'id': '20231003',
      'major': 'هندسة البرمجيات',
      'company': 'Advanced Tech',
      'training': 'تطوير Flutter',
      'date': '22/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية + ملف الأعمال',
      'gpa': '3.54',
    },
    {
      'name': 'محمد يوسف',
      'id': '20231004',
      'major': 'الأمن السيبراني',
      'company': 'SecureNet',
      'training': 'الأمن السيبراني',
      'date': '21/09/2026',
      'status': 'مقبول',
      'documents': 'السيرة الذاتية + الشهادات',
      'gpa': '3.71',
    },
    {
      'name': 'نور علي',
      'id': '20231005',
      'major': 'هندسة البرمجيات',
      'company': 'Quality First',
      'training': 'ضمان الجودة والاختبار',
      'date': '20/09/2026',
      'status': 'مرفوض',
      'documents': 'السيرة الذاتية فقط',
      'gpa': '2.95',
    },
    {
      'name': 'سارة خالد',
      'id': '20231007',
      'major': 'هندسة البرمجيات',
      'company': 'Jordan Tech',
      'training': 'تطوير الواجهات الأمامية',
      'date': '19/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية + ملف الأعمال',
      'gpa': '3.48',
    },
    {
      'name': 'أحمد محمد',
      'id': '20231006',
      'major': 'علم الحاسوب',
      'company': 'Data Solutions',
      'training': 'تحليل البيانات',
      'date': '18/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية فقط',
      'gpa': '3.32',
    },
  ];

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

      final matchesStatus = selectedStatus == 'الكل' ||
          application['status'] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
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
        Text(
          'طلبات التدريب',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'متابعة طلبات الطلاب والاطلاع على تفاصيل كل طلب وحالته.',
          style: TextStyle(
            fontSize: 14,
            color: MasarColors.textSecondary,
          ),
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

        final cardWidth =
            (constraints.maxWidth - (columns - 1) * 12) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'إجمالي الطلبات',
                value: '127',
                icon: Icons.assignment_outlined,
                color: MasarColors.primaryBlue,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'قيد المراجعة',
                value: '18',
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الطلبات المقبولة',
                value: '84',
                icon: Icons.check_circle_outline,
                color: MasarColors.primaryGreen,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(
                title: 'الطلبات المرفوضة',
                value: '25',
                icon: Icons.cancel_outlined,
                color: MasarColors.error,
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
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MasarColors.border),
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
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
            hintText: 'ابحث باسم الطالب أو رقمه أو الشركة أو التدريب',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: MasarColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MasarColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MasarColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MasarColors.primaryBlue),
            ),
          ),
        );

        final filter = DropdownButtonFormField<String>(
          value: selectedStatus,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'حالة الطلب',
            filled: true,
            fillColor: MasarColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MasarColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MasarColors.border),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'الكل', child: Text('كل الحالات')),
            DropdownMenuItem(
              value: 'قيد المراجعة',
              child: Text('قيد المراجعة'),
            ),
            DropdownMenuItem(value: 'مقبول', child: Text('مقبول')),
            DropdownMenuItem(value: 'مرفوض', child: Text('مرفوض')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedStatus = value);
            }
          },
        );

        if (isNarrow) {
          return Column(
            children: [
              searchField,
              const SizedBox(height: 12),
              filter,
            ],
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
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'قائمة طلبات التدريب',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${items.length} طلب',
                  style: TextStyle(
                    fontSize: 13,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: MasarColors.border),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(35),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 42,
                      color: MasarColors.textSecondary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'لا توجد طلبات مطابقة للبحث',
                      style: TextStyle(
                        color: MasarColors.textSecondary,
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
                headingRowColor: WidgetStateProperty.all(
                  MasarColors.lightBlue,
                ),
                headingTextStyle: TextStyle(
                  color: MasarColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                dataTextStyle: TextStyle(
                  color: MasarColors.textPrimary,
                  fontSize: 13,
                ),
                columnSpacing: 28,
                horizontalMargin: 20,
                columns: const [
                  DataColumn(label: Text('الطالب')),
                  DataColumn(label: Text('الرقم الجامعي')),
                  DataColumn(label: Text('الشركة')),
                  DataColumn(label: Text('التدريب')),
                  DataColumn(label: Text('تاريخ الطلب')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('التفاصيل')),
                ],
                rows: items.map((application) {
                  return DataRow(
                    cells: [
                      DataCell(Text(application['name'])),
                      DataCell(Text(application['id'])),
                      DataCell(Text(application['company'])),
                      DataCell(Text(application['training'])),
                      DataCell(Text(application['date'])),
                      DataCell(_statusBadge(application['status'])),
                      DataCell(
                        TextButton.icon(
                          onPressed: () =>
                              _showApplicationDetails(application),
                          icon: const Icon(
                            Icons.visibility_outlined,
                            size: 18,
                          ),
                          label: const Text('عرض'),
                          style: TextButton.styleFrom(
                            foregroundColor: MasarColors.primaryBlue,
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
        color = MasarColors.primaryGreen;
        background = MasarColors.lightGreen;
        break;
      case 'مرفوض':
        color = MasarColors.error;
        background = MasarColors.error.withValues(alpha: 0.10);
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
      child: Text(
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
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: MasarColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.assignment_ind_outlined,
                  color: MasarColors.primaryBlue,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
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
                    _detailSection(
                      'معلومات الطالب',
                      Icons.person_outline,
                      [
                        _detailItem('اسم الطالب', application['name']),
                        _detailItem('الرقم الجامعي', application['id']),
                        _detailItem('التخصص', application['major']),
                        _detailItem('المعدل التراكمي', application['gpa']),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _detailSection(
                      'معلومات الطلب',
                      Icons.business_outlined,
                      [
                        _detailItem('الشركة', application['company']),
                        _detailItem('التدريب المطلوب', application['training']),
                        _detailItem('تاريخ التقديم', application['date']),
                        _detailItem('حالة الطلب', application['status']),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _detailSection(
                      'الوثائق المرفقة',
                      Icons.attach_file,
                      [
                        _detailItem(
                          'الوثائق',
                          application['documents'],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: MasarColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'تعرض هذه الصفحة تفاصيل الطلب وحالته الحالية.',
                              style: TextStyle(
                                color: MasarColors.textPrimary,
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
                child: Text(
                  'إغلاق',
                  style: TextStyle(color: MasarColors.primaryBlue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: MasarColors.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: MasarColors.textPrimary,
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
            color: MasarColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: children,
          ),
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
            child: Text(
              label,
              style: TextStyle(
                color: MasarColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MasarColors.textPrimary,
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
