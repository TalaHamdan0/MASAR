import 'package:flutter/material.dart';

class PendingApplicationsScreen extends StatefulWidget {
  const PendingApplicationsScreen({super.key});

  @override
  State<PendingApplicationsScreen> createState() =>
      _PendingApplicationsScreenState();
}

class _PendingApplicationsScreenState extends State<PendingApplicationsScreen> {
  String search = '';

  final List<Map<String, String>> allApplicants = [
    {
      'name': 'أحمد محمد',
      'email': 'ahmed@example.com',
      'phone': '0790000001',
      'specialty': 'علوم الحاسوب',
      'opportunity': 'تطوير البرمجيات',
      'date': '2026/05/10',
      'status': 'قيد المراجعة',
      'university': 'الجامعة الأردنية',
      'gpa': '3.5',
      'skills': 'Flutter، Dart، قواعد البيانات',
      'experience': 'مشروع تخرج لتطوير تطبيق لإدارة المهام',
      'notes': 'مهتم بتطوير تطبيقات الهواتف والأنظمة الذكية.',
    },
    {
      'name': 'عمر التميمي',
      'email': 'omar@example.com',
      'phone': '0790000004',
      'specialty': 'هندسة الشبكات',
      'opportunity': 'شبكات',
      'date': '2026/05/07',
      'status': 'قيد المراجعة',
      'university': 'جامعة البلقاء التطبيقية',
      'gpa': '3.4',
      'skills': 'الشبكات، TCP/IP، Linux',
      'experience': 'تطبيقات ومختبرات عملية في الشبكات',
      'notes': 'مهتم بإدارة الشبكات وأمن المعلومات.',
    },
    {
      'name': 'ريم عبدالله',
      'email': 'reem@example.com',
      'phone': '0790000005',
      'specialty': 'علوم الحاسوب',
      'opportunity': 'تطوير البرمجيات',
      'date': '2026/05/03',
      'status': 'قيد المراجعة',
      'university': 'الجامعة الأردنية',
      'gpa': '3.7',
      'skills': 'Java، Python، قواعد البيانات',
      'experience': 'مشاريع برمجية جامعية',
      'notes': 'مهتمة بتطوير البرمجيات والتطبيقات الحديثة.',
    },
    {
      'name': 'يوسف أحمد',
      'email': 'yousef@example.com',
      'phone': '0790000006',
      'specialty': 'هندسة شبكات',
      'opportunity': 'شبكات',
      'date': '2026/04/30',
      'status': 'قيد المراجعة',
      'university': 'جامعة العلوم والتكنولوجيا',
      'gpa': '3.3',
      'skills': 'إدارة الشبكات، Linux، TCP/IP',
      'experience': 'تدريبات عملية في مختبرات الشبكات',
      'notes': 'يسعى إلى تطوير خبرته في مجال الشبكات.',
    },
    {
      'name': 'مازن علي',
      'email': 'mazen@example.com',
      'phone': '0790000007',
      'specialty': 'هندسة برمجيات',
      'opportunity': 'تطوير البرمجيات',
      'date': '2026/04/26',
      'status': 'قيد المراجعة',
      'university': 'جامعة اليرموك',
      'gpa': '3.6',
      'skills': 'Flutter، Dart، Git',
      'experience': 'تطوير مشاريع تطبيقات',
      'notes': 'مهتم بتطوير تطبيقات الهواتف.',
    },
    {
      'name': 'إياد خالد',
      'email': 'eyad@example.com',
      'phone': '0790000008',
      'specialty': 'علوم الحاسوب',
      'opportunity': 'تطوير البرمجيات',
      'date': '2026/04/22',
      'status': 'قيد المراجعة',
      'university': 'جامعة البلقاء التطبيقية',
      'gpa': '3.5',
      'skills': 'C++، Java، SQL',
      'experience': 'مشاريع جامعية في البرمجة',
      'notes': 'مهتم بتحليل الأنظمة وتطوير البرمجيات.',
    },
  ];

