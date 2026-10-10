import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';

/// شاشة إدارة الفرص التدريبية.
/// شاشة إضافة الفرصة أصبحت صفحة مستقلة بدل نافذة AlertDialog.
class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> {
  final List<Map<String, dynamic>> _internships = [
    {
      'id': '1',
      'title': 'تطوير برمجيات (Developer)',
      'track': 'تطوير التطبيقات',
      'location': 'عمان، الأردن (حضوري)',
      'seats': 5,
      'startDate': '2026-05-01',
      'endDate': '2026-08-01',
      'isOpen': true,
      'description': 'تدريب عملي على تطوير التطبيقات والبرمجيات.',
      'conditions': 'الالتزام بساعات التدريب وإنجاز المهام المطلوبة.',
      'skills': <String>['إدارة الحاسوب', 'التواصل الفعال'],
      'academicRecordRequired': true,
      'cvRequired': true,
      'additionalDocumentRequired': false,
      'applicants': [
        {
          'name': 'أحمد علي',
          'university': 'جامعة العلوم الإسلامية',
          'status': 'قيد المراجعة',
          'date': '2026-04-10',
        },
        {
          'name': 'سارة محمود',
          'university': 'جامعة العلوم الإسلامية',
          'status': 'مقبول',
          'date': '2026-04-08',
        },
      ],
    },
    {
      'id': '2',
      'title': 'مهندس شبكات (Networking)',
      'track': 'شبكات',
      'location': 'عن بُعد',
      'seats': 3,
      'startDate': '2026-06-01',
      'endDate': '2026-09-01',
      'isOpen': true,
      'description': 'تدريب في أساسيات الشبكات وإدارتها.',
      'conditions': 'معرفة أساسية بمفاهيم الشبكات.',
      'skills': <String>['حل المشكلات'],
      'academicRecordRequired': false,
      'cvRequired': true,
      'additionalDocumentRequired': false,
      'applicants': [
        {
          'name': 'فهد محمد',
          'university': 'جامعة العلوم الإسلامية',
          'status': 'مرفوض',
          'date': '2026-04-05',
        },
      ],
    },
    {
      'id': '3',
      'title': 'تحليل بيانات (Data Analyst)',
      'track': 'علم البيانات',
      'location': 'عمان، الأردن (هجين)',
      'seats': 2,
      'startDate': '2026-02-01',
      'endDate': '2026-04-30',
      'isOpen': false,
      'description': 'تدريب على تحليل البيانات واستخلاص النتائج.',
      'conditions': '',
      'skills': <String>['تحليل البيانات'],
      'academicRecordRequired': true,
      'cvRequired': true,
      'additionalDocumentRequired': true,
      'applicants': [],
    },
  ];

