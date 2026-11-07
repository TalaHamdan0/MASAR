import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import '../../../core/widgets/training_bottom_bar.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final TextEditingController notesController = TextEditingController();

  // تقييم الطالب لتجربة التدريب
  final Map<String, double> studentRatings = {
    'جودة التدريب': 0,
    'الاستفادة من التدريب': 0,
    'بيئة العمل': 0,
    'الإشراف والتوجيه': 0,
    'تحقيق أهداف التدريب': 0,
  };

  bool submitted = false;

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  // ============================================================
  // إرسال تقييم الطالب
  // ============================================================

  void _submitEvaluation() {
    final hasEmptyRating =
        studentRatings.values.any((rating) => rating == 0);

    if (hasEmptyRating) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تقييم جميع العناصر قبل إرسال التقييم'),
        ),
      );
      return;
    }

    setState(() {
      submitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال تقييمك بنجاح ✓'),
        backgroundColor: MasarColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقييم'),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _header(context),

                const SizedBox(height: 16),

                _secretSupervisorEvaluation(context),

                const SizedBox(height: 16),

                _studentEvaluation(context),

                const SizedBox(height: 16),

                _evaluationStatus(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const TrainingBottomBar(
        selectedIndex: 3,
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _header(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.assessment_outlined,
                color: MasarColors.primaryBlue,
                size: 28,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تقييم التدريب',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'تابع حالة التقييم وشاركنا تجربتك في التدريب.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // التقييم السري من المشرف
  // ============================================================

  Widget _secretSupervisorEvaluation(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: MasarColors.lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: MasarColors.primaryGreen,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تقييم المشرف الميداني',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'تقييم سري يُرسل مباشرة إلى الجامعة',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // رسالة السرية
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MasarColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.privacy_tip_outlined,
                        color: MasarColors.primaryBlue,
                        size: 22,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          'التقييم سري',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MasarColors.darkBlue,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'يقوم المشرف الميداني بتقييم أدائك وإرسال التقييم مباشرة إلى الدكتور المشرف في الجامعة. لا تظهر تفاصيل أو درجات التقييم للطالب.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // حالة التقييم
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: MasarColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  'بانتظار إرسال تقييم المشرف',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'سيتم تحديث الحالة عند استلام الجامعة للتقييم.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MasarColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // تقييم الطالب لتجربة التدريب
  // ============================================================

  Widget _studentEvaluation(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: MasarColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.rate_review_outlined,
                    color: MasarColors.primaryBlue,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'قيّم تجربة التدريب',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'شاركنا رأيك حول تجربتك التدريبية.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...studentRatings.keys.map(
              (title) => _studentRatingItem(
                context,
                title,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'ملاحظات إضافية',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: notesController,
              enabled: !submitted,
              maxLines: 4,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText:
                    'اكتب ملاحظاتك أو اقتراحاتك حول تجربة التدريب...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: submitted ? null : _submitEvaluation,
                icon: Icon(
                  submitted
                      ? Icons.check_circle_outline
                      : Icons.send_outlined,
                ),
                label: Text(
                  submitted ? 'تم إرسال التقييم' : 'إرسال التقييم',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // تقييم عنصر واحد
  // ============================================================

  Widget _studentRatingItem(
    BuildContext context,
    String title,
  ) {
    final rating = studentRatings[title] ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              ...List.generate(
                5,
                (index) {
                  final starNumber = index + 1;

                  return IconButton(
                    onPressed: submitted
                        ? null
                        : () {
                            setState(() {
                              studentRatings[title] =
                                  starNumber.toDouble();
                            });
                          },
                    icon: Icon(
                      starNumber <= rating
                          ? Icons.star
                          : Icons.star_border,
                      color: starNumber <= rating
                          ? MasarColors.warning
                          : MasarColors.textSecondary,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 38,
                      minHeight: 38,
                    ),
                  );
                },
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  rating == 0
                      ? 'لم يتم التقييم'
                      : '${rating.toStringAsFixed(0)} / 5',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MasarColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // حالة التقييم النهائي
  // ============================================================

  Widget _evaluationStatus(BuildContext context) {
    return Card(
      color: MasarColors.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.hourglass_empty,
                color: MasarColors.primaryBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حالة التقييم النهائي',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'بانتظار استلام واعتماد تقييم المشرف من قبل الجامعة.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.5,
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
}