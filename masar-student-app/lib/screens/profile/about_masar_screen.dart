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
                  'مسار هو منصة رقمية تساعد طلبة الجامعة على بناء وتطوير مسارهم الأكاديمي والمهني من خلال ربط مهاراتهم وتخصصهم بمتطلبات سوق العمل وفرص التدريب.',
            ),

            const _AboutSection(
              title: 'ماذا يقدم مسار؟',
              text:
                  'يوفر مسار مجموعة من الخدمات التي تساعد الطالب على تقييم مهاراته، استكشاف المسارات المهنية، تحديد المهارات التي تحتاج إلى تطوير، بناء خطة تطوير شخصية، والوصول إلى فرص التدريب المناسبة.',
            ),

            const _AboutSection(
              title: 'هدفنا',
              text:
                  'مساعدة الطالب على الانتقال من المرحلة الأكاديمية إلى الحياة المهنية بطريقة أوضح وأكثر تنظيمًا.',
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