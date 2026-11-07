import 'package:flutter/material.dart';

class Trainee {
  final int id;
  final String name;
  final String track;
  final String startDate;
  final int completedHours;
  final int totalHours;
  final int attendanceDays;
  final int absenceDays;
  final List<String> weeklyReports;
  final List<String> completedTasks;
  final String pdfFileName;

  Trainee({
    required this.id,
    required this.name,
    required this.track,
    required this.startDate,
    required this.completedHours,
    required this.totalHours,
    required this.attendanceDays,
    required this.absenceDays,
    required this.weeklyReports,
    required this.completedTasks,
    required this.pdfFileName,
  });
}

class CompanyReportsScreen extends StatefulWidget {
  const CompanyReportsScreen({super.key});

  @override
  State<CompanyReportsScreen> createState() =>
      _CompanyReportsScreenState();
}

class _CompanyReportsScreenState
    extends State<CompanyReportsScreen> {
  final List<Trainee> trainees = [
    Trainee(
      id: 1,
      name: 'ليان أحمد',
      track: 'Data Analysis',
      startDate: '2026/09/01',
      completedHours: 164,
      totalHours: 280,
      attendanceDays: 22,
      absenceDays: 1,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
        'الأسبوع الثاني - مكتمل',
        'الأسبوع الثالث - قيد المراجعة',
      ],
      completedTasks: [
        'تنظيف ومعالجة البيانات باستخدام Python',
        'إنشاء لوحة تحليلات تفاعلية باستخدام Power BI',
        'كتابة استعلامات SQL لمقارنة الأداء الأسبوعي',
      ],
      pdfFileName: 'تقرير_الأسبوع_الثالث_ليان_أحمد.pdf',
    ),
    Trainee(
      id: 3,
      name: 'سارة خالد',
      track: 'UI/UX Design',
      startDate: '2026/09/10',
      completedHours: 90,
      totalHours: 280,
      attendanceDays: 12,
      absenceDays: 2,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
      ],
      completedTasks: [
        'إجراء مقابلات أو استبيانات لفهم مشكلات المستخدمين المستهدفين',
        'تحليل المنافسين لدراسة نقاط القوة والضعف في التطبيقات المشابهة',
        'اختبار النماذج مع مستخدمين أو مشرفين لجمع الملاحظات وتحسين التجربة (Usability Testing)',
      ],
      pdfFileName: 'تقرير_سارة_خالد.pdf',
    ),
    Trainee(
      id: 4,
      name: 'عمر الفاروق',
      track: 'Networking',
      startDate: '2026/08/01',
      completedHours: 240,
      totalHours: 280,
      attendanceDays: 31,
      absenceDays: 0,
      weeklyReports: [
        'الأسبوع 1 إلى 5 - جميعها مكتملة',
      ],
      completedTasks: [
        'إعداد شبكات الربط المحلي (LAN) واللاسلكي (WLAN)، وتوزيع عناوين الأجهزة (IPv4 / IPv6)',
        'ضبط إعدادات الأمان الأساسية مثل شبكات الـ VLAN وتقسيم الشبكات الفرعية (Subnetting)',
        'مراقبة حركة مرور البيانات (Traffic Monitoring) لكشف أي نشاط مشبوه أو اختراقات محتملة',
        'توصيل أجهزة فعلية، إعداد كلمات المرور، تفعيل بروتوكولات التوجيه، واختبار الاتصال بين الأجهزة',
      ],
      pdfFileName: 'تقرير_عمر_الفاروق.pdf',
    ),
    Trainee(
      id: 5,
      name: 'رنيم السعيد',
      track: 'Programming',
      startDate: '2026/09/05',
      completedHours: 120,
      totalHours: 280,
      attendanceDays: 16,
      absenceDays: 1,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
        'الأسبوع الثاني - مكتمل',
      ],
      completedTasks: [
        'فحص الأكواد لاكتشاف الأخطاء البرمجية (Bugs) وإصلاحها',
        'ربط التطبيقات بقواعد البيانات (مثل SQL)',
      ],
      pdfFileName: 'تقرير_رنيم_السعيد.pdf',
    ),
    Trainee(
      id: 6,
      name: 'حمزة العمري',
      track: 'CyberSecurity',
      startDate: '2026/09/12',
      completedHours: 75,
      totalHours: 280,
      attendanceDays: 10,
      absenceDays: 0,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
      ],
      completedTasks: [
        'تحليل الهجمات الإلكترونية فور حدوثها ومعرفة مصدرها وكيفية إيقافها',
        'إعداد جدران الحماية (Firewalls) وأنظمة كشف التسلل',
      ],
      pdfFileName: 'تقرير_حمزة_العمري.pdf',
    ),
    Trainee(
      id: 2,
      name: 'أحمد محمود',
      track: 'Web Development',
      startDate: '2026/08/15',
      completedHours: 210,
      totalHours: 280,
      attendanceDays: 28,
      absenceDays: 0,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
        'الأسبوع الثاني - مكتمل',
        'الأسبوع الثالث - مكتمل',
        'الأسبوع الرابع - مكتمل',
      ],
      completedTasks: [
        'بناء واجهات المستخدم بالكامل بواسطة React',
        'ربط API للتحقق من بيانات المستخدمين',
        'تحسين أداء واستجابة الشاشات للهواتف المحمولة',
      ],
      pdfFileName: 'تقرير_الأسبوع_الرابع_أحمد_محمود.pdf',
    ),
  ];

  final Set<int> approvedTraineeIds = <int>{};

  bool _isApproved(Trainee trainee) {
    return approvedTraineeIds.contains(trainee.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF17243A),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            'التقارير',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17243A),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE8EDF5),
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          itemCount: trainees.length,
          itemBuilder: (context, index) {
            return _buildReportCard(trainees[index]);
          },
        ),
      ),
    );
  }

  Widget _buildReportCard(Trainee trainee) {
    final lastReport = trainee.weeklyReports.isNotEmpty
        ? trainee.weeklyReports.last
        : 'لا يوجد تقرير';

    final isApproved = _isApproved(trainee);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E8F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF4D8FF7),
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              trainee.name,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF17243A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              trainee.track,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Color(0xFF7B8799),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _buildStatusBadge(
                  isApproved: isApproved,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 1,
              color: const Color(0xFFECEFF4),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              icon: Icons.article_outlined,
              title: 'التقرير الأخير',
              value: lastReport,
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.calendar_today_outlined,
              title: 'تاريخ بداية التدريب',
              value: trainee.startDate,
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.access_time_rounded,
              title: 'الساعات',
              value:
                  '${trainee.completedHours} من ${trainee.totalHours} ساعة',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.fact_check_outlined,
              title: 'الحضور والغياب',
              value:
                  '${trainee.attendanceDays} حضور • ${trainee.absenceDays} غياب',
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _buildLightButton(
                    icon: Icons.verified_outlined,
                    label: 'اعتماد',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFEAF9F0),
                        Color(0xFFDDF4E7),
                      ],
                    ),
                    foregroundColor: const Color(0xFF2F9E5B),
                    onPressed: () {
                      if (!_isApproved(trainee)) {
                        _showApproveDialog(trainee);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLightButton(
                    icon: Icons.note_add_outlined,
                    label: 'ملاحظة',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF1EEFF),
                        Color(0xFFE7E1FF),
                      ],
                    ),
                    foregroundColor: const Color(0xFF6E5ACB),
                    onPressed: () {
                      _showAddNoteDialog(
                        context,
                        trainee.name,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge({
    required bool isApproved,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isApproved
            ? const Color(0xFFEAF8EF)
            : const Color(0xFFFFF4DE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isApproved
                  ? const Color(0xFF43A866)
                  : const Color(0xFFE9A72C),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isApproved ? 'معتمد' : 'قيد المراجعة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isApproved
                  ? const Color(0xFF398B55)
                  : const Color(0xFFB97916),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F6FC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 17,
            color: const Color(0xFF718096),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title:',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: Color(0xFF8A95A5),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLightButton({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required Color foregroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: foregroundColor.withOpacity(0.10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: foregroundColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApproveDialog(Trainee trainee) {
    if (_isApproved(trainee)) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'اعتماد التقرير',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Color(0xFF17243A),
              ),
            ),
            content: Text(
              'هل أنت متأكد من اعتماد التقرير الخاص '
              'بالمتدرب ${trainee.name}؟',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Color(0xFF5F6B7A),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF7B8799),
                  ),
                ),
              ),
              _dialogButton(
                label: 'اعتماد',
                color: const Color(0xFF43A866),
                onPressed: () {
                  Navigator.pop(dialogContext);

                  setState(() {
                    approvedTraineeIds.add(trainee.id);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم اعتماد تقرير ${trainee.name}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dialogButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color.withOpacity(0.10),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
    String name,
  ) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'إضافة ملاحظة لـ $name',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17243A),
              ),
            ),
            content: TextField(
              controller: noteController,
              maxLines: 4,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظتك للطالب هنا...',
                hintStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Color(0xFF9AA4B2),
                ),
                filled: true,
                fillColor: const Color(0xFFF7F9FC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E6EF),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E6EF),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF8AAFE8),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF7B8799),
                  ),
                ),
              ),
              _dialogButton(
                label: 'حفظ الملاحظة',
                color: const Color(0xFF6E5ACB),
                onPressed: () {
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تمت إضافة الملاحظة بنجاح',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}