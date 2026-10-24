import 'package:flutter/material.dart';

import 'package:masar_student_app/core/models/career_path_model.dart';
import 'package:masar_student_app/core/services/profile_analysis.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/screens/career/career_readiness_screen.dart';
import 'package:masar_student_app/screens/profile/notifications_screen.dart';
import 'package:masar_student_app/screens/training_screens/company_selection_screen.dart';
import 'package:masar_student_app/theme/masar_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCareerPathId;
  String? _analysisFingerprint;

  CareerPath? get _selectedPath {
    final id = _selectedCareerPathId ??
        MasarMockData.currentStudent?.careerPathId;

    return MasarMockData.getCareerPathById(id ?? '');
  }

  ProfileAnalysis get _analysis {
    return ProfileAnalysis.fromProfile(
      MasarMockData.currentStudent,
      _selectedPath,
    );
  }

  List<String> get _requiredSkills => _analysis.requiredSkills;

  Set<String> get _profileSkills => _analysis.profileSkills;

  String get _fingerprint => _analysis.fingerprint;

  bool get _hasAnalysis {
    return _analysisFingerprint != null &&
        _analysisFingerprint == _fingerprint;
  }

  List<String> get _missingSkills => _analysis.missingSkills;

  int? get _coverageScore {
    return _hasAnalysis ? _analysis.coverageScore : null;
  }

  @override
  void initState() {
    super.initState();

    _selectedCareerPathId =
        MasarMockData.currentStudent?.careerPathId;
  }

  void _analyzeProfile() {
    String? message;

    if (MasarMockData.currentStudent == null) {
      message = 'سجّل الدخول وأكمل ملفك المهني أولًا.';
    } else if (_selectedPath == null) {
      message = 'اختر مسارك المهني أولًا.';
    } else if (_requiredSkills.isEmpty) {
      message = 'متطلبات هذا المسار غير متاحة بعد.';
    } else if (_profileSkills.isEmpty) {
      message = 'أضف مهاراتك وتقنيات مشاريعك إلى ملفك أولًا.';
    }

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    setState(() {
      _analysisFingerprint = _fingerprint;
    });

    _showProfileAnalysis(context);
  }

  void _showProfileAnalysis(BuildContext context) {
    if (!_hasAnalysis) {
      _analyzeProfile();
      return;
    }

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const CareerReadinessScreen(),
      ),
    ).then((_) {
      if (!mounted) return;

      setState(() {
        _selectedCareerPathId =
            MasarMockData.currentStudent?.careerPathId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = MasarMockData.currentStudent;

    return Scaffold(
      backgroundColor: MasarColors.background,
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
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
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

                  // اختيار المسار المهني.
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
                        value: _selectedPath?.id,
                        hint: const Text('اختر مسارك المهني'),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        items: MasarMockData.careerPaths.map((path) {
                          return DropdownMenuItem<String>(
                            value: path.id,
                            child: Text(
                              path.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            _selectedCareerPathId = value;
                            _analysisFingerprint = null;
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
                    _selectedPath?.description ??
                        'اختر المسار الذي ترغب بتطوير مهاراتك فيه.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: MasarColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),

                  _buildAssessmentCard(context),
                  const SizedBox(height: 22),

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
      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 0,
      ),
    );
  }

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
                  'تحليل الملف المهني',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'قارن مهاراتك وتقنيات مشاريعك بمتطلبات المسار المختار.',
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
                    onPressed: _analyzeProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('حلّل ملفي المهني'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessCard(BuildContext context) {
    final score = _coverageScore;

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
                    value: (score ?? 0) / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                Text(
                  score == null ? '—' : '$score%',
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
                  'تغطية متطلبات المسار',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'بناءً على ملفك المهني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  score == null
                      ? 'حلّل ملفك لعرض المؤشر.'
                      : 'مؤشر تغطية وليس قياسًا للإتقان.',
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

  Widget _buildProgressCard(BuildContext context) {
    final score = _coverageScore;
    final progress = (score ?? 0) / 100;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تغطية مهارات المسار',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      score == null
                          ? 'لم يُحلّل الملف بعد'
                          : '$score% من المهارات مسجّلة',
                      style: const TextStyle(
                        color: MasarColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                score == null ? '—' : '$score%',
                style: const TextStyle(
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
            'تغطية الملف لا تعني إنجاز خارطة الطريق أو إتقان المهارات.',
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
              onPressed: () => _showProfileAnalysis(context),
              child: const Text('عرض تفاصيل التحليل'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showProfileAnalysis(context),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !_hasAnalysis
                        ? 'حلّل ملفك المهني'
                        : _missingSkills.isEmpty
                            ? 'طبّق مهاراتك بمشروع عملي'
                            : 'طوّر مهارة ${_missingSkills.first}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    !_hasAnalysis
                        ? 'ابدأ بمقارنة ملفك بمتطلبات المسار.'
                        : _missingSkills.isEmpty
                            ? 'توثيق جميع المهارات لا يغني عن الممارسة.'
                            : 'مهارة غير موثّقة؛ اقتراح حسب ترتيب قائمة المتطلبات.',
                    style: const TextStyle(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    builder: (_) => const SelectCompanyScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MasarColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('البحث عن شركة'),
            ),
          ),
        ],
      ),
    );
  }
}