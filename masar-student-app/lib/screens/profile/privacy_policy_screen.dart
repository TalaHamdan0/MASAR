import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_right,
            size: 30,
            color: MasarColors.darkBlue,
          ),
        ),
        title: const Text('سياسة الخصوصية'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _PrivacySection(
            title: '1. البيانات التي يتم جمعها',
            text:
                'قد يقوم تطبيق مسار بتخزين البيانات التي يقدمها الطالب عند إنشاء الحساب واستخدام التطبيق، مثل الاسم، الرقم الجامعي، البريد الجامعي، الجامعة، التخصص، السنة الدراسية، المهارات، الشهادات، وبيانات الملف المهني وطلبات التدريب.',
          ),

          _PrivacySection(
            title: '2. استخدام البيانات',
            text:
                'تُستخدم بيانات الطالب لتوفير وظائف التطبيق، مثل إنشاء الملف المهني، تقييم المهارات، تقديم التوصيات المرتبطة بالمسار المهني، عرض فرص التدريب، ومتابعة رحلة التدريب.',
          ),

          _PrivacySection(
            title: '3. مشاركة البيانات',
            text:
                'قد يتم عرض بعض بيانات الملف المهني للشركات ضمن الوظائف التي يوفرها التطبيق، وفقًا لإعدادات الخصوصية التي يحددها الطالب.',
          ),

          _PrivacySection(
            title: '4. حماية البيانات',
            text:
                'يعمل التطبيق على حماية بيانات المستخدم ومنع الوصول غير المصرح به إليها باستخدام آليات الحماية المناسبة التي يوفرها النظام.',
          ),

          _PrivacySection(
            title: '5. حقوق المستخدم',
            text:
                'يمكن للمستخدم مراجعة بياناته وتعديل المعلومات التي يسمح التطبيق بتعديلها وفقًا لصلاحيات النظام.',
          ),

          SizedBox(height: 10),

          Text(
            'آخر تحديث: سبتمبر 2026',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final String text;

  const _PrivacySection({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: MasarColors.textSecondary,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}