  String _searchQuery = '';
  String _selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final filteredList = _internships.where((item) {
      final matchesSearch =
          item['title'].toString().toLowerCase().contains(query) ||
          item['track'].toString().toLowerCase().contains(query);
      if (_selectedFilter == 'مفتوحة') {
        return matchesSearch && item['isOpen'] == true;
      }
      if (_selectedFilter == 'مغلقة') {
        return matchesSearch && item['isOpen'] == false;
      }
      return matchesSearch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'رجوع',
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: MasarColors.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الفرص التدريبية',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF17243A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'إدارة واستعراض جميع الفرص التدريبية المنشورة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: MasarColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _openAddInternshipPage,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text(
                        'إضافة فرصة جديدة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MasarColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MasarColors.border),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final search = TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'البحث عن فرصة تدريبية أو مسار...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: MasarColors.textSecondary,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: MasarColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                      final filters = SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'الكل',
                            label: Text(
                              'الكل',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                          ButtonSegment(
                            value: 'مفتوحة',
                            label: Text(
                              'مفتوحة',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                          ButtonSegment(
                            value: 'مغلقة',
                            label: Text(
                              'مغلقة',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                        ],
                        selected: {_selectedFilter},
                        onSelectionChanged: (selection) =>
                            setState(() => _selectedFilter = selection.first),
                      );
                      if (constraints.maxWidth < 650) {
                        return Column(
                          children: [
                            search,
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: filters,
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: search),
                          const SizedBox(width: 16),
                          filters,
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (filteredList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: MasarColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: MasarColors.textSecondary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'لا توجد فرص تدريبية مطابقة للبحث',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: MasarColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) =>
                        _buildInternshipCard(filteredList[index]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openAddInternshipPage() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const AddInternshipScreen()),
    );
    if (result == null || !mounted) return;
    final isDraft = result['isDraft'] == true;
    setState(() {
      result['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      result['applicants'] = <Map<String, dynamic>>[];
      _internships.insert(0, result);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDraft
              ? 'تم حفظ الفرصة كمسودة بنجاح'
              : 'تم نشر الفرصة التدريبية بنجاح',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildInternshipCard(Map<String, dynamic> item) {
    final isOpen = item['isOpen'] == true;
    final List applicants = item['applicants'] ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: MasarColors.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'المسار: ${item['track'] ?? ''}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(isOpen, isDraft: item['isDraft'] == true),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildDetailInfo(
                Icons.location_on_outlined,
                'الموقع',
                item['location'] ?? '',
              ),
              _buildDetailInfo(
                Icons.event_seat_outlined,
                'عدد المقاعد',
                '${item['seats']} مقاعد',
              ),
              _buildDetailInfo(
                Icons.groups_outlined,
                'عدد المتقدمين',
                '${applicants.length} طالب',
              ),
              _buildDetailInfo(
                Icons.calendar_today_outlined,
                'فترة التدريب',
                '${item['startDate'] ?? 'غير محدد'} إلى ${item['endDate'] ?? 'غير محدد'}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRequirementsSummary(item),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showEditInternshipDialog(item),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text(
                  'تعديل',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: MasarColors.textPrimary,
                  side: const BorderSide(color: MasarColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showApplicantsBottomSheet(item),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text(
                  'عرض المتقدمين',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MasarColors.lightBlue,
                  foregroundColor: MasarColors.primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isOpen, {bool isDraft = false}) {
    final color = isDraft
        ? const Color(0xFFB45309)
        : isOpen
        ? const Color(0xFF15803D)
        : const Color(0xFF475569);
    final background = isDraft
        ? const Color(0xFFFFF7ED)
        : isOpen
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFF1F5F9);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 6),
          Text(
            isDraft ? 'مسودة' : (isOpen ? 'مفتوحة' : 'مغلقة'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsSummary(Map<String, dynamic> item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MasarColors.border),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 17,
                color: MasarColors.textSecondary,
              ),
              SizedBox(width: 7),
              Text(
                'متطلبات التقديم:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: MasarColors.textPrimary,
                ),
              ),
            ],
          ),
          _buildRequirementChip(
            'السجل الأكاديمي',
            item['academicRecordRequired'] == true,
          ),
          _buildRequirementChip('السيرة الذاتية', item['cvRequired'] == true),
          _buildRequirementChip(
            'مستند إضافي',
            item['additionalDocumentRequired'] == true,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementChip(String title, bool required) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: required ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            required
                ? Icons.check_circle_outline_rounded
                : Icons.remove_circle_outline_rounded,
            size: 13,
            color: required ? const Color(0xFF15803D) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 4),
          Text(
            required ? '$title مطلوب' : '$title غير مطلوب',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: required
                  ? const Color(0xFF15803D)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditInternshipDialog(Map<String, dynamic> item) {
    final titleController = TextEditingController(text: item['title']);
    final trackController = TextEditingController(text: item['track']);
    final locationController = TextEditingController(text: item['location']);
    final seatsController = TextEditingController(text: '${item['seats']}');
    final startDateController = TextEditingController(text: item['startDate']);
    final endDateController = TextEditingController(text: item['endDate']);
    final descriptionController = TextEditingController(
      text: item['description'] ?? '',
    );
    final conditionsController = TextEditingController(
      text: item['conditions'] ?? '',
    );
    bool isOpen = item['isOpen'] == true;
    bool academic = item['academicRecordRequired'] == true;
    bool cv = item['cvRequired'] == true;
    bool additional = item['additionalDocumentRequired'] == true;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'تعديل الفرصة التدريبية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField('عنوان الفرصة', titleController),
                    _dialogField('المسار التدريبي', trackController),
                    _dialogField('مكان التدريب', locationController),
                    _dialogField('عدد المقاعد', seatsController, number: true),
                    Row(
                      children: [
                        Expanded(
                          child: _dialogField(
                            'تاريخ البداية',
                            startDateController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _dialogField(
                            'تاريخ النهاية',
                            endDateController,
                          ),
                        ),
                      ],
                    ),
                    _dialogField(
                      'وصف الفرصة',
                      descriptionController,
                      maxLines: 3,
                    ),
                    _dialogField(
                      'الشروط المطلوبة',
                      conditionsController,
                      maxLines: 2,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'الفرصة مفتوحة للتقديم',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      value: isOpen,
                      onChanged: (v) => setDialogState(() => isOpen = v),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'السجل الأكاديمي',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      value: academic,
                      onChanged: (v) =>
                          setDialogState(() => academic = v ?? false),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'السيرة الذاتية CV',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      value: cv,
                      onChanged: (v) => setDialogState(() => cv = v ?? false),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'مستند إضافي',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      value: additional,
                      onChanged: (v) =>
                          setDialogState(() => additional = v ?? false),
                    ),
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
                  if (titleController.text.trim().isEmpty) return;
                  setState(() {
                    item['title'] = titleController.text.trim();
                    item['track'] = trackController.text.trim();
                    item['location'] = locationController.text.trim();
                    item['seats'] = int.tryParse(seatsController.text) ?? 1;
                    item['startDate'] = startDateController.text.trim();
                    item['endDate'] = endDateController.text.trim();
                    item['description'] = descriptionController.text.trim();
                    item['conditions'] = conditionsController.text.trim();
                    item['isOpen'] = isOpen;
                    item['academicRecordRequired'] = academic;
                    item['cvRequired'] = cv;
                    item['additionalDocumentRequired'] = additional;
                  });
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'حفظ التعديلات',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogField(
    String label,
    TextEditingController controller, {
    bool number = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: number ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: MasarColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: MasarColors.primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicantsBottomSheet(Map<String, dynamic> item) {
    final List applicants = item['applicants'] ?? [];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * .75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: MasarColors.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'قائمة المتقدمين - ${item['title']}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (applicants.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'لا يوجد متقدمون لهذه الفرصة بعد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: MasarColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: applicants.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final applicant = applicants[index];
                          final status = applicant['status'] ?? 'قيد المراجعة';
                          final color = status == 'مقبول'
                              ? Colors.green
                              : status == 'مرفوض'
                              ? Colors.red
                              : Colors.orange;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: MasarColors.lightBlue,
                              child: Icon(
                                Icons.person,
                                color: MasarColors.primaryBlue,
                              ),
                            ),
                            title: Text(
                              applicant['name'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${applicant['university'] ?? ''} • ${applicant['date'] ?? ''}',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: .10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailInfo(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: MasarColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: MasarColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// صفحة مستقلة لإضافة فرصة تدريبية، بتصميم قريب من الصورة المرفقة.
class AddInternshipScreen extends StatefulWidget {
  const AddInternshipScreen({super.key});

  @override
  State<AddInternshipScreen> createState() => _AddInternshipScreenState();
}

class _AddInternshipScreenState extends State<AddInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _savedDraft;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _seatsController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  final _conditionsController = TextEditingController();

  String? _selectedTrack;
  String? _selectedSpecialization;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOpen = true;
  bool _academicRecordRequired = true;
  bool _cvRequired = true;
  bool _additionalDocumentRequired = false;
  final Set<String> _selectedSkills = {};

  static const _tracks = [
    'تطوير التطبيقات',
    'تطوير البرمجيات',
    'الشبكات',
    'الأمن السيبراني',
    'علم البيانات',
    'التصميم',
    'التسويق',
    'إدارة الأعمال',
    'المحاسبة',
  ];

  static const _specializations = [
    'علوم الحاسوب',
    'هندسة البرمجيات',
    'نظم المعلومات',
    'الشبكات',
    'الأمن السيبراني',
    'علم البيانات',
    'إدارة الأعمال',
    'المحاسبة',
    'التسويق',
  ];

  static const _skills = [
    'التواصل الفعال',
    'إدارة الحاسوب',
    'حل المشكلات',
    'العمل ضمن فريق',
    'تحليل البيانات',
    'إدارة الوقت',
    'التفكير النقدي',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _seatsController.dispose();
    _descriptionController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'اختر التاريخ';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial =
        (isStart ? _startDate : _endDate) ??
        (isStart ? now : (_startDate ?? now.add(const Duration(days: 90))));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: isStart
          ? 'اختر تاريخ بداية التدريب'
          : 'اختر تاريخ نهاية التدريب',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: MasarColors.primaryBlue),
          ),
          child: child!,
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
      } else {
        _endDate = picked;
      }
    });
  }

  InputDecoration _decoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        color: Color(0xFF94A3B8),
      ),
      prefixIcon: icon == null
          ? null
          : Icon(icon, size: 18, color: const Color(0xFF64748B)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFFD8E2EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFFD8E2EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: MasarColors.primaryBlue,
          width: 1.4,
        ),
      ),
      errorStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 10),
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required int number,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE4EBF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: MasarColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF17243A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = false,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, required: required),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Color(0xFF17243A),
          ),
          decoration: _decoration(hint, icon: icon),
          validator:
              validator ??
              (required
                  ? (value) => value == null || value.trim().isEmpty
                        ? 'هذا الحقل مطلوب'
                        : null
                  : null),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String hint,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, required: required),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: _decoration(hint, icon: icon),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Color(0xFF17243A),
          ),
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: required
              ? (value) => value == null ? 'يرجى اختيار $label' : null
              : null,
        ),
      ],
    );
  }

