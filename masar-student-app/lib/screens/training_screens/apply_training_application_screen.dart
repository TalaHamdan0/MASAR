import 'package:flutter/material.dart';

import '../../../core/models/student_model.dart';
import '../../../theme/masar_theme.dart';
<<<<<<< HEAD
import '../../core/services/training_service.dart';
=======
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class ApplyTrainingApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> company;
  final Student? student;
  final List<String>? requiredDocuments;

  const ApplyTrainingApplicationScreen({
    super.key,
    required this.company,
    this.student,
    this.requiredDocuments,
  });

  @override
  State<ApplyTrainingApplicationScreen> createState() =>
      _ApplyTrainingApplicationScreenState();
}

class _ApplyTrainingApplicationScreenState
    extends State<ApplyTrainingApplicationScreen> {
<<<<<<< HEAD
  bool _isLoading = false;

=======
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'غير متوفر حاليًا';
    }
<<<<<<< HEAD
=======

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    return value.trim();
  }

  String _companyValue(String key) {
    final value = widget.company[key];
<<<<<<< HEAD
    if (value == null || value.toString().trim().isEmpty) {
      return 'غير متوفر حاليًا';
    }
    return value.toString().trim();
  }

  // دالة إرسال الطلب الآمنة (تعتمد على opportunityId فقط)
  Future<void> _submitApplication() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // استخراج رقم الفرصة التدريبية مع التحويل الآمن
      final rawOfferId =
          widget.company['offer_id'] ??
          widget.company['opportunity_id'] ??
          widget.company['id'];

      final int opportunityId = rawOfferId is int
          ? rawOfferId
          : int.tryParse(rawOfferId?.toString() ?? '0') ?? 0;

      if (opportunityId <= 0) {
        throw Exception('معلومات فرصة التدريب غير صالحة.');
      }

      // استدعاء خدمة التقديم بالشكل الجديد المتوافق مع الـ Token
      await TrainingService.applyForTraining(opportunityId: opportunityId);

      if (!mounted) return;

      // إظهار رسالة نجاح وإغلاق الشاشة بسلاسة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تقديم طلب التدريب بنجاح!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      final errorMessage = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceAll('ApiException: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

=======

    if (value == null || value.toString().trim().isEmpty) {
      return 'غير متوفر حاليًا';
    }

    return value.toString().trim();
  }

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
<<<<<<< HEAD
              constraints: const BoxConstraints(maxWidth: 390),
=======
              constraints: const BoxConstraints(
                maxWidth: 390,
              ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
<<<<<<< HEAD
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: MasarColors.border)),
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: MasarColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'تقديم طلب التدريب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MasarColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return Row(
      children: [
<<<<<<< HEAD
        _buildStep(number: '1', title: 'تقديم الطلب', active: true),
        Expanded(child: Container(height: 2, color: MasarColors.border)),
        _buildStep(number: '2', title: 'المراجعة', active: false),
        Expanded(child: Container(height: 2, color: MasarColors.border)),
        _buildStep(number: '3', title: 'تم الإرسال', active: false),
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
<<<<<<< HEAD
            color: active ? MasarColors.primaryBlue : MasarColors.lightBlue,
=======
            color: active
                ? MasarColors.primaryBlue
                : MasarColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          child: Text(
            number,
            style: TextStyle(
<<<<<<< HEAD
              color: active ? Colors.white : MasarColors.primaryBlue,
=======
              color: active
                  ? Colors.white
                  : MasarColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
<<<<<<< HEAD
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? MasarColors.primaryBlue : Colors.grey.shade600,
=======
            fontWeight:
                active ? FontWeight.bold : FontWeight.normal,
            color: active
                ? MasarColors.primaryBlue
                : Colors.grey.shade600,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
<<<<<<< HEAD
        border: Border.all(color: MasarColors.border),
=======
        border: Border.all(
          color: MasarColors.border,
        ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
            child: const Icon(
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
                  _companyValue('name'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _companyValue('slogan'),
<<<<<<< HEAD
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
=======
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentInformation() {
    final student = widget.student;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معلومات الطالب',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MasarColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'تظهر هنا المعلومات المرتبطة بحسابك.',
<<<<<<< HEAD
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
=======
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ),
        const SizedBox(height: 18),
        _buildInfoField(
          label: 'الاسم الكامل',
          value: _displayValue(student?.name),
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _buildInfoField(
          label: 'الجامعة',
          value: _displayValue(student?.university),
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 12),
        _buildInfoField(
          label: 'التخصص',
          value: _displayValue(student?.major),
          icon: Icons.menu_book_outlined,
        ),
        const SizedBox(height: 12),
        _buildInfoField(
          label: 'المسار التدريبي',
          value: _companyValue('trainingPath'),
          icon: Icons.route_outlined,
          highlighted: true,
        ),
        const SizedBox(height: 12),
        _buildInfoField(
          label: 'البريد الإلكتروني',
          value: _displayValue(student?.email),
          icon: Icons.email_outlined,
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
<<<<<<< HEAD
        color: highlighted ? MasarColors.lightGreen : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted ? MasarColors.primaryGreen : MasarColors.border,
=======
        color: highlighted
            ? MasarColors.lightGreen
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? MasarColors.primaryGreen
              : MasarColors.border,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
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
<<<<<<< HEAD
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
=======
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

  Widget _buildApplicationRequirements() {
    final documents = widget.requiredDocuments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المستندات المطلوبة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MasarColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'تحدد الشركة المستندات المطلوبة لكل فرصة تدريب.',
<<<<<<< HEAD
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
=======
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ),
        const SizedBox(height: 18),
        if (documents == null)
          _buildDocumentCard(
            title: 'المستندات المطلوبة',
            subtitle: 'لم يتم تحميل متطلبات هذه الفرصة بعد.',
            icon: Icons.description_outlined,
          )
        else if (documents.isEmpty)
          _buildDocumentCard(
            title: 'المستندات المطلوبة',
            subtitle: 'لا توجد مستندات مطلوبة لهذه الفرصة.',
            icon: Icons.description_outlined,
          )
        else
          ...documents.map(
            (document) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDocumentCard(
                title: document,
                subtitle: 'سيتم تجهيز المستند عند ربط الخدمة.',
                icon: Icons.description_outlined,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
        border: Border.all(color: MasarColors.border),
=======
        border: Border.all(
          color: MasarColors.border,
        ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
<<<<<<< HEAD
            child: Icon(icon, color: MasarColors.primaryBlue),
=======
            child: Icon(
              icon,
              color: MasarColors.primaryBlue,
            ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: MasarColors.primaryBlue,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'راجِع معلوماتك والمستندات المطلوبة قبل إرسال طلب التدريب.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
<<<<<<< HEAD
        onPressed: _isLoading ? null : _submitApplication,
=======
        onPressed: null,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        style: ElevatedButton.styleFrom(
          backgroundColor: MasarColors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
<<<<<<< HEAD
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'إرسال طلب التدريب',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
=======
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
}
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
