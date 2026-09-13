
import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'skill_details_screen.dart';

class SkillGapScreen extends StatefulWidget {
  const SkillGapScreen({super.key});

  @override
  State<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends State<SkillGapScreen> {
  late CareerPath selectedCareerPath;

  static const int requiredLevel = 70;

  @override
  void initState() {
    super.initState();
    selectedCareerPath = MasarMockData.selectedCareerPath;
  }

  List<Skill> _getSkillsForSelectedPath() {
    return MasarMockData.skills
        .where(
          (skill) =>
              selectedCareerPath.requiredSkills.contains(skill.name),
        )
        .toList();
  }

  List<Skill> _getSkillsWithGap() {
    return _getSkillsForSelectedPath()
        .where((skill) => skill.level < requiredLevel)
        .toList()
      ..sort(
        (a, b) {
          final gapA = requiredLevel - a.level;
          final gapB = requiredLevel - b.level;
          return gapB.compareTo(gapA);
        },
      );
  }

  int _getGap(Skill skill) {
    final gap = requiredLevel - skill.level;
    return gap > 0 ? gap : 0;
  }

  @override
  Widget build(BuildContext context) {
    final skillsForPath = _getSkillsForSelectedPath();
    final skillsWithGap = _getSkillsWithGap();

    final strongSkills = skillsForPath
        .where((skill) => skill.level >= requiredLevel)
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
                'فجوة المهارات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'اعرف المهارات التي تحتاج إلى تطويرها',
                style: TextStyle(
                  fontSize: 11,
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

                const SizedBox(height: 24),

                // ======================================================
                // SUMMARY
                // ======================================================

                _buildSummaryCard(
                  totalSkills: skillsForPath.length,
                  strongSkills: strongSkills.length,
                  gapSkills: skillsWithGap.length,
                ),

                const SizedBox(height: 30),

                // ======================================================
                // GAP TITLE
                // ======================================================

                const Text(
                  'المهارات التي تحتاج إلى تطوير',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'هذه المهارات تمثل الفجوة بين مستواك الحالي والمستوى المطلوب.',
                  style: TextStyle(
                    fontSize: 13,
                    color: MasarColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                if (skillsWithGap.isEmpty)
                  _buildNoGapState()
                else
                  ...skillsWithGap.map(
                    (skill) => _buildGapCard(skill),
                  ),
              ],
            ),
          ),
        ),

        // ============================================================
        // BOTTOM NAVIGATION
        // ============================================================

        bottomNavigationBar: NavigationBar(
          selectedIndex: 1,
          onDestinationSelected: (index) {
            _handleBottomNavigation(context, index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'خارطة الطريق',
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: 'الفرص',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder),
              label: 'الملف المهني',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CAREER DROPDOWN
  // ================================================================

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

  // ================================================================
  // SUMMARY CARD
  // ================================================================

  Widget _buildSummaryCard({
    required int totalSkills,
    required int strongSkills,
    required int gapSkills,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MasarColors.primaryBlue.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ملخص مهارات ${selectedCareerPath.title}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  value: '$totalSkills',
                  label: 'إجمالي المهارات',
                  color: MasarColors.primaryBlue,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  value: '$strongSkills',
                  label: 'مهارات جيدة',
                  color: MasarColors.primaryGreen,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  value: '$gapSkills',
                  label: 'تحتاج تطوير',
                  color: MasarColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SUMMARY ITEM
  // ================================================================

  Widget _buildSummaryItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // GAP CARD
  // ================================================================

  Widget _buildGapCard(Skill skill) {
    final int gap = _getGap(skill);

    return InkWell(
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
      child: Container(
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
                    color: Color(0xFFFFF4DF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: MasarColors.warning,
                    size: 22,
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
                      const SizedBox(height: 4),
                      Text(
                        'فجوة مهارية: $gap%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: MasarColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_left_rounded,
                  color: MasarColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مستواك: ${skill.level}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const Text(
                  'المطلوب: 70%',
                  style: TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: skill.level / requiredLevel,
                minHeight: 8,
                backgroundColor: MasarColors.lightGreen,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  MasarColors.primaryGreen,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اضغط لمعرفة كيفية تطوير المهارة',
                style: TextStyle(
                  fontSize: 11,
                  color: MasarColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // NO GAP STATE
  // ================================================================

  Widget _buildNoGapState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
            Icons.check_circle_outline,
            size: 50,
            color: MasarColors.primaryGreen,
          ),
          SizedBox(height: 12),
          Text(
            'ممتاز! لا توجد فجوات مهارية واضحة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'مستواك الحالي يغطي المتطلبات الأساسية لهذا المسار.',
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

  // ================================================================
  // BOTTOM NAVIGATION
  // ================================================================

  void _handleBottomNavigation(
    BuildContext context,
    int index,
  ) {
    if (index == 1) {
      return;
    }

    String message;

    switch (index) {
      case 0:
        message = 'الرئيسية';
        break;

      case 2:
        message = 'الفرص';
        break;

      case 3:
        message = 'الملف المهني';
        break;

      case 4:
        message = 'الملف الشخصي';
        break;

      default:
        return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$message ستكون متاحة قريبًا',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

