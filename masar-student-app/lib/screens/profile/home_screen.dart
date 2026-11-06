
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/models/career_path_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

import '../career/career_readiness_screen.dart';
import '../career/roadmap_screen.dart';
import '../training_screens/company_selection_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CareerPath> _careerPaths = [];

  String? _selectedCareerPathId;
  String? _pathsError;

  bool _loadingPaths = true;
  bool _savingPath = false;
  bool _analyzing = false;

  int? _roadmapCompleted;
  int? _roadmapTotal;
  bool _loadingRoadmap = false;

  double? _analysisScore;
  int? _analysisVersion;
  String? _analysisPathId;

  static const Color _blue = Color(0xFF1565C0);
  static const Color _green = Color(0xFF218653);
  static const Color _softBackground = Color(0xFFF7F9FC);
  static const Color _softBorder = Color(0xFFE7ECF2);
  static const Color _secondary = Color(0xFF64748B);
  static const Color _heading = Color(0xFF172B4D);

  CareerPath? get _selectedPath {
    for (final path in _careerPaths) {
      if (path.id == _selectedCareerPathId) {
        return path;
      }
    }
    return null;
  }

  double? get _coverageScore {
    if (_analysisVersion != AuthSession.profileVersion ||
        _analysisPathId != _selectedCareerPathId) {
      return null;
    }
    return _analysisScore;
  }

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    Map<String, dynamic>? payload,
  }) async {
    final token = AuthSession.accessToken;

    if (token == null || token.trim().isEmpty) {
      throw const ApiException('سجّلي الدخول أولًا.');
    }

    final uri = Uri.parse('${ApiService.baseUrl}$path');

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      if (payload != null) 'Content-Type': 'application/json',
    };

    try {
      final http.Response response;

      if (payload == null) {
        response = await http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 20));
      } else {
        response = await http
            .put(
              uri,
              headers: headers,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 20));
      }

      debugPrint(
        'MASAR HOME API: '
        '${payload == null ? 'GET' : 'PUT'} '
        '$uri -> ${response.statusCode}',
      );

      if (AuthSession.accessToken != token) {
        throw const ApiException(
          'تغيّرت الجلسة. سجّلي الدخول مجددًا.',
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

        switch (response.statusCode) {
          case 401:
            throw const ApiException(
              'انتهت الجلسة. سجّلي الدخول مجددًا.',
            );
          case 404:
            throw const ApiException(
              'الخدمة المطلوبة غير موجودة في نسخة الباكند الشغّالة.',
            );
          default:
            throw ApiException(
              'تعذر إكمال الطلب. '
              'رمز الاستجابة: ${response.statusCode}',
            );
        }
      }

      final data = body?['data'];

      if (data is! Map<String, dynamic>) {
        throw const ApiException(
          'استجابة الباكند غير مكتملة.',
        );
      }

      return data;
    } on TimeoutException {
      throw const ApiException(
        'انتهت مهلة الاتصال بالباكند.',
      );
    } on http.ClientException catch (error) {
      debugPrint('MASAR HOME NETWORK: $uri - $error');

      throw const ApiException(
        'تعذر الوصول للباكند. تأكدي أنه شغّال.',
      );
    }
  }

  void _cacheStudent(Map<String, dynamic> data) {
    final student = AuthSession.updateProfile(data);

    MasarMockData.currentStudent = student;
    MasarMockData.student = student;
    MasarMockData.isFirstLogin =
        data['profileCompleted'] != true;

    MasarMockData.profileMockData.addAll({
      'name': student.name,
      'nameEn': student.nameEn,
      'major': student.major,
      'university': student.university,
      'academicYear': student.academicYear,
      'email': student.email,
      'studentNumber': data['studentNumber'],
      'careerPath': student.careerPathId,
    });

    _selectedCareerPathId = student.careerPathId;
  }

  Future<void> _loadRoadmapProgress() async {
    if (_selectedCareerPathId == null) {
      if (mounted) {
        setState(() {
          _roadmapCompleted = null;
          _roadmapTotal = null;
        });
      }
      return;
    }

    setState(() {
      _loadingRoadmap = true;
    });

    try {
      final data = await _request(
        '/api/v1/students/me/roadmap',
      );

      if (!mounted) return;

      final rawItems = data['items'];
      final path = data['path'];

      if (rawItems is! List ||
          path is! Map<String, dynamic> ||
          path['id'] != _selectedCareerPathId ||
          rawItems.any(
            (item) =>
                item is! Map<String, dynamic> ||
                ![
                  'NOT_STARTED',
                  'IN_PROGRESS',
                  'COMPLETED',
                ].contains(item['status']),
          )) {
        throw const FormatException(
          'Invalid roadmap progress data.',
        );
      }

      final int total = rawItems.length;
      final int completed = rawItems
          .where((item) => item['status'] == 'COMPLETED')
          .length;

      setState(() {
        _roadmapCompleted = completed;
        _roadmapTotal = total;
      });
    } catch (error) {
      debugPrint('MASAR HOME ROADMAP: $error');

      if (mounted) {
        setState(() {
          _roadmapCompleted = null;
          _roadmapTotal = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingRoadmap = false;
        });
      }
    }
  }

  Future<void> _openRoadmap() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const RoadmapScreen(),
      ),
    );

    if (mounted) {
      await _loadRoadmapProgress();
    }
  }

  Future<void> _loadHome() async {
    setState(() {
      _loadingPaths = true;
      _pathsError = null;
    });

    try {
      final options = await _request(
        '/api/v1/students/career-paths',
      );

      final profile = await _request(
        '/api/v1/students/me',
      );

      if (!mounted) return;

      final rawPaths = options['paths'];

      if (rawPaths is! List) {
        throw const FormatException('Invalid paths.');
      }

      final ids = <String>{};
      final paths = <CareerPath>[];

      for (final item in rawPaths) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid path.');
        }

        final id = item['id'];
        final title = item['title'];
        final description = item['description'];
        final requiredSkills = item['requiredSkills'];

        if (id is! String ||
            !RegExp(r'^[1-9][0-9]*$').hasMatch(id) ||
            !ids.add(id) ||
            title is! String ||
            title.trim().isEmpty ||
            description is! String ||
            requiredSkills is! List ||
            requiredSkills.any(
              (value) => value is! String,
            )) {
          throw const FormatException(
            'Invalid career path fields.',
          );
        }

        paths.add(
          CareerPath(
            id: id,
            title: title,
            description: description,
            requiredSkills:
                requiredSkills.cast<String>().toList(),
          ),
        );
      }

      if (paths.isEmpty) {
        throw const ApiException(
          'لا توجد مسارات مفعّلة حاليًا.',
        );
      }

      _cacheStudent(profile);

      _careerPaths
        ..clear()
        ..addAll(paths);

      await _loadRoadmapProgress();
    } on ApiException catch (error) {
      if (mounted) {
        _pathsError = error.message;
      }
    } on FormatException {
      if (mounted) {
        _pathsError =
            'بيانات المسارات أو الملف الشخصي غير صالحة.';
      }
    } catch (error) {
      debugPrint('MASAR HOME LOAD: $error');

      if (mounted) {
        _pathsError = 'تعذر تحميل الصفحة الرئيسية.';
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingPaths = false;
        });
      }
    }
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textDirection: TextDirection.rtl,
          ),
        ),
      );
  }

  Future<void> _selectPath(String value) async {
    if (_savingPath ||
        _loadingPaths ||
        _analyzing ||
        value == _selectedCareerPathId) {
      return;
    }

    final version = AuthSession.profileVersion;

    if (version == null) {
      _message('سجّلي الدخول مجددًا.');
      return;
    }

    setState(() {
      _savingPath = true;
    });

    try {
      final data = await _request(
        '/api/v1/students/me/career-path',
        payload: {
          'careerPathId': value,
          'version': version,
        },
      );

      if (!mounted) return;

      if (data['careerPathId'] != value) {
        throw const ApiException(
          'لم يصل تأكيد حفظ المسار. حدّثي الصفحة.',
        );
      }

      _cacheStudent(data);
      await _loadRoadmapProgress();

      setState(() {
        _analysisScore = null;
        _analysisVersion = null;
        _analysisPathId = null;
      });
    } on ApiException catch (error) {
      _message(error.message);

      if (mounted) {
        await _loadHome();
      }
    } catch (error) {
      debugPrint('MASAR HOME SAVE PATH: $error');

      _message(
        'تعذر تأكيد اختيار المسار. '
        'حدّثي الصفحة قبل المحاولة مجددًا.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingPath = false;
        });
      }
    }
  }

  Future<void> _analyzeProfile() async {
    if (_analyzing ||
        _savingPath ||
        _loadingPaths ||
        _pathsError != null) {
      return;
    }

    final pathId = _selectedPath?.id;

    if (pathId == null) {
      _message('اختاري مسارك المهني أولًا.');
      return;
    }

    setState(() {
      _analyzing = true;
    });

    try {
      final data = await _request(
        '/api/v1/students/me/career-analysis'
        '?careerPathId=$pathId',
      );

      if (!mounted) return;

      final score = data['coveragePercentage'];
      final path = data['path'];
      final version = data['profileVersion'];

      if (score is! num ||
          !score.isFinite ||
          score < 0 ||
          score > 100 ||
          version is! int ||
          version < 0 ||
          path is! Map<String, dynamic> ||
          path['id'] != pathId ||
          data['studentId'] !=
              MasarMockData.currentStudent?.id) {
        throw const ApiException(
          'بيانات التحليل غير متوافقة.',
        );
      }

      setState(() {
        _analysisScore = score.toDouble();
        _analysisVersion = version;
        _analysisPathId = pathId;
      });

      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => const CareerReadinessScreen(),
        ),
      );

      if (mounted) {
        await _loadHome();
      }
    } on ApiException catch (error) {
      _message(error.message);
    } catch (error) {
      debugPrint('MASAR HOME ANALYSIS: $error');
      _message('تعذر تحميل التحليل حاليًا.');
    } finally {
      if (mounted) {
        setState(() {
          _analyzing = false;
        });
      }
    }
  }

  void _openCompanies() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectCompanyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = MasarMockData.currentStudent;
    final name = student?.name.trim() ?? '';
    final displayName = name.isEmpty ? 'طالب' : name;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _softBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: _softBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'MASAR',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _blue,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: _heading,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const NotificationsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: RefreshIndicator(
                onRefresh: _loadHome,
                child: ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    18, 16, 18, 110,
                  ),
                  children: [
                    Text(
                      'مرحباً، $displayName 👋',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: _heading,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'تابع رحلتك المهنية من مكان واحد.',
                      style: TextStyle(
                        fontSize: 13,
                        color: _secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildPathCard(),
                    const SizedBox(height: 16),
                    _buildOverviewCard(),
                    const SizedBox(height: 16),
                    _buildAssessmentCard(context),
                    const SizedBox(height: 16),
                    _buildInternshipCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 0,
        ),
      ),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _softBorder),
      ),
      child: child,
    );
  }

  Widget _sectionHeader(
    String title,
    IconData icon, {
    Color color = _blue,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _heading,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPathCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'مسارك المهني',
            Icons.explore_outlined,
          ),
          const SizedBox(height: 14),
          _buildCareerPathSelector(),
          const SizedBox(height: 10),
          Text(
            _selectedPath?.description ??
                'اختر المجال الذي ترغب بالعمل '
                    'والتطور فيه بعد التخرج.',
            style: const TextStyle(
              fontSize: 12,
              height: 1.6,
              color: _secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerPathSelector() {
    if (_loadingPaths) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_pathsError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pathsError!,
            style: const TextStyle(
              color: MasarColors.error,
            ),
          ),
          TextButton.icon(
            onPressed: _loadHome,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _softBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _softBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPath?.id,
                hint: const Text(
                  'اختر مسارك المهني',
                ),
                isExpanded: true,
                menuMaxHeight: 360,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _blue,
                ),
                items: _careerPaths.map((path) {
                  return DropdownMenuItem<String>(
                    value: path.id,
                    child: Text(
                      path.title,
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _heading,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: _savingPath || _analyzing
                    ? null
                    : (value) {
                        if (value != null) {
                          _selectPath(value);
                        }
                      },
              ),
            ),
          ),
          if (_savingPath)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    final score = _coverageScore;
    final completed = _roadmapCompleted;
    final total = _roadmapTotal;

    final available =
        completed != null && total != null && total > 0;

    final progress =
        available ? completed / total : 0.0;

    final percentage = (progress * 100).round();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'ملخص تقدّمك',
            Icons.insights_outlined,
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _summaryTile(
                  icon: Icons.track_changes_rounded,
                  title: 'تغطية المهارات',
                  value: score == null
                      ? '—'
                      : '${score.toStringAsFixed(1)}%',
                  color: _blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryTile(
                  icon: Icons.route_rounded,
                  title: 'إنجاز خارطة الطريق',
                  value: _loadingRoadmap
                      ? '...'
                      : available
                          ? '$percentage%'
                          : '—',
                  color: _green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            color: _softBorder,
            height: 1,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'خارطة الطريق',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _heading,
                  ),
                ),
              ),
              Text(
                _loadingRoadmap
                    ? 'جارٍ التحميل...'
                    : available
                        ? '$completed من $total خطوات مكتملة'
                        : 'بيانات التقدّم غير متاحة',
                style: const TextStyle(
                  fontSize: 11,
                  color: _secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor:
                  const Color(0xFFE7F0EA),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                _green,
              ),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _selectedPath == null
                ? null
                : _openRoadmap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 7,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'تابع تطوير مهاراتك',
                      style: TextStyle(
                        fontSize: 12,
                        color: _secondary,
                      ),
                    ),
                  ),
                  Text(
                    'عرض الخارطة',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _selectedPath == null
                          ? _secondary
                          : _green,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 17,
                    color: _selectedPath == null
                        ? _secondary
                        : _green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: _softBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 23,
          ),
          const SizedBox(height: 9),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: _secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard(
    BuildContext context,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'تحليل الملف المهني',
            Icons.assignment_outlined,
          ),
          const SizedBox(height: 12),
          const Text(
            'اكتشف المهارات التي تغطيها في مسارك '
            'والمهارات التي تحتاج إلى تطويرها.',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: _secondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loadingPaths ||
                      _savingPath ||
                      _analyzing ||
                      _pathsError != null
                  ? null
                  : _analyzeProfile,
              icon: _analyzing
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.auto_graph_rounded,
                      size: 19,
                    ),
              label: Text(
                _analyzing
                    ? 'جارٍ التحليل...'
                    : 'حلّل ملفي المهني',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    _blue.withOpacity(0.40),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipCard() {
    final selectedPath = _selectedPath;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'التدريب الميداني',
            Icons.work_outline_rounded,
          ),
          const SizedBox(height: 12),
          Text(
            selectedPath == null
                ? 'اختر مسارك المهني، ثم تصفّح '
                    'فرص التدريب المتاحة.'
                : 'مسارك المختار: ${selectedPath.title}. '
                    'تصفّح فرص التدريب المناسبة لمجالك.',
            style: const TextStyle(
              fontSize: 12,
              height: 1.6,
              color: _secondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اطّلع على تفاصيل كل فرصة '
            'وما ستتعلّمه خلالها.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: _secondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openCompanies,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 18,
              ),
              label: const Text(
                'استعراض فرص التدريب',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _blue,
                side: const BorderSide(
                  color: _blue,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
