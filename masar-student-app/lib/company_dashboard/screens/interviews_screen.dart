import 'package:flutter/material.dart';

enum InterviewType { online, inPerson }

enum InterviewStatus { scheduled, ongoing, completed, cancelled }

class Interview {
  final int id;
  String studentName;
  String opportunity;
  String date;
  String time;
  InterviewType type;
  String locationOrLink;
  String interviewer;
  InterviewStatus status;
  String notes;

  Interview({
    required this.id,
    required this.studentName,
    required this.opportunity,
    required this.date,
    required this.time,
    required this.type,
    required this.locationOrLink,
    required this.interviewer,
    required this.status,
    this.notes = '',
  });
}

class InterviewsScreen extends StatefulWidget {
  // تمت إضافة هذا المتغير للسماح بفتح نافذة الجدولة من شاشة Home.
  final bool openAddInterviewDialog;

  const InterviewsScreen({super.key, this.openAddInterviewDialog = false});

  /// يضيف مقابلة إلى القائمة المشتركة التي تعرضها شاشة إدارة المقابلات.
  static void addSharedInterview(Interview interview) {
    _InterviewsScreenState._sharedInterviews.add(interview);
  }

  @override
  State<InterviewsScreen> createState() => _InterviewsScreenState();
}

class _InterviewsScreenState extends State<InterviewsScreen> {
  bool calendarView = false;
  String search = '';
  String statusFilter = 'الكل';
  String typeFilter = 'الكل';

  DateTime _selectedCalendarDate = DateTime(2026, 10, 8);
  DateTime _currentMonth = DateTime(2026, 10, 1);

  static final List<Interview> _sharedInterviews = [
    Interview(
      id: 1,
      studentName: 'أحمد محمد',
      opportunity: 'تطوير البرمجيات',
      date: '2026/10/08',
      time: '10:00 AM',
      type: InterviewType.online,
      locationOrLink: 'https://meet.google.com/abc-defg-hij',
      interviewer: 'د. خالد العمري',
      status: InterviewStatus.scheduled,
    ),
    Interview(
      id: 2,
      studentName: 'نورة خالد',
      opportunity: 'تحليل البيانات',
      date: '2026/10/08',
      time: '11:30 AM',
      type: InterviewType.inPerson,
      locationOrLink: 'قاعة الاجتماعات B - الطابق الثاني',
      interviewer: 'م. سارة علي',
      status: InterviewStatus.ongoing,
    ),
    Interview(
      id: 3,
      studentName: 'عبدالله فيصل',
      opportunity: 'هندسة الشبكات',
      date: '2026/10/07',
      time: '02:00 PM',
      type: InterviewType.online,
      locationOrLink: 'https://zoom.us/j/123456789',
      interviewer: 'د. خالد العمري',
      status: InterviewStatus.completed,
    ),
  ];

  List<Interview> get interviews => _sharedInterviews;

  // ============================================================
  // فتح نافذة الجدولة تلقائيًا عند الوصول من الشاشة الرئيسية
  // ============================================================

