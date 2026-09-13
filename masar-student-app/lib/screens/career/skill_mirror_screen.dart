
import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'skill_details_screen.dart';
import 'skill_gap_screen.dart';

class SkillMirrorScreen extends StatefulWidget {
  const SkillMirrorScreen({super.key});

  @override
  State<SkillMirrorScreen> createState() => _SkillMirrorScreenState();
}

class _SkillMirrorScreenState extends State<SkillMirrorScreen> {
  late CareerPath selectedCareerPath;

  @override
  void initState() {
    super.initState();
    selectedCareerPath = MasarMockData.selectedCareerPath;
  }

  @override
  Widget build(BuildContext context) {
    final List<Skill> technicalSkills = MasarMockData.skills
        .where(
          (skill) =>
              selectedCareerPath.requiredSkills.contains(skill.name),
        )
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,

        // ============================================================
        // APP BAR
        // ============================================================

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Column(
            children: [
              Text(
                'مرآة المهارات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'افهم أين تقف',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  color: MasarColors.textSecondary,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),

        // ============================================================
        // BODY
        // ============================================================

        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ======================================================
                // CAREER PATH
                // ======================================================

                const Text(
                  'المسار المهني',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                _buildCareerDropdown(),

                const SizedBox(height: 30),

                // ======================================================
                // YOUR SKILLS
                // ======================================================

                const Text(
                  'مهاراتك',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'مهاراتك التقنية الحالية لهذا المسار المهني.',
                  style: TextStyle(
                    fontSize: 13,
                    color: MasarColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                if (technicalSkills.isEmpty)
                  _buildEmptyState()
                else
                  ...technicalSkills.map(
                    (skill) => _buildSkillCard(skill),
                  ),

                const SizedBox(height: 22),

                // ======================================================
                // SKILL GAP
                // ======================================================

                _buildSkillGapButton(),

                const SizedBox(height: 30),

                // ======================================================
                // SOFT SKILLS
                // ======================================================

                const Text(
                  'المهارات الشخصية',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'مهاراتك الحالية في التواصل والعمل والجانب المهني.',
                  style: TextStyle(
                    fontSize: 13,
                    color: MasarColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                ...MasarMockData.softSkills.map(
                  (skill) => _buildSoftSkillCard(skill),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // CAREER PATH DROPDOWN
  // ===============================================================

  Widget _buildCareerDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CareerPath>(
          value: selectedCareerPath,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: MasarColors.primaryBlue,
          ),
          items: MasarMockData.careerPaths.map(
            (CareerPath path) {
              return DropdownMenuItem<CareerPath>(
                value: path,
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        color: MasarColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      path.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          onChanged: (CareerPath? path) {
            if (path == null) return;

            setState(() {
              selectedCareerPath = path;
            });
          },
        ),
      ),
    );
  }

  // ===============================================================
  // TECHNICAL SKILL CARD
  // ===============================================================

  Widget _buildSkillCard(Skill skill) {
    final bool isGood = skill.level >= 50;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SkillDetailsScreen(
                skill: skill,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: MasarColors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getSkillIcon(skill.name),
                      color: MasarColors.primaryBlue,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 12),

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

                  Text(
                    '${skill.level}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.primaryBlue,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons.chevron_left_rounded,
                    color: MasarColors.textSecondary,
                    size: 22,
                  ),
                ],
              ),

              const SizedBox(height: 13),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: skill.level / 100,
                  minHeight: 8,
                  backgroundColor: MasarColors.lightBlue,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isGood
                        ? MasarColors.primaryGreen
                        : MasarColors.warning,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _getSkillStatusArabic(skill.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isGood
                        ? MasarColors.primaryGreen
                        : MasarColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // SKILL GAP BUTTON
  // ===============================================================

  Widget _buildSkillGapButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SkillGapScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: MasarColors.lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: MasarColors.primaryBlue.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: MasarColors.primaryBlue,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تحليل فجوة المهارات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'شاهد المهارات التي تحتاج إلى تطوير',
                    style: TextStyle(
                      fontSize: 12,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_left_rounded,
              color: MasarColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // SOFT SKILL CARD
  // ===============================================================

  Widget _buildSoftSkillCard(SoftSkill skill) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
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
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: MasarColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getSoftSkillIcon(skill.name),
                  color: MasarColors.primaryGreen,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

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

              Text(
                '${skill.level}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: skill.level / 100,
              minHeight: 8,
              backgroundColor: MasarColors.lightGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(
                MasarColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // EMPTY STATE
  // ===============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 40,
            color: MasarColors.textSecondary,
          ),
          SizedBox(height: 10),
          Text(
            'لا توجد مهارات متاحة لهذا المسار المهني حاليًا.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // SKILL STATUS
  // ===============================================================

  String _getSkillStatusArabic(String status) {
    switch (status) {
      case 'Strong':
        return 'قوي';

      case 'Needs Improvement':
        return 'بحاجة إلى تطوير';

      case 'Beginner':
        return 'مبتدئ';

      default:
        return status;
    }
  }

  // ===============================================================
  // TECHNICAL SKILL ICONS
  // ===============================================================

  IconData _getSkillIcon(String skillName) {
    switch (skillName) {
      case 'Python':
        return Icons.code;

      case 'Excel':
        return Icons.table_chart_outlined;

      case 'SQL':
        return Icons.storage_outlined;

      case 'Power BI':
        return Icons.bar_chart_outlined;

      case 'الإحصاء':
        return Icons.analytics_outlined;

      case 'Machine Learning':
        return Icons.psychology_outlined;

      case 'Deep Learning':
        return Icons.memory_outlined;

      case 'Data Visualization':
        return Icons.insert_chart_outlined;

      case 'Git':
        return Icons.source_outlined;

      case 'APIs':
        return Icons.api_outlined;

      default:
        return Icons.school_outlined;
    }
  }

  // ===============================================================
  // SOFT SKILL ICONS
  // ===============================================================

  IconData _getSoftSkillIcon(String skillName) {
    switch (skillName) {
      case 'Communication':
        return Icons.forum_outlined;

      case 'Teamwork':
        return Icons.groups_outlined;

      case 'Problem Solving':
        return Icons.lightbulb_outline;

      case 'Time Management':
        return Icons.schedule_outlined;

      case 'Leadership':
        return Icons.leaderboard_outlined;

      default:
        return Icons.person_outline;
    }
  }
}