  Widget _dateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, required: true),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: InputDecorator(
            decoration: _decoration('اختر التاريخ', icon: Icons.calendar_month),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: date == null
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF334155),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 19,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _documentRequirement({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFE1E8F0)),
            ),
            child: Icon(icon, color: const Color(0xFF64748B), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17243A),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value ? 'مطلوب' : 'اختياري',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: value ? const Color(0xFF15803D) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 5),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MasarColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  // حفظ نسخة من البيانات كمسودة مع إبقاء المستخدم داخل صفحة الإضافة.
  void _saveDraft() {
    FocusScope.of(context).unfocus();
    final result = <String, dynamic>{
      'title': _titleController.text.trim().isEmpty
          ? 'فرصة تدريبية جديدة (مسودة)'
          : _titleController.text.trim(),
      'track': _selectedTrack ?? 'غير محدد',
      'specialization': _selectedSpecialization ?? 'غير محدد',
      'location': _locationController.text.trim().isEmpty
          ? 'غير محدد'
          : _locationController.text.trim(),
      'seats': int.tryParse(_seatsController.text.trim()) ?? 1,
      'startDate': _formatDate(_startDate),
      'endDate': _formatDate(_endDate),
      'isOpen': false,
      'isDraft': true,
      'description': _descriptionController.text.trim(),
      'conditions': _conditionsController.text.trim(),
      'skills': _selectedSkills.toList(),
      'academicRecordRequired': _academicRecordRequired,
      'cvRequired': _cvRequired,
      'additionalDocumentRequired': _additionalDocumentRequired,
    };
    setState(() {
      _savedDraft = result;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('تم حفظ المسودة بنجاح'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تعبئة الحقول المطلوبة'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد تاريخ البداية والنهاية'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تاريخ النهاية يجب أن يكون بعد تاريخ البداية'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final result = <String, dynamic>{
      'title': _titleController.text.trim(),
      'track': _selectedTrack!,
      'specialization': _selectedSpecialization!,
      'location': _locationController.text.trim(),
      'seats': int.tryParse(_seatsController.text.trim()) ?? 1,
      'startDate': _formatDate(_startDate),
      'endDate': _formatDate(_endDate),
      'isOpen': _isOpen,
      'isDraft': false,
      'description': _descriptionController.text.trim(),
      'conditions': _conditionsController.text.trim(),
      'skills': _selectedSkills.toList(),
      'academicRecordRequired': _academicRecordRequired,
      'cvRequired': _cvRequired,
      'additionalDocumentRequired': _additionalDocumentRequired,
    };
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip: 'رجوع',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF334155),
            ),
          ),

          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: Color(0xFFE5EAF1)),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.work_outline_rounded,
                                color: MasarColors.primaryBlue,
                                size: 25,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'إضافة فرصة تدريبية جديدة',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        color: Color(0xFF17243A),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'قم بتعبئة بيانات الفرصة التدريبية لتتمكن من نشرها للمتقدمين',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _sectionCard(
                            number: 1,
                            title: 'المعلومات الأساسية',
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final wide = constraints.maxWidth >= 650;
                                  final fields = <Widget>[
                                    _textField(
                                      label: 'اسم الفرصة التدريبية',
                                      controller: _titleController,
                                      hint: 'أدخل اسم الفرصة التدريبية',
                                      required: true,
                                      icon: Icons.work_outline,
                                    ),
                                    _dropdown(
                                      label: 'المسار التدريبي',
                                      hint: 'اختر المسار التدريبي',
                                      options: _tracks,
                                      value: _selectedTrack,
                                      required: true,
                                      icon: Icons.route_outlined,
                                      onChanged: (v) =>
                                          setState(() => _selectedTrack = v),
                                    ),
                                    _dropdown(
                                      label: 'التخصص المطلوب',
                                      hint: 'اختر التخصص',
                                      options: _specializations,
                                      value: _selectedSpecialization,
                                      required: true,
                                      icon: Icons.school_outlined,
                                      onChanged: (v) => setState(
                                        () => _selectedSpecialization = v,
                                      ),
                                    ),
                                    _textField(
                                      label: 'عدد المقاعد',
                                      controller: _seatsController,
                                      hint: 'أدخل العدد',
                                      required: true,
                                      keyboardType: TextInputType.number,
                                      icon: Icons.event_seat_outlined,
                                      validator: (v) {
                                        final n = int.tryParse(v ?? '');
                                        if (n == null || n < 1) {
                                          return 'أدخل عددًا صحيحًا أكبر من صفر';
                                        }
                                        return null;
                                      },
                                    ),
                                  ];
                                  if (!wide) {
                                    return Column(
                                      children: [
                                        for (
                                          var i = 0;
                                          i < fields.length;
                                          i++
                                        ) ...[
                                          fields[i],
                                          if (i != fields.length - 1)
                                            const SizedBox(height: 16),
                                        ],
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: fields[0]),
                                          const SizedBox(width: 18),
                                          Expanded(child: fields[1]),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: fields[2]),
                                          const SizedBox(width: 18),
                                          Expanded(child: fields[3]),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          _sectionCard(
                            number: 2,
                            title: 'موقع وتاريخ التدريب',
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final wide = constraints.maxWidth >= 700;
                                  final location = _textField(
                                    label: 'مكان التدريب',
                                    controller: _locationController,
                                    hint: 'أدخل مكان التدريب أو اكتب عن بُعد',
                                    required: true,
                                    icon: Icons.location_on_outlined,
                                  );
                                  final start = _dateField(
                                    'تاريخ البداية',
                                    _startDate,
                                    () => _pickDate(isStart: true),
                                  );
                                  final end = _dateField(
                                    'تاريخ النهاية',
                                    _endDate,
                                    () => _pickDate(isStart: false),
                                  );
                                  if (!wide) {
                                    return Column(
                                      children: [
                                        location,
                                        const SizedBox(height: 16),
                                        start,
                                        const SizedBox(height: 16),
                                        end,
                                      ],
                                    );
                                  }
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: location),
                                      const SizedBox(width: 18),
                                      Expanded(child: start),
                                      const SizedBox(width: 18),
                                      Expanded(child: end),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          _sectionCard(
                            number: 3,
                            title: 'الوصف والشروط',
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final wide = constraints.maxWidth >= 650;
                                  final description = _textField(
                                    label: 'وصف الفرصة التدريبية',
                                    controller: _descriptionController,
                                    hint:
                                        'اكتب وصفًا مفصلًا عن الفرصة التدريبية...',
                                    required: true,
                                    maxLines: 4,
                                    icon: Icons.description_outlined,
                                  );
                                  final conditions = _textField(
                                    label: 'الشروط المطلوبة',
                                    controller: _conditionsController,
                                    hint: 'أدخل الشروط المطلوبة...',
                                    maxLines: 4,
                                    icon: Icons.verified_user_outlined,
                                  );
                                  if (!wide) {
                                    return Column(
                                      children: [
                                        description,
                                        const SizedBox(height: 16),
                                        conditions,
                                      ],
                                    );
                                  }
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 3, child: description),
                                      const SizedBox(width: 18),
                                      Expanded(flex: 2, child: conditions),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          _sectionCard(
                            number: 4,
                            title: 'المهارات المطلوبة',
                            children: [
                              _fieldLabel('اختر المهارات المناسبة'),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _skills.map((skill) {
                                  final selected = _selectedSkills.contains(
                                    skill,
                                  );
                                  return FilterChip(
                                    label: Text(
                                      skill,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                      ),
                                    ),
                                    selected: selected,
                                    showCheckmark: true,
                                    selectedColor: MasarColors.lightBlue,
                                    checkmarkColor: MasarColors.primaryBlue,
                                    side: BorderSide(
                                      color: selected
                                          ? MasarColors.primaryBlue
                                          : const Color(0xFFD8E2EF),
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          _selectedSkills.add(skill);
                                        } else {
                                          _selectedSkills.remove(skill);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          _sectionCard(
                            number: 5,
                            title: 'المرفقات ومتطلبات التقديم',
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: const Color(0xFFE1E8F0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _documentRequirement(
                                      icon: Icons.school_outlined,
                                      title: 'السجل الأكاديمي',
                                      subtitle: 'Academic Record',
                                      value: _academicRecordRequired,
                                      onChanged: (v) => setState(
                                        () => _academicRecordRequired = v,
                                      ),
                                    ),
                                    const Divider(height: 10),
                                    _documentRequirement(
                                      icon: Icons.badge_outlined,
                                      title: 'السيرة الذاتية',
                                      subtitle: 'CV',
                                      value: _cvRequired,
                                      onChanged: (v) =>
                                          setState(() => _cvRequired = v),
                                    ),
                                    const Divider(height: 10),
                                    _documentRequirement(
                                      icon: Icons.attach_file_rounded,
                                      title: 'مستندات إضافية',
                                      subtitle: 'Additional Documents',
                                      value: _additionalDocumentRequired,
                                      onChanged: (v) => setState(
                                        () => _additionalDocumentRequired = v,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: const Color(0xFFE1E8F0),
                                  ),
                                ),
                                child: SwitchListTile(
                                  value: _isOpen,
                                  activeColor: MasarColors.primaryBlue,
                                  title: const Text(
                                    'حالة الفرصة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _isOpen
                                        ? 'الفرصة مفتوحة للتقديم'
                                        : 'سيتم حفظ الفرصة كفرصة مغلقة',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  onChanged: (v) => setState(() => _isOpen = v),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE5EAF1))),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _saveDraft,
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: const Text(
                            'حفظ كمسودة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: MasarColors.primaryBlue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: MasarColors.primaryBlue,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.send_rounded, size: 17),
                          label: const Text(
                            'نشر الفرصة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MasarColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