  @override
  void initState() {
    super.initState();

    if (widget.openAddInterviewDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showAddInterviewDialog();
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStatistics(),
              const SizedBox(height: 20),
              _buildFilters(),
              const SizedBox(height: 20),
              calendarView ? _buildCalendarView() : _buildInterviewsTable(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // رأس الصفحة
  // ============================================================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Color(0xFF17243A),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إدارة المقابلات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17243A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'جدولة ومتابعة مقابلات المتقدمين',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: Color(0xFF7C899E),
                  ),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _showAddInterviewDialog,
          icon: const Icon(Icons.add),
          label: const Text(
            'جدولة مقابلة جديدة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D6EFD),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // الإحصائيات
  // ============================================================

  Widget _buildStatistics() {
    final active = interviews
        .where(
          (item) =>
              item.status == InterviewStatus.scheduled ||
              item.status == InterviewStatus.ongoing,
        )
        .length;

    final completed = interviews
        .where((item) => item.status == InterviewStatus.completed)
        .length;

    final cancelled = interviews
        .where((item) => item.status == InterviewStatus.cancelled)
        .length;

    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'إجمالي المقابلات',
            number: interviews.length.toString(),
            icon: Icons.event_note,
            color: const Color(0xFF0D6EFD),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'مقابلات نشطة',
            number: active.toString(),
            icon: Icons.today,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'مكتملة',
            number: completed.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'ملغاة',
            number: cancelled.toString(),
            icon: Icons.cancel,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String number,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF173B73),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: Color(0xFF6D82A1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // البحث والفلاتر
  // ============================================================

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  search = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث باسم الطالب أو الفرصة...',
                hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _dropdown(
            value: statusFilter,
            items: const ['الكل', 'مجدولة', 'جارية', 'مكتملة', 'ملغاة'],
            onChanged: (value) {
              setState(() {
                statusFilter = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          _dropdown(
            value: typeFilter,
            items: const ['الكل', 'أونلاين', 'حضوري'],
            onChanged: (value) {
              setState(() {
                typeFilter = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'عرض القائمة',
                  onPressed: () {
                    setState(() {
                      calendarView = false;
                    });
                  },
                  icon: Icon(
                    Icons.list,
                    color: calendarView ? Colors.grey : const Color(0xFF0D6EFD),
                  ),
                ),
                IconButton(
                  tooltip: 'عرض التقويم',
                  onPressed: () {
                    setState(() {
                      calendarView = true;
                    });
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: calendarView ? const Color(0xFF0D6EFD) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD6E2F2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ============================================================
  // جدول المقابلات
  // ============================================================

  Widget _buildInterviewsTable() {
    final filtered = interviews.where((item) {
      final searchMatch =
          item.studentName.contains(search) ||
          item.opportunity.contains(search);

      final statusMatch =
          statusFilter == 'الكل' || _getStatusText(item.status) == statusFilter;

      final typeMatch =
          typeFilter == 'الكل' ||
          (typeFilter == 'أونلاين' && item.type == InterviewType.online) ||
          (typeFilter == 'حضوري' && item.type == InterviewType.inPerson);

      return searchMatch && statusMatch && typeMatch;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Column(
        children: [
          _tableHeader(),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(35),
              child: Text(
                'لا توجد مقابلات مطابقة',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
              ),
            )
          else
            ...filtered.map((item) => _buildInterviewRow(item)),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF0F5FB),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'المتقدم والفرصة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'الموعد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'النوع والمكان',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'المقابل',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'الحالة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'الإجراءات',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewRow(Interview item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EEF6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.studentName,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF173B73),
                  ),
                ),
                Text(
                  item.opportunity,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.date}\n${item.time}',
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.type == InterviewType.online
                  ? 'أونلاين'
                  : item.locationOrLink,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.interviewer,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
            ),
          ),
          Expanded(child: _statusBadge(item.status)),
          Expanded(
            flex: 2,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 2,
              children: [
                IconButton(
                  tooltip: 'تقييم المقابلة',
                  onPressed: () => _showEvaluationDialog(item),
                  icon: const Icon(
                    Icons.rate_review_outlined,
                    color: Color(0xFF0D6EFD),
                  ),
                ),
                IconButton(
                  tooltip: 'تعديل الموعد',
                  onPressed: () => _showEditInterviewDialog(item),
                  icon: const Icon(Icons.edit_calendar, color: Colors.orange),
                ),
                IconButton(
                  tooltip: 'إلغاء المقابلة',
                  onPressed: () => _showCancelInterviewDialog(item),
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // الإجراء الأول: تقييم المقابلة
  // ============================================================

  void _showEvaluationDialog(Interview item) {
    int rating = 3;
    final notesController = TextEditingController(text: item.notes);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text(
                  'تقييم المقابلة',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الطالب: ${item.studentName}',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'الفرصة: ${item.opportunity}',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'التقييم',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          return IconButton(
                            onPressed: () {
                              setDialogState(() {
                                rating = star;
                              });
                            },
                            icon: Icon(
                              star <= rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 30,
                            ),
                          );
                        }),
                      ),
                      TextField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظات التقييم',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('إغلاق'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      item.notes = notesController.text.trim();

                      if (mounted) {
                        setState(() {});
                      }

                      Navigator.pop(dialogContext);
                      _showMessage('تم حفظ تقييم المقابلة: $rating/5');
                    },
                    child: const Text('حفظ التقييم'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // الإجراء الثاني: تعديل الموعد
  // ============================================================

  void _showEditInterviewDialog(Interview item) {
    final studentController = TextEditingController(text: item.studentName);
    final opportunityController = TextEditingController(text: item.opportunity);
    final interviewerController = TextEditingController(text: item.interviewer);
    final locationController = TextEditingController(text: item.locationOrLink);
    final notesController = TextEditingController(text: item.notes);

    DateTime? selectedDate = DateTime.tryParse(item.date.replaceAll('/', '-'));

    TimeOfDay? selectedTime;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text(
                  'تعديل موعد المقابلة',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                content: SizedBox(
                  width: 440,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: studentController,
                          decoration: const InputDecoration(
                            labelText: 'اسم الطالب',
                          ),
                        ),
                        TextField(
                          controller: opportunityController,
                          decoration: const InputDecoration(
                            labelText: 'الفرصة التدريبية',
                          ),
                        ),
                        TextField(
                          controller: interviewerController,
                          decoration: const InputDecoration(
                            labelText: 'اسم المقابل',
                          ),
                        ),
                        TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            labelText: item.type == InterviewType.online
                                ? 'رابط اللقاء'
                                : 'المكان / القاعة',
                          ),
                        ),
                        TextField(
                          controller: notesController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'ملاحظات',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_month),
                          title: Text(
                            selectedDate == null
                                ? 'اختيار التاريخ'
                                : '${selectedDate!.year}/'
                                      '${selectedDate!.month.toString().padLeft(2, '0')}/'
                                      '${selectedDate!.day.toString().padLeft(2, '0')}',
                          ),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: dialogContext,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                            );

                            if (picked != null) {
                              setDialogState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.access_time),
                          title: Text(
                            selectedTime == null
                                ? 'الوقت الحالي: ${item.time}'
                                : selectedTime!.format(context),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: dialogContext,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );

                            if (picked != null) {
                              setDialogState(() {
                                selectedTime = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      item.studentName = studentController.text.trim();
                      item.opportunity = opportunityController.text.trim();
                      item.interviewer = interviewerController.text.trim();
                      item.locationOrLink = locationController.text.trim();
                      item.notes = notesController.text.trim();

                      if (selectedDate != null) {
                        item.date =
                            '${selectedDate!.year}/'
                            '${selectedDate!.month.toString().padLeft(2, '0')}/'
                            '${selectedDate!.day.toString().padLeft(2, '0')}';
                      }

                      if (selectedTime != null) {
                        item.time = selectedTime!.format(context);
                      }

                      if (mounted) {
                        setState(() {});
                      }

                      Navigator.pop(dialogContext);
                      _showMessage('تم تعديل المقابلة بنجاح');
                    },
                    child: const Text('حفظ التعديلات'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // الإجراء الثالث: إلغاء المقابلة
  // ============================================================

  void _showCancelInterviewDialog(Interview item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 42,
            ),
            title: const Text(
              'إلغاء المقابلة',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            content: Text(
              'هل أنت متأكد من إلغاء مقابلة ${item.studentName}؟',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('رجوع'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  item.status = InterviewStatus.cancelled;

                  if (mounted) {
                    setState(() {});
                  }

                  Navigator.pop(dialogContext);
                  _showMessage('تم إلغاء المقابلة');
                },
                child: const Text('تأكيد الإلغاء'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.scheduled:
        return 'مجدولة';
      case InterviewStatus.ongoing:
        return 'جارية';
      case InterviewStatus.completed:
        return 'مكتملة';
      case InterviewStatus.cancelled:
        return 'ملغاة';
    }
  }

  Widget _statusBadge(InterviewStatus status) {
    Color color;

    switch (status) {
      case InterviewStatus.scheduled:
        color = Colors.blue;
        break;
      case InterviewStatus.ongoing:
        color = Colors.orange;
        break;
      case InterviewStatus.completed:
        color = Colors.green;
        break;
      case InterviewStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getStatusText(status),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // ============================================================
  // التقويم
  // ============================================================

  Widget _buildCalendarView() {
    const List<String> weekDays = [
      'أحد',
      'إثنين',
      'ثلاثاء',
      'أربعاء',
      'خميس',
      'جمعة',
      'سبت',
    ];

    final int daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );

    final DateTime firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );

    final int startingWeekday = firstDayOfMonth.weekday % 7;

    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDCE7F5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'الشهر السابق',
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios, size: 14),
                ),
                Text(
                  '${_currentMonth.year} / '
                  '${_currentMonth.month.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF173B73),
                  ),
                ),
                IconButton(
                  tooltip: 'الشهر التالي',
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays
                  .map(
                    (day) => SizedBox(
                      width: 45,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Color(0xFF7C899E),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Divider(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1.3,
              ),
              itemCount: daysInMonth + startingWeekday,
              itemBuilder: (context, index) {
                if (index < startingWeekday) {
                  return const SizedBox.shrink();
                }

                final int day = index - startingWeekday + 1;

                final DateTime currentDate = DateTime(
                  _currentMonth.year,
                  _currentMonth.month,
                  day,
                );

                final bool isSelected =
                    _selectedCalendarDate.year == currentDate.year &&
                    _selectedCalendarDate.month == currentDate.month &&
                    _selectedCalendarDate.day == currentDate.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCalendarDate = currentDate;
                    });

                    final String formattedDate =
                        '${currentDate.year}/'
                        '${currentDate.month.toString().padLeft(2, '0')}/'
                        '${currentDate.day.toString().padLeft(2, '0')}';

                    _showMessage('تم اختيار التاريخ: $formattedDate');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0D6EFD)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF17243A),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // نافذة جدولة المقابلة
  // ============================================================

  void _showAddInterviewDialog() {
    showInterviewScheduleDialog(
      context,
      onSave: (interview) {
        setState(() {
          _sharedInterviews.add(interview);
        });
      },
      onMessage: _showMessage,
    );
  }
}

Future<void> showInterviewScheduleDialog(
  BuildContext context, {
  required void Function(Interview interview) onSave,
  required void Function(String message) onMessage,
}) async {
  final formKey = GlobalKey<FormState>();

  final studentNameController = TextEditingController();
  final interviewerController = TextEditingController();
  final linkController = TextEditingController();
  final notesController = TextEditingController();

  const opportunityOptions = <String>[
    'تطوير البرمجيات',
    'تحليل البيانات',
    'هندسة الشبكات',
    'التسويق',
    'قواعد البيانات',
  ];

  String? selectedOpportunity;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  InterviewType selectedType = InterviewType.online;

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Cairo',
        color: Colors.grey,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF7C899E), size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDCE7F5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDCE7F5)),
      ),
    );
  }

  Widget typeButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0D6EFD) : const Color(0xFFF6F8FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF0D6EFD) : const Color(0xFFE8EEF6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(Icons.check_circle, size: 18, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : const Color(0xFF173B73),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : const Color(0xFF173B73),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text, {bool isRequired = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173B73),
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final isOnline = selectedType == InterviewType.online;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 680,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Dialg
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F0FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: Color(0xFF0D6EFD),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'جدولة مقابلة جديدة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF17243A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'أدخل تفاصيل المقابلة لجدولتها وإشعار الأطراف',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: Color(0xFF7C899E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(Icons.close, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE8EEF6)),

                      // Form Body
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel('اسم الطالب', isRequired: true),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: studentNameController,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                ),
                                decoration: inputDecoration(
                                  hint: 'أدخل اسم الطالب المتقدم',
                                  icon: Icons.person_outline,
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'يرجى إدخال اسم الطالب'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              buildLabel('الفرصة التدريبية', isRequired: true),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedOpportunity,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: Color(0xFF17243A),
                                ),
                                decoration: inputDecoration(
                                  hint: 'اختر الفرصة التدريبية',
                                  icon: Icons.work_outline,
                                ),
                                items: opportunityOptions
                                    .map(
                                      (op) => DropdownMenuItem(
                                        value: op,
                                        child: Text(op),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setDialogState(() {
                                    selectedOpportunity = val;
                                  });
                                },
                                validator: (val) =>
                                    val == null ? 'يرجى اختيار الفرصة' : null,
                              ),
                              const SizedBox(height: 16),

                              buildLabel('نوع المقابلة', isRequired: true),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: typeButton(
                                      title: 'عن بعد(online)',
                                      icon: Icons.videocam_outlined,
                                      selected: isOnline,
                                      onTap: () {
                                        setDialogState(() {
                                          selectedType = InterviewType.online;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: typeButton(
                                      title: 'حضوري بالشركة',
                                      icon: Icons.location_on_outlined,
                                      selected: !isOnline,
                                      onTap: () {
                                        setDialogState(() {
                                          selectedType = InterviewType.inPerson;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildLabel(
                                          'تاريخ المقابلة',
                                          isRequired: true,
                                        ),
                                        const SizedBox(height: 6),
                                        InkWell(
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: dialogContext,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2030),
                                            );
                                            if (picked != null) {
                                              setDialogState(() {
                                                selectedDate = picked;
                                              });
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFDCE7F5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: Color(0xFF7C899E),
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  selectedDate == null
                                                      ? 'اختر التاريخ'
                                                      : '${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildLabel('الوقت', isRequired: true),
                                        const SizedBox(height: 6),
                                        InkWell(
                                          onTap: () async {
                                            final picked = await showTimePicker(
                                              context: dialogContext,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (picked != null) {
                                              setDialogState(() {
                                                selectedTime = picked;
                                              });
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFDCE7F5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  color: Color(0xFF7C899E),
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  selectedTime == null
                                                      ? 'اختر الوقت'
                                                      : selectedTime!.format(
                                                          context,
                                                        ),
                                                  style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              buildLabel(
                                isOnline ? 'رابط اللقاء' : 'المكان / القاعة',
                                isRequired: true,
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: linkController,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                ),
                                decoration: inputDecoration(
                                  hint: isOnline
                                      ? 'https://meet.google.com/...'
                                      : 'قاعة الاجتماعات A...',
                                  icon: isOnline
                                      ? Icons.link
                                      : Icons.place_outlined,
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'يرجى تحديد المكان أو الرابط'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              buildLabel('اسم المقابل', isRequired: true),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: interviewerController,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                ),
                                decoration: inputDecoration(
                                  hint: 'د. خالد العمري',
                                  icon: Icons.person_pin_outlined,
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'يرجى إدخال اسم المقابل'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              buildLabel('ملاحظات إضافية'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: notesController,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'أي ملاحظات خاصة بالمقابلة...',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFDCE7F5),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFDCE7F5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer Actions
                      const Divider(height: 1, color: Color(0xFFE8EEF6)),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xFF7C899E),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (selectedDate == null) {
                                  onMessage('يرجى اختيار تاريخ المقابلة');
                                  return;
                                }
                                if (selectedTime == null) {
                                  onMessage('يرجى اختيار وقت المقابلة');
                                  return;
                                }

                                if (formKey.currentState!.validate()) {
                                  final formattedDate =
                                      '${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}';

                                  final newInterview = Interview(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    studentName: studentNameController.text
                                        .trim(),
                                    opportunity: selectedOpportunity!,
                                    date: formattedDate,
                                    time: selectedTime!.format(context),
                                    type: selectedType,
                                    locationOrLink: linkController.text.trim(),
                                    interviewer: interviewerController.text
                                        .trim(),
                                    status: InterviewStatus.scheduled,
                                    notes: notesController.text.trim(),
                                  );

                                  onSave(newInterview);
                                  Navigator.pop(dialogContext);
                                  onMessage('تمت جدولة المقابلة بنجاح');
                                }
                              },
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text(
                                'حفظ الموعد',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D6EFD),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
            ),
          );
        },
      );
    },
  );
}
