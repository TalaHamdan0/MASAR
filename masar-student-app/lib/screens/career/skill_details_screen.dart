
import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/core/models/skill_model.dart';

class SkillDetailsScreen extends StatelessWidget {
  final Skill skill;

  const SkillDetailsScreen({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    // SQL example:
    // Current Level = Beginner (30%)
    // Required Level = Intermediate (70%)
    const int requiredLevel = 70;

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
          title: Text(
            skill.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),

        // ============================================================
        // BODY
        // ============================================================

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ======================================================
                // SECTION 1: PROGRESS CARD
                // ======================================================

                _buildProgressCard(requiredLevel),

                const SizedBox(height: 30),

                // ======================================================
                // SECTION 2: RELATED COURSES
                // ======================================================

                const Text(
                  'الكورسات المرتبطة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                _buildCourseCard(
                  icon: Icons.school_outlined,
                  title: 'SQL Fundamentals',
                  provider: 'Coursera',
                  duration: '4 weeks',
                ),

                const SizedBox(height: 12),

                _buildCourseCard(
                  icon: Icons.menu_book_outlined,
                  title: 'Advanced SQL',
                  provider: 'Udemy',
                  duration: '6 weeks',
                ),

                const SizedBox(height: 30),

                // ======================================================
                // SECTION 3: RELATED PROJECTS
                // ======================================================

                const Text(
                  'المشاريع المرتبطة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                _buildProjectCard(
                  title: 'Sales Analysis Dashboard',
                ),

                const SizedBox(height: 12),

                _buildProjectCard(
                  title: 'Data Analysis Project',
                ),
              ],
            ),
          ),
        ),

        // ============================================================
        // BOTTOM CTA
        // ============================================================

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تمت إضافة المهارة إلى خارطة الطريق',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MasarColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'إضافة إلى خارطة الطريق',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PROGRESS CARD
  // ================================================================

  Widget _buildProgressCard(int requiredLevel) {
    final int currentLevel = skill.level;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          // Current Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المستوى الحالي',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: MasarColors.textPrimary,
                ),
              ),

              Text(
                '${_getLevelName(currentLevel)} ($currentLevel%)',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Required Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المستوى المطلوب',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: MasarColors.textPrimary,
                ),
              ),

              Text(
                '${_getLevelName(requiredLevel)} ($requiredLevel%)',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: currentLevel / requiredLevel,
              minHeight: 10,
              backgroundColor: MasarColors.lightGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(
                MasarColors.primaryGreen,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'المطلوب للوصول للمستوى التالي: ${requiredLevel - currentLevel}%',
              style: const TextStyle(
                fontSize: 12,
                color: MasarColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // COURSE CARD
  // ================================================================

  Widget _buildCourseCard({
    required IconData icon,
    required String title,
    required String provider,
    required String duration,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: MasarColors.primaryBlue,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$provider • $duration',
                  style: const TextStyle(
                    fontSize: 12,
                    color: MasarColors.textSecondary,
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
    );
  }

  // ================================================================
  // PROJECT CARD
  // ================================================================

  Widget _buildProjectCard({
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: MasarColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_open_outlined,
              color: MasarColors.primaryGreen,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: MasarColors.textPrimary,
              ),
            ),
          ),

          const Icon(
            Icons.chevron_left_rounded,
            color: MasarColors.textSecondary,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // LEVEL NAME
  // ================================================================

  String _getLevelName(int level) {
    if (level < 40) {
      return 'مبتدئ';
    }

    if (level < 70) {
      return 'متوسط';
    }

    return 'متقدم';
  }
}

