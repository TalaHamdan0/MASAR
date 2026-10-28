import 'package:flutter/material.dart';

import 'package:masar_student_app/core/services/profile_analysis.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

import 'roadmap_screen.dart';

class CareerReadinessScreen extends StatelessWidget {
  final int? readinessScore;
  final Map<String, int>? skillScores;

  const CareerReadinessScreen({
    super.key,
    this.readinessScore,
    this.skillScores,
  });

  ProfileAnalysis get _analysis {
    return ProfileAnalysis.fromProfile(
      MasarMockData.currentStudent,
      MasarMockData.getCareerPathById(
        MasarMockData.currentStudent?.careerPathId ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysis = _analysis;

    if (!analysis.canAnalyze) {
      return _MobilePage(
        child: Scaffold(
          backgroundColor: MasarColors.background,
          appBar: AppBar(
            title: const Text('الجاهزية المهنية'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                analysis.unavailableReason ??
                    'لا تتوفر بيانات كافية لتحليل الملف.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          bottomNavigationBar: const AppBottomNavBar(
            selectedIndex: 0,
          ),
        ),
      );
    }

    final path = analysis.path;
    final skills = analysis.requiredSkills;
    final documented = skills
        .where((skill) => analysis.covers(skill))
        .toList();
    final undocumented = skills
        .where((skill) => !analysis.covers(skill))
        .toList();

    return _MobilePage(
      child: Scaffold(
        backgroundColor: MasarColors.background,
        appBar: AppBar(
          backgroundColor: MasarColors.background,
          elevation: 0,
          title: const Text(
            'الجاهزية المهنية',
            style: TextStyle(
              color: MasarColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildOverallProgress(
                score: analysis.coverageScore!,
                documentedCount: documented.length,
                totalCount: skills.length,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'فجوة المهارات',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'مقارنة ملفك بمتطلبات ${path?.title ?? 'المسار المختار'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...skills.map(
                (skill) => _buildSkillCard(
                  skill,
                  analysis.covers(skill),
                ),
              ),
              const SizedBox(height: 24),
              _buildSummary(undocumented),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RoadmapScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('عرض خارطة الطريق'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MasarColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 0,
        ),
      ),
    );
  }

  Widget _buildOverallProgress({
    required int score,
    required int documentedCount,
    required int totalCount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'تغطية متطلبات المسار',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: MasarColors.background,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      MasarColors.primaryBlue,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'تغطية الملف',
                      style: TextStyle(
                        fontSize: 12,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '$documentedCount من أصل $totalCount مهارات موثّقة',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: MasarColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'تعتمد النتيجة على المهارات وتقنيات المشاريع المسجّلة في ملفك، ولا تقيس مستوى إتقانك. لا تُحتسب الشهادات حتى تُربط بمهارات محددة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(
    String skill,
    bool documented,
  ) {
    final color = documented
        ? MasarColors.primaryGreen
        : MasarColors.warning;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              skill,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            documented
                ? Icons.check_circle
                : Icons.info_outline,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              documented
                  ? 'موثّقة في الملف'
                  : 'غير موثّقة في الملف',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<String> undocumented) {
    if (undocumented.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: MasarColors.lightGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: MasarColors.primaryGreen,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'جميع مهارات المسار المحددة موثّقة في ملفك. توثيقها لا يثبت إتقانها.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المهارات غير الموثّقة في الملف',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك إضافتها لملفك إذا كنت تعرفها، أو العمل على تعلمها.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ...undocumented.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 12,
                    color: MasarColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePage extends StatelessWidget {
  final Widget child;

  const _MobilePage({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: MasarColors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: SizedBox(
              width: double.infinity,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}