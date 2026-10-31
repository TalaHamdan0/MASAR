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

  double? _analysisScore;
  int? _analysisVersion;
  String? _analysisPathId;

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
            requiredSkills.any((value) => value is! String)) {
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
                  builder: (_) =>
                      const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
                    'اختر مسارك، وطوّر مهاراتك، '
                    'واكتشف فرص التدريب المرتبطة بمجالك.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: MasarColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    context,
                    'اختر مسارك المهني',
                  ),
                  const SizedBox(height: 10),
                  _buildCareerPathSelector(),
                  const SizedBox(height: 10),
                  Text(
                    _selectedPath?.description ??
                        'اختر المجال الذي ترغب بالعمل '
                            'والتطور فيه بعد التخرج.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: MasarColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildAssessmentCard(context),
                  const SizedBox(height: 22),
                  _sectionTitle(
                    context,
                    'تغطية مهارات المسار',
                  ),
                  const SizedBox(height: 12),
                  _buildReadinessCard(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    context,
                    'التدريب الميداني',
                  ),
                  const SizedBox(height: 12),
                  _buildInternshipCard(),
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

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MasarColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPath?.id,
                hint: const Text('اختر مسارك المهني'),
                isExpanded: true,
                menuMaxHeight: 360,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                  'قارن مهاراتك وتقنيات مشاريعك '
                  'بمتطلبات المسار المختار، وتعرّف '
                  'على المهارات التي يمكنك تطويرها.',
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
                    onPressed: _loadingPaths ||
                            _savingPath ||
                            _analyzing ||
                            _pathsError != null
                        ? null
                        : _analyzeProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _analyzing
                          ? 'جارٍ التحليل...'
                          : 'حلّل ملفي المهني',
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

  Widget _buildReadinessCard() {
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
                  score == null
                      ? '—'
                      : '${score.toStringAsFixed(1)}%',
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                      : 'نسبة تغطية المهارات المسجّلة، '
                          'وليست قياسًا للإتقان.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipCard() {
    final selectedPath = _selectedPath;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'التدريب الميداني',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedPath == null
                          ? 'اختر مسارك المهني، ثم تصفّح '
                              'فرص التدريب المتاحة.'
                          : 'مسارك المختار: '
                              '${selectedPath.title}. '
                              'تصفّح فرص التدريب وابحث '
                              'عن فرصة مناسبة لمجالك.',
                      style: const TextStyle(
                        color: MasarColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اطّلع على تفاصيل كل فرصة '
                      'وما ستتعلّمه خلالها.',
                      style: TextStyle(
                        color: MasarColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
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
              onPressed: _openCompanies,
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