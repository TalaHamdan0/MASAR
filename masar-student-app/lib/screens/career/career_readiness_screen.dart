import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

import 'roadmap_screen.dart';

class CareerReadinessScreen extends StatefulWidget {
  final int? readinessScore;
  final Map<String, int>? skillScores;

  const CareerReadinessScreen({
    super.key,
    this.readinessScore,
    this.skillScores,
  });

  @override
  State<CareerReadinessScreen> createState() =>
      _CareerReadinessScreenState();
}

class _CareerReadinessScreenState
    extends State<CareerReadinessScreen> {
  bool _loading = true;
  String? _error;
  _CareerAnalysis? _analysis;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _analysis = null;
    });

    final token = AuthSession.accessToken;
    final selectedPath =
        MasarMockData.currentStudent?.careerPathId;

    try {
      if (token == null || token.trim().isEmpty) {
        throw const ApiException(
          'سجّلي الدخول لعرض تحليل ملفك.',
        );
      }

      final uri = Uri.parse(
        '${ApiService.baseUrl}/api/v1/students/me/career-analysis',
      ).replace(
        queryParameters:
            selectedPath == null || selectedPath.isEmpty
                ? null
                : {'careerPathId': selectedPath},
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (!mounted) return;

      if (AuthSession.accessToken != token) {
        throw const ApiException(
          'تغيّرت جلسة الدخول. افتحي التحليل من الحساب الحالي.',
        );
      }

      if (MasarMockData.currentStudent?.careerPathId !=
          selectedPath) {
        throw const ApiException(
          'تغيّر المسار أثناء التحليل. اضغطي إعادة المحاولة.',
        );
      }

      Map<String, dynamic>? body;

      try {
        final decoded = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (decoded is Map<String, dynamic>) {
          body = decoded;
        }
      } on FormatException {
        body = null;
      }

      if (response.statusCode != 200) {
        final error = body?['error'];

        if (error is Map<String, dynamic> &&
            error['message'] is String &&
            (error['message'] as String).trim().isNotEmpty) {
          throw ApiException(error['message'] as String);
        }

        throw ApiException(
          response.statusCode == 401
              ? 'انتهت الجلسة. سجّلي الدخول مجددًا.'
              : 'تعذر تحميل تحليل الملف. '
                  'رمز الاستجابة: ${response.statusCode}',
        );
      }

      final data = body?['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid analysis response.',
        );
      }

      _analysis = _CareerAnalysis.parse(data);
    } on ApiException catch (error) {
      if (mounted) {
        _error = error.message;
      }
    } on TimeoutException {
      if (mounted) {
        _error =
            'انتهت مهلة تحميل التحليل. حاولي مجددًا.';
      }
    } on http.ClientException {
      if (mounted) {
        _error =
            'تعذر الوصول للباكند. تأكدي أنه شغّال.';
      }
    } on FormatException {
      if (mounted) {
        _error =
            'بيانات التحليل التي رجعت من الباكند '
            'غير مكتملة أو غير متوافقة.';
      }
    } catch (_) {
      if (mounted) {
        _error = 'تعذر تحميل تحليل الملف حاليًا.';
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _error != null || _analysis == null) {
      return _MobilePage(
        child: Scaffold(
          backgroundColor: MasarColors.background,
          appBar: AppBar(
            title: const Text('تحليل الملف المهني'),
          ),
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 40,
                          color: MasarColors.textSecondary,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _error ?? 'لا تتوفر نتيجة تحليل.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _load,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: const AppBottomNavBar(
            selectedIndex: 0,
          ),
        ),
      );
    }

    final analysis = _analysis!;
    final skills = analysis.skills;

    final documented = skills
        .where((skill) => skill.covered)
        .toList();

    final undocumented = skills
        .where((skill) => !skill.covered)
        .map((skill) => skill.name)
        .toList();

    return _MobilePage(
      child: Scaffold(
        backgroundColor: MasarColors.background,
        appBar: AppBar(
          backgroundColor: MasarColors.background,
          elevation: 0,
          title: const Text(
            'تحليل الملف المهني',
            style: TextStyle(
              color: MasarColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildOverallProgress(
                  score: analysis.percentage,
                  documentedCount: documented.length,
                  totalCount: skills.length,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
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
                        'مقارنة ملفك بمتطلبات '
                        '${analysis.pathTitle}',
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
                  (skill) => _buildSkillCard(
                    skill.name,
                    skill.covered,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSummary(undocumented),
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
                    label: const Text('عرض خارطة الطريق'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MasarColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 0,
        ),
      ),
    );
  }

  Widget _buildOverallProgress({
    required double score,
    required int documentedCount,
    required int totalCount,
  }) {
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
            'تغطية متطلبات المسار',
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
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: MasarColors.background,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      MasarColors.primaryBlue,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${score.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'تغطية الملف',
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
            '$documentedCount من أصل $totalCount '
            'مهارات مسجّلة',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: MasarColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'تعتمد النتيجة على المهارات التي اخترتها '
            'وتقنيات المشاريع المرتبطة بأرقام مهارات '
            'في قاعدة البيانات. لا تقيس الإتقان ولا تحدد '
            'قبولك بالتدريب. لا تُحتسب الشهادات تلقائيًا.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(
    String skill,
    bool documented,
  ) {
    final color = documented
        ? MasarColors.primaryGreen
        : MasarColors.warning;

    return Container(
      width: double.infinity,
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
          Expanded(
            child: Text(
              skill,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            documented
                ? Icons.check_circle
                : Icons.info_outline,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              documented
                  ? 'مسجّلة في الملف'
                  : 'غير مسجّلة في الملف',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<String> undocumented) {
    if (undocumented.isEmpty) {
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
                'جميع مهارات المسار المحددة مسجّلة '
                'في ملفك. تسجيلها لا يثبت إتقانها.',
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
            'المهارات غير المسجّلة في الملف',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك إضافتها لملفك إذا كنت تعرفها، '
            'أو العمل على تعلمها.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ...undocumented.map(
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
                  Expanded(
                    child: Text(
                      skill,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MasarColors.textPrimary,
                      ),
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

class _MobilePage extends StatelessWidget {
  final Widget child;

  const _MobilePage({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: MasarColors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: SizedBox(
              width: double.infinity,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalysisSkill {
  final String id;
  final String name;
  final double weight;
  final bool covered;

  const _AnalysisSkill(
    this.id,
    this.name,
    this.weight,
    this.covered,
  );
}

class _CareerAnalysis {
  final String pathTitle;
  final List<_AnalysisSkill> skills;
  final double percentage;

  const _CareerAnalysis(
    this.pathTitle,
    this.skills,
    this.percentage,
  );

  factory _CareerAnalysis.parse(
    Map<String, dynamic> data,
  ) {
    final path = data['path'];
    final rawSkills = data['skills'];
    final percentage = data['coveragePercentage'];
    final version = data['profileVersion'];
    final studentId = data['studentId'];

    bool validId(dynamic value) {
      return value is String &&
          RegExp(r'^[1-9][0-9]*$').hasMatch(value);
    }

    if (path is! Map<String, dynamic> ||
        !validId(path['id']) ||
        path['title'] is! String ||
        (path['title'] as String).trim().isEmpty ||
        !validId(studentId) ||
        version is! int ||
        version < 0 ||
        rawSkills is! List ||
        rawSkills.isEmpty ||
        percentage is! num ||
        !percentage.isFinite ||
        percentage < 0 ||
        percentage > 100) {
      throw const FormatException(
        'Invalid analysis data.',
      );
    }

    final ids = <String>{};
    final skills = <_AnalysisSkill>[];

    var total = 0.0;
    var covered = 0.0;

    for (final item in rawSkills) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid skill.');
      }

      final id = item['id'];
      final name = item['name'];
      final weight = item['weight'];
      final matched = item['covered'];

      if (!validId(id) ||
          !ids.add(id as String) ||
          name is! String ||
          name.trim().isEmpty ||
          weight is! num ||
          !weight.isFinite ||
          weight <= 0 ||
          matched is! bool) {
        throw const FormatException(
          'Invalid skill result.',
        );
      }

      skills.add(
        _AnalysisSkill(
          id,
          name,
          weight.toDouble(),
          matched,
        ),
      );

      total += weight.toDouble();

      if (matched) {
        covered += weight.toDouble();
      }
    }

    final expected = covered / total * 100;

    if ((expected - percentage.toDouble()).abs() > 0.02 ||
        data['requiredCount'] != skills.length ||
        data['coveredCount'] !=
            skills.where((skill) => skill.covered).length) {
      throw const FormatException(
        'Inconsistent analysis result.',
      );
    }

    return _CareerAnalysis(
      path['title'] as String,
      List.unmodifiable(skills),
      percentage.toDouble(),
    );
  }
}