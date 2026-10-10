import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class SmartMatchingScreen extends StatefulWidget {
  const SmartMatchingScreen({super.key});

  @override
  State<SmartMatchingScreen> createState() => _SmartMatchingScreenState();
}

class _SmartMatchingScreenState extends State<SmartMatchingScreen> {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF1E3A8A);
  static const Color lightBlue = Color(0xFFEFF6FF);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color greenBG = Color(0xFFDCFCE7);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  final List<Map<String, dynamic>> _candidates = [
    {
      'id': '1',
      'name': 'خالد العتيبي',
      'university': 'جامعة العلوم الإسلامية',
      'major': 'هندسة البرمجيات',
      'matchScore': 96,
      'gpa': '3.75 / 4.00',
      'skills': ['Programming', 'Git', 'REST API', 'MySQL'],
      'reason': 'يمتلك 100% من المهارات التقنية المطلوبة',
      'attachments': [
        {
          'type': 'cv',
          'label': 'السيرة الذاتية (CV)',
          'icon': Icons.description_outlined,
          'color': Colors.red,
        },
        {
          'type': 'transcript',
          'label': 'السجل الأكاديمي',
          'icon': Icons.school_outlined,
          'color': primaryBlue,
        },
      ],
    },
    {
      'id': '2',
      'name': 'سارة محمود',
      'university': 'جامعة العلوم الإسلامية',
      'major': 'علوم الحاسوب',
      'matchScore': 89,
      'gpa': '3.60 / 4.00',
      'skills': ['MySQL', 'Web Development', 'Firebase'],
      'reason': 'مطابقة قوية في المسار البرمجي وقريبة جغرافياً',
      'attachments': [
        {
          'type': 'cv',
          'label': 'السيرة الذاتية (CV)',
          'icon': Icons.description_outlined,
          'color': Colors.red,
        },
        {
          'type': 'transcript',
          'label': 'السجل الأكاديمي',
          'icon': Icons.school_outlined,
          'color': primaryBlue,
        },
      ],
    },
    {
      'id': '3',
      'name': 'عمر خالد',
      'university': 'جامعة العلوم الإسلامية',
      'major': 'تكنولوجيا المعلومات',
      'matchScore': 78,
      'skills': ['Networking', 'UI/UX Design', 'Cybersecurity'],
      'reason': 'يمتلك الأساسيات المطلوبة مع خبرة في التصميم',
      'attachments': [
        {
          'type': 'cv',
          'label': 'السيرة الذاتية (CV)',
          'icon': Icons.description_outlined,
          'color': Colors.red,
        },
      ],
    },
  ];

  void _downloadWordDoc(String studentName, String docTypeLabel) {
    final String content =
        'منصة مسار (MASAR) - وثيقة الطالب المرفقة\n'
        '===================================================\n'
        'اسم الطالب: $studentName\n'
        'نوع الوثيقة: $docTypeLabel\n'
        'تاريخ التحميل: ${DateTime.now().toString().split(' ')[0]}\n\n'
        'هذا الملف تم تنزيله تلقائياً من نظام المطابقة الذكية.\n'
        '===================================================';

    final bytes = utf8.encode(content);

    final blob = html.Blob(
      [bytes],
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    );

    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '${studentName}_$docTypeLabel.docx')
      ..click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'جاري تنزيل $docTypeLabel للطالب $studentName بصيغة Word...',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showStudentProfile(Map<String, dynamic> candidate) {
    final bool hasTranscript = (candidate['attachments'] as List).any(
      (attachment) => attachment['type'] == 'transcript',
    );

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560, maxHeight: 700),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: lightBlue,
                          child: Icon(
                            Icons.person_rounded,
                            color: primaryBlue,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            candidate['name'],
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(),
                    const SizedBox(height: 12),

                    _profileInfo(
                      'التخصص',
                      candidate['major'],
                      Icons.school_outlined,
                    ),

                    _profileInfo(
                      'الجامعة',
                      candidate['university'],
                      Icons.account_balance_outlined,
                    ),

                    _profileInfo(
                      'نسبة المطابقة',
                      '${candidate['matchScore']}%',
                      Icons.verified_outlined,
                    ),

                    if (hasTranscript)
                      _profileInfo(
                        'المعدل التراكمي',
                        candidate['gpa'],
                        Icons.grade_outlined,
                      ),

                    const SizedBox(height: 14),

                    const Text(
                      'المهارات',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (candidate['skills'] as List<String>)
                          .map(
                            (skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: primaryBlue,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: primaryBlue,
                            size: 19,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              candidate['reason'],
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'إغلاق',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: primaryBlue,
                            fontWeight: FontWeight.w700,
                          ),
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

  Widget _profileInfo(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: primaryBlue),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(Map<String, dynamic> candidate) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'إرسال دعوة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            content: Text(
              'هل تريد إرسال دعوة تدريب إلى الطالب ${candidate['name']}؟',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: textSecondary,
                height: 1.6,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo', color: textSecondary),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إرسال الدعوة إلى ${candidate['name']} بنجاح',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: successGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 16),
                label: const Text(
                  'إرسال الدعوة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'المطابقة الذكية',
            style: TextStyle(
              fontFamily: 'Cairo',
             fontWeight: FontWeight.bold,
                    color: Color(0xFF17243A),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [darkBlue, primaryBlue],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF4ADE80),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'المطابقة المدعومة بالذكاء الاصطناعي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'يتم تحليل المهارات والمؤهلات لترشيح الكوادر الأكثر ملاءمة لفرصتك.',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  _buildStatCard(
                    'أعلى نسبة مطابقة',
                    '96%',
                    Icons.verified_rounded,
                    successGreen,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'المرشحين المطابقين',
                    '${_candidates.length} طلاب',
                    Icons.groups_rounded,
                    primaryBlue,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'نتائج الترشيح الذكي ',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  return _buildCandidateMatchingCard(_candidates[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateMatchingCard(Map<String, dynamic> candidate) {
    final int score = candidate['matchScore'];

    final List<Map<String, dynamic>> attachments =
        List<Map<String, dynamic>>.from(candidate['attachments']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: lightBlue,
                child: Icon(Icons.person_rounded, color: primaryBlue, size: 24),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate['name'],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${candidate['major']} • ${candidate['university']}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: greenBG,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.task_alt_rounded,
                      size: 16,
                      color: successGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$score% مطابقة',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: primaryBlue,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  candidate['reason'],
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (candidate['skills'] as List<String>)
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryBlue.withOpacity(0.2)),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.attach_file_rounded,
                      size: 16,
                      color: textSecondary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'المرفقات المتاحة (انقر للتنزيل Word):',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: attachments.map((att) {
                    final Color btnColor = att['color'] as Color;

                    return InkWell(
                      onTap: () {
                        _downloadWordDoc(candidate['name'], att['label']);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: btnColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              att['icon'] as IconData,
                              size: 14,
                              color: btnColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              att['label'],
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: btnColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.download_rounded,
                              size: 13,
                              color: textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  _showStudentProfile(candidate);
                },
                icon: const Icon(Icons.person_outline_rounded, size: 16),
                label: const Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textPrimary,
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              ElevatedButton.icon(
                onPressed: () {
                  _showInviteDialog(candidate);
                },
                icon: const Icon(Icons.send_rounded, size: 14),
                label: const Text(
                  'إرسال دعوة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
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
}
