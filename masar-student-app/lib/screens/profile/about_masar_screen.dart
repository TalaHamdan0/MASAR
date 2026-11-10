import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class AboutMasarScreen extends StatelessWidget {
  const AboutMasarScreen({super.key});

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
        title: const Text('عن مسار'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: MasarColors.lightBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.route,
                      size: 50,
                      color: MasarColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'MASAR',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.darkBlue,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    'Your Academic & Career Path',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const _AboutSection(
              title: 'ما هو مسار؟',
              text:
                  'مسار هو مشروع تخرج يهدف إلى دعم طلبة جامعة العلوم الإسلامية العالمية في تطوير مسارهم المهني وتنظيم التدريب الميداني، من خلال ربط الطالب والشركات والجامعة في منصة واحدة.',
            ),
            const _AboutSection(
              title: 'ماذا يقدم مسار؟',
              text:
                  'يساعد مسار الطالب على إنشاء ملف مهني وسيرة ذاتية، واختيار مسار مهني في مجال تكنولوجيا المعلومات، ومقارنة المهارات الموثّقة في ملفه بمتطلبات المسار، والاطلاع على خارطة طريق لتطوير مهاراته.',
            ),
            const _AboutSection(
              title: 'التدريب الميداني',
              text:
                  'يتيح مسار للطالب تصفّح فرص التدريب التي تنشرها الشركات والتقديم عليها ومتابعة طلباته. كما يهدف إلى اقتراح فرص مرتبطة بالمسار المهني المختار، ومتابعة ساعات التدريب والتقارير والتقييمات.',
            ),
            const _AboutSection(
              title: 'هدفنا',
              text:
                  'مساعدة الطالب على الربط بين تطوير مهاراته والتدريب الميداني، والاستعداد للانتقال من المرحلة الأكاديمية إلى الحياة المهنية.',
            ),
            const SizedBox(height: 25),
            const Center(
              child: Text(
                'الإصدار 1.0.0',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: MasarColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final String text;

  const _AboutSection({
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.8,
                ),
          ),
        ],
      ),
    );
  }
}