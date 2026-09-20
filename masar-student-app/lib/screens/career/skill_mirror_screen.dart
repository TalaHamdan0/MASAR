import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'career_readiness_screen.dart';
import 'my_cv_screen.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';

class SkillMirrorScreen extends StatefulWidget {
  // نتيجة الاختبار
  final int? readinessScore;

  // نتائج كل مهارة
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

class _SkillMirrorScreenState
    extends State<SkillMirrorScreen> {
  late CareerPath selectedCareerPath;

  Skill? selectedSkill;

  @override
  void initState() {
    super.initState();

    selectedCareerPath =
        MasarMockData.selectedCareerPath;
  }

  @override
  Widget build(BuildContext context) {
    final technicalSkills =
        MasarMockData.skills
            .where(
              (skill) =>
                  selectedCareerPath.requiredSkills
                      .contains(skill.name),
            )
            .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,

        // =========================
        // APP BAR
        // =========================
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

        // =========================
        // BODY
        // =========================
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'افهم مستواك الحالي وطوّر مهاراتك للوصول إلى هدفك المهني',
                style: TextStyle(
                  fontSize: 14,
                  color: MasarColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // READINESS SCORE
              // =========================
              if (widget.readinessScore != null) ...[
                _buildReadinessCard(),
                const SizedBox(height: 25),
              ],

              // =========================
              // CAREER PATH
              // =========================
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
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: MasarColors.border,
                  ),
                ),
                child:
                    DropdownButtonHideUnderline(
                  child:
                      DropdownButton<CareerPath>(
                    value: selectedCareerPath,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    items: MasarMockData
                        .careerPaths
                        .map((path) {
                      return DropdownMenuItem<
                          CareerPath>(
                        value: path,
                        child: Text(path.title),
                      );
                    }).toList(),
                    onChanged: (path) {
                      if (path == null) return;

                      setState(() {
                        selectedCareerPath =
                            path;
                        selectedSkill = null;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // TECHNICAL SKILLS TITLE
              // =========================
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =========================
              // TECHNICAL SKILLS
              // =========================
              ...technicalSkills.map(
                (skill) => _buildSkillCard(skill),
              ),

              const SizedBox(height: 28),

              // =========================
              // CAREER READINESS CARD
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      MasarColors.primaryBlue,
                      MasarColors.primaryGreen,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'جاهزيتك المهنية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
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
                          final score =
                              widget.readinessScore ??
                              MasarMockData
                                  .readinessScore;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CareerReadinessScreen(
                                readinessScore: score,
                                skillScores:
                                    widget.skillScores,
                              ),
                            ),
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white,
                          foregroundColor:
                              MasarColors
                                  .primaryBlue,
                          elevation: 0,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(14),
                          ),
                        ),
                        child: const Text(
                          'عرض الجاهزية المهنية',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // SOFT SKILLS
              // =========================
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
                (skill) =>
                    _buildSoftSkillCard(skill),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),

        // =========================
        // BOTTOM NAVIGATION
        // =========================

        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 1,
        ),
      ),
    );
  }

  // =========================================================
  // READINESS CARD
  // =========================================================

  Widget _buildReadinessCard() {
    final score = widget.readinessScore!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration:
                const BoxDecoration(
              color: MasarColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$score%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      MasarColors.primaryBlue,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'درجة الجاهزية المهنية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        MasarColors.textPrimary,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'نتيجتك بناءً على اختبار المهارات الأخير',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TECHNICAL SKILL CARD
  // =========================================================

  Widget _buildSkillCard(
    Skill skill,
  ) {
    final bool isSelected =
        selectedSkill == skill;

    final int currentLevel =
        widget.skillScores?[skill.name] ??
            skill.level;

    String status;
    Color statusColor;
    IconData statusIcon;

    if (currentLevel >= 80) {
      status = 'قوي';
      statusColor =
          MasarColors.primaryGreen;
      statusIcon =
          Icons.check_circle;
    } else if (currentLevel >= 60) {
      status = 'جيد';
      statusColor =
          MasarColors.primaryBlue;
      statusIcon =
          Icons.trending_up;
    } else {
      status = 'بحاجة إلى تطوير';
      statusColor =
          MasarColors.warning;
      statusIcon =
          Icons.warning_amber_rounded;
    }

    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? MasarColors.primaryBlue
              : MasarColors.border,
          width:
              isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.03,
            ),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          // =========================
          // SKILL HEADER
          // =========================
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color:
                      MasarColors.lightBlue,
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  _getSkillIcon(
                    skill.name,
                  ),
                  color:
                      MasarColors.primaryBlue,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.name,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            MasarColors
                                .textPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          statusIcon,
                          size: 15,
                          color:
                              statusColor,
                        ),

                        const SizedBox(
                            width: 4),

                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                statusColor,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Text(
                '$currentLevel%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
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
                    selectedSkill =
                        isSelected
                            ? null
                            : skill;
                  });
                },
                icon:
                    AnimatedRotation(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),
                  turns:
                      isSelected
                          ? 0.5
                          : 0,
                  child: const Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                    color:
                        MasarColors
                            .textSecondary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =========================
          // PROGRESS BAR
          // =========================
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child:
                LinearProgressIndicator(
              value:
                  currentLevel / 100,
              minHeight: 7,
              backgroundColor:
                  MasarColors.background,
              valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                statusColor,
              ),
            ),
          ),

          // =========================
          // DETAILS
          // =========================
          AnimatedCrossFade(
            duration:
                const Duration(
              milliseconds: 250,
            ),
            crossFadeState:
                isSelected
                    ? CrossFadeState
                        .showSecond
                    : CrossFadeState
                        .showFirst,
            firstChild:
                const SizedBox.shrink(),
            secondChild:
                Padding(
              padding:
                  const EdgeInsets.only(
                top: 18,
              ),
              child:
                  _buildSkillDetails(
                skill,
                currentLevel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SKILL DETAILS
  // =========================================================

  Widget _buildSkillDetails(
    Skill skill,
    int currentLevel,
  ) {
    const int requiredLevel = 70;

    final int gap =
        requiredLevel - currentLevel;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل المهارة',
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.bold,
              color:
                  MasarColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'المستوى الحالي',
                  '$currentLevel%',
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
                  gap > 0
                      ? '$gap%'
                      : 'مكتمل',
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
              color:
                  MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DETAIL ITEM
  // =========================================================

  Widget _buildDetailItem(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          title,
          textAlign:
              TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color:
                MasarColors.textSecondary,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          textAlign:
              TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.bold,
            color:
                MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SOFT SKILL CARD
  // =========================================================

  Widget _buildSoftSkillCard(
    SoftSkill skill,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(
              color:
                  MasarColors.lightGreen,
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: Icon(
              _getSoftSkillIcon(
                skill.name,
              ),
              color:
                  MasarColors.primaryGreen,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              skill.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w600,
                color:
                    MasarColors.textPrimary,
              ),
            ),
          ),

          Text(
            '${skill.level}%',
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
              color:
                  MasarColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TECHNICAL SKILL ICONS
  // =========================================================

  IconData _getSkillIcon(
    String name,
  ) {
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

  // =========================================================
  // SOFT SKILL ICONS
  // =========================================================

  IconData _getSoftSkillIcon(
    String name,
  ) {
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