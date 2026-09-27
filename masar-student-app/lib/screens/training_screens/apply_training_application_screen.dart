import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'application_success_screen.dart';

class ApplyTrainingApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const ApplyTrainingApplicationScreen({
    super.key,
    required this.company,
  });

  @override
  State<ApplyTrainingApplicationScreen> createState() =>
      _ApplyTrainingApplicationScreenState();
}

class _ApplyTrainingApplicationScreenState
    extends State<ApplyTrainingApplicationScreen> {
  String? cvFileName;
  String? additionalFileName;

  // ============================================================
  // بيانات الطالب - لاحقًا تأتي من Student Account / API
  // ============================================================

  final String studentName = 'شهد أحمد';
  final String university = 'جامعة العلوم والتكنولوجيا الأردنية';
  final String major = 'علوم الحاسوب';
  final String email = 'shahd@example.com';
  final String phone = '+962 7 9123 4567';

  // المسار يأتي من فرصة التدريب التي اختارها الطالب
  final String trainingPath = 'تحليل البيانات';

  // ============================================================
  // متطلبات الشركة
  // لاحقًا هذه القيم تأتي من بيانات فرصة التدريب
  //
  // true  = الشركة تطلب المستند
  // false = الشركة لا تطلبه
  // ============================================================

  final bool requiresAcademicRecord = true;
  final bool requiresCV = true;
  final bool requiresAdditionalDocument = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 390,
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSteps(),
                          const SizedBox(height: 28),
                          _buildCompanyCard(),
                          const SizedBox(height: 28),
                          _buildStudentInformation(),
                          const SizedBox(height: 28),
                          _buildApplicationRequirements(),
                          const SizedBox(height: 28),
                          _buildNoteBox(),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
                          const SizedBox(height: 32),
                        ],
                      ),
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

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: MasarColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: MasarColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'تقديم طلب التدريب',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MasarColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Steps
  // ============================================================

  Widget _buildSteps() {
    return Row(
      children: [
        _buildStep(
          number: '1',
          title: 'تقديم الطلب',
          active: true,
        ),
        Expanded(
          child: Container(
            height: 2,
            color: MasarColors.border,
          ),
        ),
        _buildStep(
          number: '2',
          title: 'المراجعة',
          active: false,
        ),
        Expanded(
          child: Container(
            height: 2,
            color: MasarColors.border,
          ),
        ),
        _buildStep(
          number: '3',
          title: 'تم الإرسال',
          active: false,
        ),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required bool active,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? MasarColors.primaryBlue
                : MasarColors.lightBlue,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : MasarColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight:
                active ? FontWeight.bold : FontWeight.normal,
            color: active
                ? MasarColors.primaryBlue
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Company Card
  // ============================================================

  Widget _buildCompanyCard() {
    final String companyName =
        widget.company['name']?.toString() ?? 'اسم الشركة';

    final String slogan =
        widget.company['slogan']?.toString() ?? 'فرصة تدريبية';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.business_rounded,
              color: MasarColors.primaryBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  slogan,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Student Information
  // ============================================================

  Widget _buildStudentInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات الطالب',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MasarColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سيتم تعبئة معلوماتك تلقائيًا من حسابك.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 18),

        _buildInfoField(
          label: 'الاسم الكامل',
          value: studentName,
          icon: Icons.person_outline,
        ),

        const SizedBox(height: 12),

        _buildInfoField(
          label: 'الجامعة',
          value: university,
          icon: Icons.school_outlined,
        ),

        const SizedBox(height: 12),

        _buildInfoField(
          label: 'التخصص',
          value: major,
          icon: Icons.menu_book_outlined,
        ),

        const SizedBox(height: 12),

        _buildInfoField(
          label: 'المسار التدريبي',
          value: trainingPath,
          icon: Icons.route_outlined,
          highlighted: true,
        ),

        const SizedBox(height: 12),

        _buildInfoField(
          label: 'البريد الإلكتروني',
          value: email,
          icon: Icons.email_outlined,
        ),

        const SizedBox(height: 12),

        _buildInfoField(
          label: 'رقم الهاتف',
          value: phone,
          icon: Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
    bool highlighted = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted
            ? MasarColors.lightGreen
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? MasarColors.primaryGreen
              : MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: highlighted
                ? MasarColors.primaryGreen
                : MasarColors.primaryBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: MasarColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Application Requirements
  // ============================================================

  Widget _buildApplicationRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'متطلبات التقديم',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MasarColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'المستندات المطلوبة يتم تحديدها من قبل الشركة.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 18),

        if (requiresAcademicRecord)
          _buildAcademicRecord(),

        if (requiresAcademicRecord && requiresCV)
          const SizedBox(height: 14),

        if (requiresCV)
          _buildFileUpload(
            title: 'السيرة الذاتية (CV)',
            subtitle: 'يرجى رفع السيرة الذاتية بصيغة PDF',
            fileName: cvFileName,
            icon: Icons.description_outlined,
            onTap: _pickCV,
          ),

        if (requiresCV && requiresAdditionalDocument)
          const SizedBox(height: 14),

        if (requiresAdditionalDocument)
          _buildFileUpload(
            title: 'المستند الإضافي',
            subtitle: 'يرجى رفع المستند المطلوب بصيغة PDF',
            fileName: additionalFileName,
            icon: Icons.attach_file_rounded,
            onTap: _pickAdditionalDocument,
          ),
      ],
    );
  }

  // ============================================================
  // Academic Record
  // ============================================================

  Widget _buildAcademicRecord() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MasarColors.lightGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.primaryGreen,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.school_outlined,
              color: MasarColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السجل الأكاديمي',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'يتم إنشاء السجل الأكاديمي تلقائيًا من بياناتك الأكاديمية.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 17,
                      color: MasarColors.primaryGreen,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'جاهز للإرفاق',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // File Upload
  // ============================================================

  Widget _buildFileUpload({
    required String title,
    required String subtitle,
    required String? fileName,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool uploaded = fileName != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: uploaded
                ? MasarColors.primaryGreen
                : MasarColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: uploaded
                    ? MasarColors.lightGreen
                    : MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                uploaded
                    ? Icons.check_circle_outline
                    : icon,
                color: uploaded
                    ? MasarColors.primaryGreen
                    : MasarColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    uploaded ? fileName : subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: uploaded
                          ? MasarColors.primaryGreen
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              uploaded
                  ? Icons.check_circle
                  : Icons.upload_file_outlined,
              color: uploaded
                  ? MasarColors.primaryGreen
                  : MasarColors.primaryBlue,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Note
  // ============================================================

  Widget _buildNoteBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: MasarColors.primaryBlue,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'بعد إرسال الطلب، ستقوم الشركة بمراجعته والتواصل معك عند قبولك في فرصة التدريب.',
              style: TextStyle(
                fontSize: 12,
                height: 1.6,
                color: MasarColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Submit Button
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: MasarColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'إرسال طلب التدريب',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Pick CV
  // ============================================================

  void _pickCV() {
    setState(() {
      cvFileName = 'CV_Shahd_Ahmed.pdf';
    });
  }

  // ============================================================
  // Pick Additional Document
  // ============================================================

  void _pickAdditionalDocument() {
    setState(() {
      additionalFileName = 'Additional_Document.pdf';
    });
  }

  // ============================================================
  // Submit Application
  // ============================================================

  void _submitApplication() {
    if (requiresCV && cvFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'يرجى رفع السيرة الذاتية قبل إرسال الطلب.',
          ),
          backgroundColor: MasarColors.primaryBlue,
        ),
      );
      return;
    }

    if (requiresAdditionalDocument &&
        additionalFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'يرجى رفع المستند الإضافي قبل إرسال الطلب.',
          ),
          backgroundColor: MasarColors.primaryBlue,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationSuccessScreen(
          company: widget.company,
        ),
      ),
    );
  }
}