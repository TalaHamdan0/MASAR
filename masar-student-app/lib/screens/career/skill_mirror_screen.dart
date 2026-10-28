import 'package:flutter/material.dart';

import 'package:masar_student_app/core/models/career_path_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/services/profile_analysis.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

import 'career_readiness_screen.dart';

class SkillMirrorScreen extends StatefulWidget {
  final int? readinessScore;
  final Map<String, int>? skillScores;

  const SkillMirrorScreen({
    super.key,
    this.readinessScore,
    this.skillScores,
  });

  @override
  State<SkillMirrorScreen> createState() =>
      _SkillMirrorScreenState();
}

class _SkillMirrorScreenState extends State<SkillMirrorScreen> {
  CareerPath? _selectedCareerPath;
  String? _selectedSkillName;

  ProfileAnalysis get _analysis {
    return ProfileAnalysis.fromProfile(
      MasarMockData.currentStudent,
      _selectedCareerPath,
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedCareerPath = MasarMockData.getCareerPathById(
      MasarMockData.currentStudent?.careerPathId ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysis = _analysis;

    final technicalSkills = analysis.canAnalyze
        ? analysis.requiredSkills
        : <String>[];

    final softSkills =
        MasarMockData.currentStudent?.softSkills ?? <SoftSkill>[];

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
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قارن مهارات ملفك بمتطلبات المسار. المؤشر لا يقيس الإتقان.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (analysis.canAnalyze) ...[
                    _buildReadinessCard(analysis.coverageScore!),
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
                  _buildCareerPathSelector(),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'مهاراتك التقنية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MasarColors.textPrimary,
                          ),
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
                  if (!analysis.canAnalyze)
                    Text(
                      analysis.unavailableReason ??
                          'لا تتوفر بيانات كافية للتحليل.',
                      style: const TextStyle(
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ...technicalSkills.map(
                    (skill) => _buildSkillCard(
                      skill,
                      analysis.covers(skill),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildReadinessLink(),
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
                  if (softSkills.isEmpty)
                    const Text(
                      'لم تُضف مهارات شخصية إلى ملفك بعد.',
                      style: TextStyle(
                        color: MasarColors.textSecondary,
                        fontSize: 13,
                      ),
                    )
                  else
                    ...softSkills.map(_buildSoftSkillCard),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 1,
        ),
      ),
    );
  }

  Widget _buildCareerPathSelector() {
    final paths = MasarMockData.careerPaths;

    final selectedId = paths.any(
      (path) => path.id == _selectedCareerPath?.id,
    )
        ? _selectedCareerPath?.id
        : null;

    return Container(
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
        child: DropdownButton<String>(
          value: selectedId,
          hint: const Text('اختر مسارك المهني'),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          items: paths.map((path) {
            return DropdownMenuItem<String>(
              value: path.id,
              child: Text(path.title),
            );
          }).toList(),
          onChanged: (id) {
            if (id == null) return;

            final path = MasarMockData.getCareerPathById(id);

            if (path == null) return;

            setState(() {
              _selectedCareerPath = path;
              _selectedSkillName = null;
              MasarMockData.updateCareerPath(id);
            });
          },
        ),
      ),
    );
  }

  Widget _buildReadinessCard(int score) {
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
            alignment: Alignment.center,
            child: Text(
              '$score%',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MasarColors.primaryBlue,
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
                  'بناءً على مهارات الملف وتقنيات المشاريع، دون احتساب الشهادات حاليًا.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
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

  Widget _buildSkillCard(
    String skillName,
    bool documented,
  ) {
    final isSelected = _selectedSkillName == skillName;

    final statusColor = documented
        ? MasarColors.primaryGreen
        : MasarColors.warning;

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
                child: const Icon(
                  Icons.code_rounded,
                  color: MasarColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      documented
                          ? 'موثّقة في الملف'
                          : 'غير موثّقة في الملف',
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isSelected
                    ? 'إخفاء التفاصيل'
                    : 'عرض التفاصيل',
                onPressed: () {
                  setState(() {
                    _selectedSkillName =
                        isSelected ? null : skillName;
                  });
                },
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
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
          if (isSelected) ...[
            const SizedBox(height: 14),
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
                  const Text(
                    'تفاصيل المهارة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    documented
                        ? 'هذه المهارة مسجّلة في ملفك؛ وجودها لا يثبت مستوى إتقانها.'
                        : 'هذه المهارة غير موثّقة في ملفك؛ أضفها إن كنت تعرفها أو ابدأ بتعلّمها.',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadinessLink() {
    return Container(
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
            'اعرض تغطية ملفك ومتطلبات المسار التي لم تُوثّقها بعد.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
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
                    builder: (_) => const CareerReadinessScreen(),
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
            child: const Icon(
              Icons.star_outline,
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
}