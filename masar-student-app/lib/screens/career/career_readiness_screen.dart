import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'roadmap_screen.dart';

class CareerReadinessScreen extends StatelessWidget {
  const CareerReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int overallScore = MasarMockData.readinessScore;
    final selectedCareerPath = MasarMockData.selectedCareerPath;

    final List<Skill> skills = MasarMockData.skills
        .where(
          (skill) => selectedCareerPath.requiredSkills.contains(skill.name),
        )
        .toList();

    return Directionality(
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
              _buildOverallProgress(overallScore),

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
                      'مقارنة مهاراتك الحالية بمتطلبات ${selectedCareerPath.title}',
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
                    'عرض خارطة الطريق',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MasarColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
      title = 'جاهزية قوية';
    } else if (score >= 60) {
      title = 'جاهزية جيدة';
    } else {
      title = 'تحتاج إلى تطوير';
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
            'درجة الجاهزية',
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
                    valueColor: const AlwaysStoppedAnimation<Color>(
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
                      'الجاهزية',
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

          Text(
            score >= 80
                ? 'مستواك قريب من متطلبات المسار المهني.'
                : 'استمر في تطوير مهاراتك للوصول إلى المستوى المطلوب.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillGapCard(Skill skill) {
    const int requiredLevel = 70;

    final int currentLevel = skill.level;
    final int gap = requiredLevel - currentLevel;

    late String status;
    late Color statusColor;
    late IconData icon;

    if (currentLevel >= requiredLevel) {
      status = 'محقق';
      statusColor = MasarColors.primaryGreen;
      icon = Icons.check_circle;
    } else if (currentLevel >= 50) {
      status = 'قريب';
      statusColor = MasarColors.warning;
      icon = Icons.trending_up;
    } else {
      status = 'يحتاج تطوير';
      statusColor = MasarColors.error;
      icon = Icons.warning_amber_rounded;
    }

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
                      'مستواك الحالي',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currentLevel%',
                      style: const TextStyle(
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
                      'المستوى المطلوب',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '70%',
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
                      gap > 0 ? '$gap%' : 'مكتمل',
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
    final skillsToImprove = skills
        .where((skill) => skill.level < 70)
        .toList();

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
                'ممتاز! جميع المهارات الأساسية تحقق المستوى المطلوب.',
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
            'المهارات التي تحتاج إلى تطوير',
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