  static const Color primaryColor = Color(0xFF0D6EFD);
  static const Color backgroundColor = Color(0xFFF5F8FD);
  static const Color borderColor = Color(0xFFDCE7F5);
  static const Color textColor = Color(0xFF17243A);
  static const Color secondaryTextColor = Color(0xFF7C899E);

  List<Map<String, String>> get filteredApplicants {
    return allApplicants.where((item) {
      final isPending = item['status'] == 'قيد المراجعة';
      final query = search.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          item['name']!.toLowerCase().contains(query) ||
          item['email']!.toLowerCase().contains(query) ||
          item['specialty']!.toLowerCase().contains(query) ||
          item['opportunity']!.toLowerCase().contains(query);

      return isPending && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final applicants = filteredApplicants;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatCard(applicants.length),
                const SizedBox(height: 24),
                _buildSearch(),
                const SizedBox(height: 20),
                _buildApplicantsTable(applicants),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // العنوان وزر العودة للصفحة الرئيسية

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 27,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'مراجعة الطلبات الجديدة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'عرض وفحص الطلبات المقدمة حديثاً لاتخاذ الإجراء المناسب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(int count) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7DF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Color(0xFFFFA600),
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Text(
                'إجمالي الطلبات قيد المراجعة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        onChanged: (value) {
          setState(() => search = value);
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن طالب...',
          hintStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: secondaryTextColor,
          ),
          prefixIcon: const Icon(Icons.search, color: primaryColor),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantsTable(List<Map<String, String>> applicants) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1250,
          child: Column(
            children: [
              _buildTableHeader(),
              if (applicants.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(35),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        color: secondaryTextColor,
                        size: 45,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'لا توجد طلبات قيد المراجعة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...applicants.map(_buildApplicantRow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 58,
      color: const Color(0xFFF0F5FB),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _TableHeading('الطالب')),
          Expanded(flex: 2, child: _TableHeading('التخصص')),
          Expanded(flex: 2, child: _TableHeading('الفرصة التدريبية')),
          Expanded(flex: 2, child: _TableHeading('تاريخ التقديم')),
          Expanded(flex: 2, child: _TableHeading('الحالة')),
          Expanded(flex: 2, child: _TableHeading('إجراءات')),
        ],
      ),
    );
  }

  Widget _buildApplicantRow(Map<String, String> item) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE7EDF6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F1FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item['email']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _cellText(item['specialty']!)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.work_outline, size: 17, color: primaryColor),
                const SizedBox(width: 7),
                Expanded(child: _cellText(item['opportunity']!)),
              ],
            ),
          ),
          Expanded(flex: 2, child: _cellText(item['date']!)),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildStatusBadge(item['status']!),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _actionButton(
                  icon: Icons.edit_outlined,
                  color: primaryColor,
                  tooltip: 'تعديل بيانات الطالب',
                  onPressed: () => _showEditDialog(item),
                ),
                const SizedBox(width: 5),
                _actionButton(
                  icon: Icons.visibility_outlined,
                  color: primaryColor,
                  tooltip: 'عرض ملف الطالب',
                  onPressed: () => _showApplicantDetails(item),
                ),
                const SizedBox(width: 5),
                _actionButton(
                  icon: Icons.more_horiz,
                  color: const Color(0xFF63738C),
                  tooltip: 'خيارات الطلب',
                  onPressed: () => _showActionsMenu(item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellText(String value) {
    return Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        color: Color(0xFF536781),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color background;
    IconData icon;

    switch (status) {
      case 'مقبول':
        color = const Color(0xFF0DA66B);
        background = const Color(0xFFE0F7EE);
        icon = Icons.check_circle;
        break;
      case 'مرفوض':
        color = const Color(0xFFEF4444);
        background = const Color(0xFFFFE6E6);
        icon = Icons.cancel;
        break;
      case 'في المقابلة':
        color = primaryColor;
        background = const Color(0xFFE7F0FF);
        icon = Icons.groups;
        break;
      default:
        color = const Color(0xFFFFA000);
        background = const Color(0xFFFFF0D7);
        icon = Icons.access_time_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  // عرض ملف الطالب بدون زر قبول أو رفض
  void _showApplicantDetails(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'ملف الطالب',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F7FF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0EBFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 38,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['email']!,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildStatusBadge(item['status']!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    _dialogSectionTitle('المعلومات الشخصية والأكاديمية'),
                    const SizedBox(height: 10),
                    _detailRow(
                      Icons.phone_outlined,
                      'رقم الهاتف',
                      item['phone']!,
                    ),
                    _detailRow(
                      Icons.school_outlined,
                      'الجامعة',
                      item['university']!,
                    ),
                    _detailRow(
                      Icons.menu_book_outlined,
                      'التخصص',
                      item['specialty']!,
                    ),
                    _detailRow(Icons.grade_outlined, 'المعدل', item['gpa']!),
                    const SizedBox(height: 18),
                    _dialogSectionTitle('تفاصيل طلب التدريب'),
                    const SizedBox(height: 10),
                    _detailRow(
                      Icons.work_outline,
                      'الفرصة التدريبية',
                      item['opportunity']!,
                    ),
                    _detailRow(
                      Icons.calendar_month_outlined,
                      'تاريخ التقديم',
                      item['date']!,
                    ),
                    const SizedBox(height: 18),
                    _dialogSectionTitle('المهارات'),
                    const SizedBox(height: 8),
                    _detailDescription(item['skills']!),
                    const SizedBox(height: 16),
                    _dialogSectionTitle('الخبرات والمشاريع'),
                    const SizedBox(height: 8),
                    _detailDescription(item['experience']!),
                    const SizedBox(height: 16),
                    _dialogSectionTitle('نبذة عن الطالب'),
                    const SizedBox(height: 8),
                    _detailDescription(item['notes']!),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close),
                        label: const Text(
                          'إغلاق',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: primaryColor),
          const SizedBox(width: 10),
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailDescription(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          height: 1.8,
          color: Color(0xFF536781),
        ),
      ),
    );
  }

  // قائمة خيارات الطلب
  void _showActionsMenu(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'قبول ونقل للمقابلة',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmStatusChange(item, 'في المقابلة');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                  title: const Text(
                    'رفض الطلب',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmStatusChange(item, 'مرفوض');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmStatusChange(Map<String, String> item, String newStatus) {
    final isRejection = newStatus == 'مرفوض';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              isRejection ? 'رفض الطلب' : 'قبول الطلب',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              isRejection
                  ? 'هل أنت متأكد من رفض طلب ${item['name']}؟'
                  : 'هل تريد نقل طلب ${item['name']} إلى مرحلة المقابلة؟',
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _changeStatus(item, newStatus);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRejection
                      ? Colors.red
                      : const Color(0xFF0DA66B),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'تأكيد',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeStatus(Map<String, String> item, String newStatus) {
    setState(() {
      item['status'] = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus == 'في المقابلة'
              ? 'تم قبول الطلب ونقله إلى مرحلة المقابلة'
              : 'تم رفض الطلب',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: newStatus == 'مرفوض'
            ? Colors.red
            : const Color(0xFF0DA66B),
      ),
    );
  }

  void _showEditDialog(Map<String, String> item) {
    final nameController = TextEditingController(text: item['name']);
    final emailController = TextEditingController(text: item['email']);
    final specialtyController = TextEditingController(text: item['specialty']);
    final opportunityController = TextEditingController(
      text: item['opportunity'],
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(
              'تعديل بيانات الطلب',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 430,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _editField(nameController, 'اسم الطالب'),
                    const SizedBox(height: 12),
                    _editField(emailController, 'البريد الإلكتروني'),
                    const SizedBox(height: 12),
                    _editField(specialtyController, 'التخصص'),
                    const SizedBox(height: 12),
                    _editField(opportunityController, 'الفرصة التدريبية'),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty) {
                    return;
                  }

                  setState(() {
                    item['name'] = nameController.text.trim();
                    item['email'] = emailController.text.trim();
                    item['specialty'] = specialtyController.text.trim();
                    item['opportunity'] = opportunityController.text.trim();
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم تحديث بيانات الطالب',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'حفظ التعديلات',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _editField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Cairo'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _TableHeading extends StatelessWidget {
  final String title;

  const _TableHeading(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF234675),
        ),
      ),
    );
  }
}
