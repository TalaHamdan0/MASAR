import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  // لاحقًا هذه القيمة ستأتي من الـ Backend
  bool hasCompanyEvaluation = false;

  bool isCompanyEvaluationExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقييمات')),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _companyEvaluation(),

                const SizedBox(height: 12),

                _secretEvaluation(),

                if (isCompanyEvaluationExpanded) ...[
                  const SizedBox(height: 12),
                  _companyEvaluationContent(),
                ],
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const AppBottomNavBar(selectedIndex: 1),
    );
  }

  // تقييم الشركة
  Widget _companyEvaluation() {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            isCompanyEvaluationExpanded = !isCompanyEvaluationExpanded;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: MasarColors.primaryBlue,
                  size: 27,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تقييم الشركة',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'تقييم المشرف في الشركة',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              Icon(
                isCompanyEvaluationExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: MasarColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // التقييم السري
  Widget _secretEvaluation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: MasarColors.primaryBlue,
                size: 27,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقييم السري',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'تقييم سري من مشرف الشركة',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const Icon(Icons.lock, color: MasarColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  // المحتوى الذي يظهر عند الضغط على تقييم الشركة
  Widget _companyEvaluationContent() {
    // إذا المشرف لم يقيّم بعد
    if (!hasCompanyEvaluation) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.hourglass_empty,
                color: MasarColors.warning,
                size: 38,
              ),

              const SizedBox(height: 10),

              Text(
                'لسا ما تم التقييم من قبل المشرف.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    // إذا المشرف قيّم
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل تقييم الشركة',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 18),

            _ratingRow('الالتزام والانضباط', 4.5),

            _ratingRow('جودة العمل', 4.0),

            _ratingRow('التواصل', 4.5),

            _ratingRow('العمل ضمن الفريق', 4.0),

            _ratingRow('المبادرة والتعلم', 4.5),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: MasarColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملاحظات المشرف',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'ملاحظات المشرف ستظهر هنا.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingRow(String title, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Text(
              rating.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: MasarColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: rating / 5,
                minHeight: 8,
                backgroundColor: MasarColors.border,
                color: MasarColors.primaryBlue,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
