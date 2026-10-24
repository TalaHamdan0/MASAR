import 'package:flutter/material.dart';

import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/services/profile_analysis.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

import 'roadmap_screen.dart';

class CareerReadinessScreen extends StatelessWidget {
  // للتوافق مع الاستدعاءات القديمة فقط.
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
    final selectedCareerPath = analysis.path;

    final skills = analysis.requiredSkills.map((name) {
      return Skill(
        id: ProfileAnalysis.normalize(name),
        name: name,
        level: analysis.covers(name) ? 100 : 0,
        status: analysis.covers(name)
            ? 'مسجّلة'
            : 'غير موثّقة',
      );
    }).toList();

    if (!analysis.canAnalyze) {
      return _MobilePage(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: MasarColors.background,
          appBar: AppBar(
            title: const Text('الجاهزية المهنية'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                analysis.unavailableReason!,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return _MobilePage(
      textDirection: TextDirection.rtl,
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
                analysis.coverageScore!,
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
                      'مقارنة ملفك بمتطلبات '
                      '${selectedCareerPath!.title}',
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
                (skill) => _buildSkillGapCard(skill),
              ),

              const SizedBox(height: 24),
              _buildImprovementSummary(skills),
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
                  label: const Text(
                    'عرض خارطة الطريق التجريبية',
                  ),
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MasarColors.primaryBlue,
          unselectedItemColor: MasarColors.textSecondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'خارطة الطريق',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'الفرص',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge_outlined),
              activeIcon: Icon(Icons.badge),
              label: 'الملف المهني',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress(int score) {
    String title;

    if (score >= 80) {
      title = 'تغطية مرتفعة للملف';
    } else if (score >= 60) {
      title = 'تغطية جزئية للملف';
    } else {
      title = 'مهارات تحتاج إلى توثيق';
    }

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
                    value: 1,
                    strokeWidth: 12,
                    backgroundColor: MasarColors.background,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      MasarColors.background,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.transparent,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
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
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: MasarColors.primaryGreen,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'يعتمد المؤشر على المهارات وتقنيات المشاريع المسجّلة، '
            'وليس قياسًا للإتقان. '
            'لا تُحتسب الشهادات حتى تُربط بمهارات محددة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillGapCard(Skill skill) {
    final covered = _analysis.covers(skill.name);

    // تعبئة شريط التوثيق فقط، وليست نسبة إتقان.
    final currentLevel = covered ? 100 : 0;

    final status = covered
        ? 'مسجّلة في الملف'
        : 'غير موثّقة في الملف';

    final statusColor = covered
        ? MasarColors.primaryGreen
        : MasarColors.warning;

    final icon = covered
        ? Icons.check_circle
        : Icons.info_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 18,
                color: statusColor,
              ),
              const SizedBox(width: 5),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حالة التوثيق',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      covered ? 'مسجّلة' : 'غير موثّقة',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ضمن متطلبات المسار',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'نعم',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الفجوة',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      covered
                          ? 'مغطاة بالملف'
                          : 'تحتاج توثيقًا',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: currentLevel / 100,
              minHeight: 7,
              backgroundColor: MasarColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(
                statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementSummary(List<Skill> skills) {
    final skillsToImprove = skills.where((skill) {
      return !_analysis.covers(skill.name);
    }).toList();

    if (skillsToImprove.isEmpty) {
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
                'جميع متطلبات المسار مسجّلة في ملفك. '
                'هذا لا يثبت إتقانها.',
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

          const SizedBox(height: 10),

          ...skillsToImprove.map(
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
                  Text(
                    skill.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: MasarColors.textPrimary,
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

// يقيّد الصفحة كاملة، بما فيها الشريط العلوي والسفلي، بعرض موبايل.
class _MobilePage extends StatelessWidget {
  final TextDirection textDirection;
  final Widget child;

  const _MobilePage({
    required this.textDirection,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
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