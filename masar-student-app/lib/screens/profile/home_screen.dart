import 'package:flutter/material.dart';

import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/screens/career/career_assessment_screen.dart';
import 'package:masar_student_app/screens/career/roadmap_screen.dart';
import 'package:masar_student_app/screens/training_screens/company_selection_screen.dart';
import 'package:masar_student_app/screens/profile/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCareerPathId;

  @override
  void initState() {
    super.initState();

    _selectedCareerPathId =
        MasarMockData.currentStudent?.careerPathId;
  }

  @override
  Widget build(BuildContext context) {
    final student = MasarMockData.currentStudent;

    final selectedPathId =
        _selectedCareerPathId ??
        student?.careerPathId ??
        MasarMockData.careerPaths.first.id;

    final selectedPath = MasarMockData.careerPaths.firstWhere(
      (path) => path.id == selectedPathId,
      orElse: () => MasarMockData.careerPaths.first,
    );

    return Scaffold(
      backgroundColor: MasarColors.background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ==================================================
                  // WELCOME
                  // ==================================================

                  Text(
                    'مرحباً بك، ${student?.name ?? 'طالب'} 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: MasarColors.textPrimary,
                        ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'ابدأ رحلتك المهنية وطوّر مهاراتك للوصول إلى هدفك.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: MasarColors.textSecondary,
                        ),
                  ),

                  const SizedBox(height: 26),

                  // ==================================================
                  // CAREER PATH
                  // ==================================================

                  Text(
                    'اختر مسارك المهني',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: MasarColors.textPrimary,
                        ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
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
                        value: selectedPath.id,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        items: MasarMockData.careerPaths
                            .map(
                              (path) => DropdownMenuItem<String>(
                                value: path.id,
                                child: Text(
                                  path.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            _selectedCareerPathId = value;
                          });

                          final currentStudent =
                              MasarMockData.currentStudent;

                          if (currentStudent != null) {
                            MasarMockData.currentStudent =
                                currentStudent.copyWith(
                              careerPathId: value,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    selectedPath.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: MasarColors.textSecondary,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // START ASSESSMENT
                  // ==================================================

                  _buildAssessmentCard(context),

                  const SizedBox(height: 22),

                  // ==================================================
                  // READINESS SCORE
                  // ==================================================

                  Text(
                    'جاهزيتك للمسار',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  _buildReadinessCard(context),

                  const SizedBox(height: 26),

                  // ==================================================
                  // CAREER PROGRESS
                  // ==================================================

                  Text(
                    'تقدمك في المسار',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  _buildProgressCard(context),

                  const SizedBox(height: 26),

                  // ==================================================
                  // NEXT STEP
                  // ==================================================

                  Text(
                    'خطوتك التالية',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  _buildNextStepCard(context),

                  const SizedBox(height: 26),

                  // ==================================================
                  // FIELD TRAINING
                  // ==================================================

                  Text(
                    'التدريب الميداني',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  _buildInternshipCard(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 0,
      ),
    );
  }

  // ==============================================================
  // ASSESSMENT CARD
  // ==============================================================

  Widget _buildAssessmentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MasarColors.primaryBlue.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: MasarColors.primaryBlue,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'قيّم جاهزيتك',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'اختبار قصير يساعدنا على تحديد مستواك في مهارات المسار.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: MasarColors.textSecondary,
                        height: 1.4,
                      ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CareerAssessmentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ابدأ التقييم',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // READINESS CARD
  // ==============================================================

  Widget _buildReadinessCard(BuildContext context) {
    final score = MasarMockData.readinessScore;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MasarColors.primaryBlue,
            MasarColors.darkBlue,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 82,
                  height: 82,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),

                Text(
                  '$score%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نسبة الجاهزية الحالية',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'جاهزيتك للمسار المهني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  score >= 70
                      ? 'أنت على الطريق الصحيح.'
                      : 'استمر في تطوير مهاراتك.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // PROGRESS CARD
  // ==============================================================

  Widget _buildProgressCard(BuildContext context) {
    const double progress = 0.72;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: MasarColors.lightGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: MasarColors.primaryGreen,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تقدمك في المسار',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      '72% مكتمل',
                      style: TextStyle(
                        color: MasarColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                '72%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: MasarColors.lightGreen,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                MasarColors.primaryGreen,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'تابع خارطة الطريق لتطوير المهارات المطلوبة لمسارك.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: MasarColors.textSecondary,
                ),
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RoadmapScreen(),
                  ),
                );
              },
              child: const Text(
                'عرض خارطة الطريق',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // NEXT STEP CARD
  // ==============================================================

  Widget _buildNextStepCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _showSqlSkillBottomSheet(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: MasarColors.lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.code_rounded,
                color: MasarColors.primaryBlue,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طوّر مهارة SQL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'هذه المهارة تحتاج إلى تطوير حسب مسارك الحالي.',
                    style: TextStyle(
                      color: MasarColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: MasarColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // SQL SKILL BOTTOM SHEET
  // ==============================================================

  void _showSqlSkillBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: MasarColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Header
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.code_rounded,
                        color: MasarColors.primaryBlue,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طوّر مهارة SQL',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: MasarColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'مهارة أساسية لمسارك المهني',
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

                const SizedBox(height: 24),

                // Current level
                _buildSkillLevelRow(
                  title: 'مستواك الحالي',
                  value: '30%',
                  valueColor: MasarColors.warning,
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 12),

                // Required level
                _buildSkillLevelRow(
                  title: 'المستوى المطلوب',
                  value: '70%',
                  valueColor: MasarColors.primaryBlue,
                  icon: Icons.flag_outlined,
                ),

                const SizedBox(height: 12),

                // Gap
                _buildSkillLevelRow(
                  title: 'الفجوة التي تحتاج لتطويرها',
                  value: '40%',
                  valueColor: MasarColors.error,
                  icon: Icons.trending_up_rounded,
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: MasarColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: MasarColors.primaryBlue,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'SQL من المهارات الأساسية لمسارك الحالي، '
                          'لذلك يُنصح بالتركيز عليها ضمن خارطة الطريق.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: MasarColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Roadmap button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RoadmapScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          MasarColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'عرض خارطة الطريق',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    child: const Text(
                      'إغلاق',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==============================================================
  // SKILL LEVEL ROW
  // ==============================================================

  Widget _buildSkillLevelRow({
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: MasarColors.textSecondary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: MasarColors.textSecondary,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // FIELD TRAINING CARD
  // ==============================================================

  Widget _buildInternshipCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: MasarColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: MasarColors.primaryGreen,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التدريب الميداني',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'ابحث عن شركة للتدريب الميداني وقدّم طلبك.',
                      style: TextStyle(
                        color: MasarColors.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SelectCompanyScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    MasarColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'البحث عن شركة',
              ),
            ),
          ),
        ],
      ),
    );
  }
}