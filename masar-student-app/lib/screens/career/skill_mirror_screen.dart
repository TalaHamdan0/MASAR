import 'package:flutter/material.dart';

import 'package:masar_student_app/core/models/career_path_model.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/services/profile_analysis.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

import 'career_readiness_screen.dart';

class SkillMirrorScreen extends StatefulWidget {
  // للتوافق مع الاستدعاءات القديمة فقط.
  // التحليل الحالي يعتمد على بيانات الملف.
  final int? readinessScore;
  final Map<String, int>? skillScores;

  const SkillMirrorScreen({
    super.key,
    this.readinessScore,
    this.skillScores,
  });

  @override
  State<SkillMirrorScreen> createState() {
    return _SkillMirrorScreenState();
  }
}

class _SkillMirrorScreenState extends State<SkillMirrorScreen> {
  CareerPath? selectedCareerPath;
  Skill? selectedSkill;

  ProfileAnalysis get _analysis {
    return ProfileAnalysis.fromProfile(
      MasarMockData.currentStudent,
      selectedCareerPath,
    );
  }

  @override
  void initState() {
    super.initState();

    selectedCareerPath = MasarMockData.getCareerPathById(
      MasarMockData.currentStudent?.careerPathId ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final technicalSkills = (
      _analysis.canAnalyze
          ? _analysis.requiredSkills
          : <String>[]
    ).map((name) {
      return Skill(
        id: ProfileAnalysis.normalize(name),
        name: name,
        level: _analysis.covers(name) ? 100 : 0,
        status: _analysis.covers(name)
            ? 'مسجّلة'
            : 'غير موثّقة',
      );
    }).toList();

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
                'قارن مهارات ملفك بمتطلبات المسار. '
                'المؤشر لا يقيس الإتقان.',
                style: TextStyle(
                  fontSize: 14,
                  color: MasarColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              if (_analysis.canAnalyze) ...[
                _buildReadinessCard(),
                const SizedBox(height: 25),
              ],

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
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
                    hint: const Text('اختر مسارك المهني'),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
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

                        MasarMockData.updateCareerPath(path.id);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),

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

              if (!_analysis.canAnalyze)
                Text(_analysis.unavailableReason!),

              ...technicalSkills.map(
                (skill) => _buildSkillCard(skill),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                      'جاهزيتك المهنية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'اعرض تغطية ملفك ومتطلبات المسار '
                      'التي لم تُوثّقها بعد',
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
                              builder: (_) {
                                return const CareerReadinessScreen();
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: MasarColors.primaryBlue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
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
              const Text(
                'المهارات الشخصية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              ...(
                MasarMockData.currentStudent?.softSkills ??
                    <SoftSkill>[]
              ).map(
                (skill) => _buildSoftSkillCard(skill),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 1,
        ),
      ),
    );
  }

  Widget _buildReadinessCard() {
    final score = _analysis.coverageScore!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: MasarColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$score%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.primaryBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تغطية متطلبات المسار',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'بناءً على مهارات الملف وتقنيات المشاريع؛ '
                  'دون احتساب الشهادات حاليًا',
                  style: TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(Skill skill) {
    final isSelected = selectedSkill == skill;
    final covered = _analysis.covers(skill.name);

    // تعبئة شريط التوثيق فقط، وليست نسبة إتقان.
    final currentLevel = covered ? 100 : 0;

    final status = covered
        ? 'مسجّلة في الملف'
        : 'غير موثّقة في الملف';

    final statusColor = covered
        ? MasarColors.primaryGreen
        : MasarColors.warning;

    final statusIcon = covered
        ? Icons.check_circle
        : Icons.info_outline;

    return Container(
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
                currentLevel == 100
                    ? 'مسجّلة'
                    : 'غير موثّقة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 2),
              IconButton(
                tooltip: isSelected
                    ? 'إخفاء التفاصيل'
                    : 'عرض التفاصيل',
                onPressed: () {
                  setState(() {
                    selectedSkill = isSelected ? null : skill;
                  });
                },
                icon: AnimatedRotation(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  turns: isSelected ? 0.5 : 0,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: MasarColors.textSecondary,
                    size: 28,
                  ),
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
          AnimatedCrossFade(
            duration: const Duration(
              milliseconds: 250,
            ),
            crossFadeState: isSelected
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: _buildSkillDetails(
                skill,
                currentLevel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillDetails(
    Skill skill,
    int currentLevel,
  ) {
    const requiredLevel = 100;
    final gap = requiredLevel - currentLevel;

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
                  'حالة التوثيق',
                  currentLevel == 100
                      ? 'مسجّلة'
                      : 'غير موثّقة',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'متطلب المسار',
                  'مهارة مطلوبة',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'الفجوة',
                  gap > 0
                      ? 'غير موثّقة'
                      : 'مغطاة بالملف',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            gap > 0
                ? 'هذه المهارة غير موثّقة في ملفك؛ '
                    'أضفها إن كنت تمتلكها أو ابدأ بتعلّمها.'
                : 'هذه المهارة مسجّلة في ملفك؛ '
                    'وجودها لا يثبت مستوى إتقانها.',
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

  Widget _buildDetailItem(
    String title,
    String value,
  ) {
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
          const Text(
            'مسجّلة',
            style: TextStyle(
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