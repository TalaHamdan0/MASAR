import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'career_readiness_screen.dart';

class SkillMirrorScreen extends StatefulWidget {
  const SkillMirrorScreen({super.key});

  @override
  State<SkillMirrorScreen> createState() => _SkillMirrorScreenState();
}

class _SkillMirrorScreenState extends State<SkillMirrorScreen> {
  late CareerPath selectedCareerPath;
  Skill? selectedSkill;

  @override
  void initState() {
    super.initState();
    selectedCareerPath = MasarMockData.selectedCareerPath;
  }

  @override
  Widget build(BuildContext context) {
    final technicalSkills = MasarMockData.skills
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
          centerTitle: false,
          title: const Text(
            'مرآة المهارات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'افهم مستواك الحالي وطوّر مهاراتك للوصول إلى هدفك المهني',
                style: TextStyle(
                  fontSize: 14,
                  color: MasarColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // المسار المهني
              const Text(
                'المسار المهني',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: MasarColors.border,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CareerPath>(
                    value: selectedCareerPath,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: MasarMockData.careerPaths.map((path) {
                      return DropdownMenuItem<CareerPath>(
                        value: path,
                        child: Text(path.title),
                      );
                    }).toList(),
                    onChanged: (path) {
                      if (path == null) return;

                      setState(() {
                        selectedCareerPath = path;
                        selectedSkill = null;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // المهارات التقنية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مهاراتك التقنية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${technicalSkills.length} مهارات',
                    style: const TextStyle(
                      fontSize: 13,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              ...technicalSkills.map(
                (skill) => _buildSkillCard(skill),
              ),

              const SizedBox(height: 28),

              // زر الجاهزية المهنية
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MasarColors.primaryBlue,
                      MasarColors.primaryGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'جاهزتك المهنية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'اعرف مستوى جاهزيتك والفجوة بين مهاراتك ومتطلبات المسار المهني',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CareerReadinessScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: MasarColors.primaryBlue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'عرض الجاهزية المهنية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // المهارات الشخصية
              const Text(
                'المهارات الشخصية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),

              const SizedBox(height: 14),

              ...MasarMockData.softSkills.map(
                (skill) => _buildSoftSkillCard(skill),
              ),

              const SizedBox(height: 30),
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

  Widget _buildSkillCard(Skill skill) {
    final bool isSelected = selectedSkill == skill;

    String status;
    Color statusColor;
    IconData statusIcon;

    if (skill.level >= 80) {
      status = 'قوي';
      statusColor = MasarColors.primaryGreen;
      statusIcon = Icons.check_circle;
    } else if (skill.level >= 60) {
      status = 'جيد';
      statusColor = MasarColors.primaryBlue;
      statusIcon = Icons.trending_up;
    } else {
      status = 'بحاجة إلى تطوير';
      statusColor = MasarColors.warning;
      statusIcon = Icons.warning_amber_rounded;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSkill = isSelected ? null : skill;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? MasarColors.primaryBlue
                : MasarColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: MasarColors.lightBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getSkillIcon(skill.name),
                    color: MasarColors.primaryBlue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 15,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Text(
                  '${skill.level}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: skill.level / 100,
                minHeight: 7,
                backgroundColor: MasarColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                  statusColor,
                ),
              ),
            ),

            if (isSelected) ...[
              const SizedBox(height: 18),
              _buildSkillDetails(skill),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillDetails(Skill skill) {
    const int requiredLevel = 70;
    final int gap = requiredLevel - skill.level;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل المهارة',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'المستوى الحالي',
                  '${skill.level}%',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'المستوى المطلوب',
                  '$requiredLevel%',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'الفجوة',
                  gap > 0 ? '$gap%' : 'مكتمل',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            gap > 0
                ? 'تحتاج إلى تطوير هذه المهارة بمقدار $gap% للوصول إلى المستوى المطلوب للمسار المهني.'
                : 'مستواك في هذه المهارة يحقق المستوى المطلوب للمسار المهني.',
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: MasarColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSoftSkillCard(SoftSkill skill) {
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MasarColors.lightGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              _getSoftSkillIcon(skill.name),
              color: MasarColors.primaryGreen,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              skill.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: MasarColors.textPrimary,
              ),
            ),
          ),

          Text(
            '${skill.level}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: MasarColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSkillIcon(String name) {
    switch (name.toLowerCase()) {
      case 'python':
        return Icons.code;
      case 'excel':
        return Icons.table_chart_outlined;
      case 'sql':
        return Icons.storage_outlined;
      case 'power bi':
        return Icons.bar_chart_rounded;
      case 'الإحصاء':
      case 'statistics':
        return Icons.analytics_outlined;
      case 'machine learning':
        return Icons.auto_awesome;
      case 'deep learning':
        return Icons.psychology_outlined;
      case 'data visualization':
        return Icons.insert_chart_outlined;
      case 'git':
        return Icons.account_tree_outlined;
      case 'apis':
        return Icons.api_outlined;
      default:
        return Icons.code_rounded;
    }
  }

  IconData _getSoftSkillIcon(String name) {
    switch (name.toLowerCase()) {
      case 'communication':
      case 'التواصل':
        return Icons.forum_outlined;
      case 'teamwork':
      case 'العمل الجماعي':
        return Icons.groups_outlined;
      case 'problem solving':
      case 'حل المشكلات':
        return Icons.lightbulb_outline;
      case 'time management':
      case 'إدارة الوقت':
        return Icons.access_time_rounded;
      case 'leadership':
      case 'القيادة':
        return Icons.leaderboard_outlined;
      default:
        return Icons.star_outline;
    }
  }
}