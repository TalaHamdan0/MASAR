import 'package:flutter/material.dart';

import '../../core/models/certificate_model.dart';
import '../../core/models/project_model.dart';
import '../../core/models/skill_model.dart';
import '../../core/models/soft_skill_model.dart';
import '../../core/models/student_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/profile_service.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedMajor;
  String? _selectedAcademicYear;
  int? _profileVersion;

  bool _isSaving = false;
  bool _isLoading = true;

  String? _loadError;
  Student? _student;

  final Map<String, String> _programIdByName = {};
  final List<Skill> _availableSkills = [];
  final Set<String> _selectedSkills = {};
  final Map<String, String> _skillTypes = {};
  final List<Certificate> _selectedCertificates = [];
  final List<Project> _selectedProjects = [];

  static const List<String> _academicYears = [
    'السنة الأولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  List<Map<String, dynamic>> _rows(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key];

    if (value is! List) {
      throw const FormatException('Invalid profile options.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid profile option.');
      }

      return item;
    }).toList();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    final token = AuthSession.accessToken;

    try {
      final options = await ProfileService.getProfileOptions();
      final data = await ProfileService.getMyProfile();

      if (!mounted) return;

      if (token == null || AuthSession.accessToken != token) {
        throw const ApiException(
          'تغيّرت جلسة الدخول. سجّلي الدخول مجددًا.',
        );
      }

      final programs = <String, String>{};

      for (final item in _rows(options, 'programs')) {
        final id = item['id'];
        final name = item['name'];

        if (id is! String ||
            !RegExp(r'^[1-9][0-9]*$').hasMatch(id) ||
            name is! String ||
            name.trim().isEmpty ||
            programs.containsKey(name)) {
          throw const FormatException('Invalid program data.');
        }

        programs[name] = id;
      }

      if (programs.isEmpty) {
        throw const ApiException(
          'لا توجد تخصصات متاحة للجامعة حاليًا.',
        );
      }

      final skills = <Skill>[];
      final skillIds = <String>{};
      final skillTypes = <String, String>{};
      final skillNames = <String>{};

      for (final item in _rows(options, 'skills')) {
        final type = item['type'];

        if (type != 'TECHNICAL' && type != 'SOFT') {
          continue;
        }

        final id = item['id'];
        final name = item['name'];

        if (id is! String ||
            !RegExp(r'^[1-9][0-9]*$').hasMatch(id) ||
            name is! String ||
            name.trim().isEmpty ||
            !skillIds.add(id) ||
            !skillNames.add(name)) {
          throw const FormatException('Invalid skill data.');
        }

        skillTypes[id] = type as String;

        skills.add(
          Skill(
            id: id,
            name: name,
            level: 0,
            status: 'Not Assessed',
          ),
        );
      }

      final student = AuthSession.updateProfile(data);
      final programId = data['programId'];
      final version = data['version'];

      if (version is! int || version < 0) {
        throw const FormatException('Invalid profile version.');
      }

      String? major;

      for (final entry in programs.entries) {
        if (entry.value == programId) {
          major = entry.key;
          break;
        }
      }

      if (major == null && programs.containsKey(student.major)) {
        major = student.major;
      }

      final academicYear = student.academicYear.trim();

      _student = student;
      _profileVersion = version;
      _selectedMajor = major;
      _selectedAcademicYear =
          _academicYears.contains(academicYear)
              ? academicYear
              : null;

      _programIdByName
        ..clear()
        ..addAll(programs);

      _availableSkills
        ..clear()
        ..addAll(skills);

      _selectedSkills
        ..clear()
        ..addAll(student.skills.map((skill) => skill.id))
        ..addAll(student.softSkills.map((skill) => skill.id));

      _skillTypes
        ..clear()
        ..addAll(skillTypes);

      _selectedCertificates
        ..clear()
        ..addAll(student.certificates);

      _selectedProjects
        ..clear()
        ..addAll(student.projects);

      _cacheStudent(student, data);
    } on ApiException catch (error) {
      if (mounted) {
        _loadError = error.message;
      }
    } on FormatException {
      if (mounted) {
        _loadError =
            'بيانات الملف أو قوائم التخصصات والمهارات غير صالحة.';
      }
    } catch (_) {
      if (mounted) {
        _loadError = 'تعذر تحميل الملف الشخصي حاليًا.';
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _cacheStudent(
    Student student,
    Map<String, dynamic> data,
  ) {
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
  }

  void _showMessage(String message) {
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

  bool _isEnglishText(String value) {
    return value.runes.every(
      (rune) =>
          rune == 9 ||
          rune == 10 ||
          rune == 13 ||
          (rune >= 32 && rune <= 126),
    );
  }

  String? _requiredEnglish(
    String? value,
    String label,
    int maximum,
  ) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال $label';
    }

    if (text.length > maximum) {
      return 'الحد الأقصى $maximum حرف';
    }

    if (!_isEnglishText(text)) {
      return 'اكتبي هذا الحقل بالإنجليزي ليظهر في الـCV';
    }

    return null;
  }

  List<String> _splitTechnologies(String text) {
    final seen = <String>{};

    return text
        .split(RegExp(r'[,،]'))
        .map((value) => value.trim())
        .where(
          (value) =>
              value.isNotEmpty &&
              seen.add(value.toLowerCase()),
        )
        .toList();
  }

  String? _validateTechnologies(String? value) {
    final values = _splitTechnologies(value ?? '');

    if (values.length > 50 ||
        values.any((value) => value.length > 120)) {
      return 'حتى 50 تقنية، واسم كل تقنية حتى 120 حرفًا';
    }

    if (values.any((value) => !_isEnglishText(value))) {
      return 'اكتبي أسماء التقنيات بالإنجليزي';
    }

    return null;
  }

  String? _validateGithub(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);

    if (text.length > 500 ||
        !_isEnglishText(text) ||
        uri == null ||
        uri.scheme != 'https' ||
        !{
          'github.com',
          'www.github.com',
        }.contains(uri.host.toLowerCase()) ||
        uri.userInfo.isNotEmpty) {
      return 'أدخلي رابط GitHub صحيحًا يبدأ بـ https://github.com/';
    }

    return null;
  }

  String _skillName(String id) {
    for (final skill in _availableSkills) {
      if (skill.id == id) return skill.name;
    }

    for (final skill in _student?.skills ?? <Skill>[]) {
      if (skill.id == id) return skill.name;
    }

    for (final skill in _student?.softSkills ?? <SoftSkill>[]) {
      if (skill.id == id) return skill.name;
    }

    return 'Unavailable skill ($id)';
  }

  Future<void> _showAddSkillDialog() async {
    if (_availableSkills.isEmpty) {
      _showMessage('لا توجد مهارات متاحة حاليًا.');
      return;
    }

    final result = await showDialog<Set<String>>(
      context: context,
      builder: (_) => _SkillPickerDialog(
        skills: _availableSkills,
        initialSelection: Set<String>.from(_selectedSkills),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedSkills
        ..clear()
        ..addAll(result);
    });
  }

  Future<void> _showCertificateDialog({
    Certificate? existing,
  }) async {
    final key = GlobalKey<FormState>();

    final title = TextEditingController(
      text: existing?.title ?? '',
    );

    final issuer = TextEditingController(
      text: existing?.issuer ?? '',
    );

    final result = await showDialog<Certificate>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              existing == null
                  ? 'إضافة شهادة'
                  : 'تعديل الشهادة',
            ),
            content: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: title,
                      textDirection: TextDirection.ltr,
                      validator: (value) => _requiredEnglish(
                        value,
                        'اسم الشهادة بالإنجليزي',
                        200,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'اسم الشهادة بالإنجليزي',
                        hintText: 'IBM Data Science',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: issuer,
                      textDirection: TextDirection.ltr,
                      validator: (value) => _requiredEnglish(
                        value,
                        'الجهة المانحة بالإنجليزي',
                        200,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'الجهة المانحة بالإنجليزي',
                        hintText: 'IBM',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!(key.currentState?.validate() ?? false)) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    Certificate(
                      id: existing?.id ??
                          'local_${DateTime.now().microsecondsSinceEpoch}',
                      title: title.text.trim(),
                      issuer: issuer.text.trim(),
                      date: existing?.date ?? '',
                    ),
                  );
                },
                child: Text(
                  existing == null ? 'إضافة' : 'حفظ التعديل',
                ),
              ),
            ],
          ),
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      title.dispose();
      issuer.dispose();
    });

    if (!mounted || result == null) return;

    setState(() {
      if (existing == null) {
        _selectedCertificates.add(result);
      } else {
        final index = _selectedCertificates.indexOf(existing);

        if (index >= 0) {
          _selectedCertificates[index] = result;
        }
      }
    });
  }

  Future<void> _showProjectDialog({
    Project? existing,
  }) async {
    final key = GlobalKey<FormState>();

    final name = TextEditingController(
      text: existing?.name ?? '',
    );

    final description = TextEditingController(
      text: existing?.description ?? '',
    );

    final technologies = TextEditingController(
      text: existing?.technologies.join(', ') ?? '',
    );

    final github = TextEditingController(
      text: existing?.githubUrl ?? '',
    );

    final result = await showDialog<Project>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              existing == null
                  ? 'إضافة مشروع'
                  : 'تعديل المشروع',
            ),
            content: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: name,
                      textDirection: TextDirection.ltr,
                      validator: (value) => _requiredEnglish(
                        value,
                        'اسم المشروع بالإنجليزي',
                        200,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'اسم المشروع بالإنجليزي',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: description,
                      textDirection: TextDirection.ltr,
                      maxLines: 4,
                      validator: (value) => _requiredEnglish(
                        value,
                        'وصف المشروع بالإنجليزي',
                        2000,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'وصف المشروع بالإنجليزي',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: technologies,
                      textDirection: TextDirection.ltr,
                      validator: _validateTechnologies,
                      decoration: const InputDecoration(
                        labelText: 'التقنيات المستخدمة بالإنجليزي',
                        hintText: 'Python, SQL, Flutter',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: github,
                      textDirection: TextDirection.ltr,
                      validator: _validateGithub,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'GitHub Link (اختياري)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!(key.currentState?.validate() ?? false)) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    Project(
                      id: existing?.id ??
                          'local_${DateTime.now().microsecondsSinceEpoch}',
                      name: name.text.trim(),
                      description: description.text.trim(),
                      technologies: _splitTechnologies(
                        technologies.text,
                      ),
                      githubUrl: github.text.trim().isEmpty
                          ? null
                          : github.text.trim(),
                    ),
                  );
                },
                child: Text(
                  existing == null ? 'إضافة' : 'حفظ التعديل',
                ),
              ),
            ],
          ),
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      name.dispose();
      description.dispose();
      technologies.dispose();
      github.dispose();
    });

    if (!mounted || result == null) return;

    setState(() {
      if (existing == null) {
        _selectedProjects.add(result);
      } else {
        final index = _selectedProjects.indexOf(existing);

        if (index >= 0) {
          _selectedProjects[index] = result;
        }
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_isSaving || _isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final programId = _programIdByName[_selectedMajor];

    if (programId == null) {
      _showMessage(
        'يرجى اختيار تخصص متاح من تخصصات الجامعة.',
      );
      return;
    }

    if (_selectedSkills.length > 100 ||
        _selectedCertificates.length > 100 ||
        _selectedProjects.length > 100) {
      _showMessage('الحد الأقصى 100 عنصر لكل قائمة.');
      return;
    }

    for (final certificate in _selectedCertificates) {
      if (_requiredEnglish(
            certificate.title,
            'اسم الشهادة',
            200,
          ) !=
          null ||
          _requiredEnglish(
            certificate.issuer,
            'الجهة المانحة',
            200,
          ) !=
              null) {
        _showMessage(
          'اضغطي على الشهادة "${certificate.title}" '
          'لتعديل بياناتها بالإنجليزي.',
        );
        return;
      }
    }

    for (final project in _selectedProjects) {
      if (_requiredEnglish(
            project.name,
            'اسم المشروع',
            200,
          ) !=
          null ||
          _requiredEnglish(
            project.description,
            'وصف المشروع',
            2000,
          ) !=
              null ||
          _validateTechnologies(
                project.technologies.join(', '),
              ) !=
              null ||
          _validateGithub(project.githubUrl) != null) {
        _showMessage(
          'اضغطي على المشروع "${project.name}" '
          'لتصحيح بياناته وكتابتها بالإنجليزي.',
        );
        return;
      }
    }

    final oldStudent = _student;
    final token = AuthSession.accessToken;
    final version = _profileVersion;

    if (oldStudent == null || token == null || version == null) {
      _showMessage('يرجى تسجيل الدخول مجددًا قبل الحفظ.');
      return;
    }

    final options = {
      for (final skill in _availableSkills) skill.id: skill,
    };

    final previous = {
      for (final skill in oldStudent.skills) skill.id: skill,
    };

    final previousSoft = {
      for (final skill in oldStudent.softSkills) skill.id: skill,
    };

    final skills = <Skill>[];
    final softSkills = <SoftSkill>[];

    for (final id in _selectedSkills) {
      final source = options[id];

      if (source == null) {
        _showMessage(
          'المهارة "${_skillName(id)}" لم تعد متاحة. '
          'احذفيها قبل الحفظ.',
        );
        return;
      }

      if (_skillTypes[id] == 'SOFT') {
        softSkills.add(
          SoftSkill(
            id: source.id,
            name: source.name,
            level: previousSoft[id]?.level ?? 0,
          ),
        );
        continue;
      }

      skills.add(
        Skill(
          id: source.id,
          name: source.name,
          level: previous[source.id]?.level ?? 0,
          status: 'Not Assessed',
        ),
      );
    }

    final draft = oldStudent.copyWith(
      major: _selectedMajor!,
      academicYear: _selectedAcademicYear!,
      gpa: '',
      skills: skills,
      softSkills: softSkills,
      certificates: List.of(_selectedCertificates),
      projects: List.of(_selectedProjects),
    );

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      final data = await ProfileService.saveMyProfile(
        student: draft,
        version: version,
        programId: programId,
      );

      if (!mounted) return;

      if (AuthSession.accessToken != token) {
        throw const ApiException(
          'تغيّرت جلسة الدخول. افتحي الملف من الحساب الحالي.',
        );
      }

      if (data['profileCompleted'] != true ||
          data['version'] is! int ||
          (data['version'] as int) <= version) {
        throw const FormatException(
          'لم يرجع تأكيد مكتمل للحفظ.',
        );
      }

      final savedStudent = AuthSession.updateProfile(data);

      _student = savedStudent;
      _profileVersion = data['version'] as int;

      _cacheStudent(savedStudent, data);

      Navigator.pushReplacementNamed(context, '/home');
    } on ApiException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on FormatException {
      if (mounted) {
        _showMessage(
          'لم يصل تأكيد كامل لحفظ البيانات. '
          'راجعي أحدث نسخة من الملف قبل إعادة المحاولة.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage('تعذر إكمال حفظ الملف حاليًا.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أكمل معلوماتك',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MasarColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'أضف معلوماتك الأساسية حتى نتمكن '
              'من تخصيص تجربتك في مسار.',
              style: TextStyle(
                fontSize: 13,
                color: MasarColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'المعلومات الأكاديمية',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMajor,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'التخصص',
                prefixIcon: Icon(Icons.menu_book_outlined),
              ),
              items: _programIdByName.keys.map((major) {
                return DropdownMenuItem(
                  value: major,
                  child: Text(major),
                );
              }).toList(),
              validator: (value) {
                if (value == null ||
                    !_programIdByName.containsKey(value)) {
                  return 'اختاري التخصص';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _selectedMajor = value;
                });
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedAcademicYear,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'السنة الدراسية',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              items: _academicYears.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              validator: (value) {
                if (!_academicYears.contains(value)) {
                  return 'اختاري السنة الدراسية';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _selectedAcademicYear = value;
                });
              },
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              title: 'مهاراتك الحالية',
              icon: Icons.auto_awesome_outlined,
              buttonText: 'اختيار المهارات',
              onPressed: _showAddSkillDialog,
            ),
            const SizedBox(height: 6),
            const Text(
              'اختاري المهارات التي تعلّمتِ أساسياتها أو استخدمتِها '
              'في مادة أو مشروع. الاختيار لا يعني إتقان المهارة.',
              style: TextStyle(
                fontSize: 12,
                color: MasarColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedSkills.isEmpty)
              const _EmptySection(
                icon: Icons.auto_awesome_outlined,
                text: 'لم تتم إضافة أي مهارات بعد',
              )
            else
              for (final skill in _selectedSkills)
                _EntryCard(
                  icon: Icons.auto_awesome,
                  title: _skillName(skill),
                  onDelete: () {
                    setState(() {
                      _selectedSkills.remove(skill);
                    });
                  },
                ),
            const SizedBox(height: 28),
            _SectionHeader(
              title: 'الشهادات',
              icon: Icons.workspace_premium_outlined,
              buttonText: 'إضافة شهادة',
              onPressed: () => _showCertificateDialog(),
            ),
            const SizedBox(height: 6),
            const Text(
              'اكتبي بيانات الشهادة بالإنجليزي. '
              'اضغطي على شهادة موجودة لتعديلها.',
              style: TextStyle(
                fontSize: 12,
                color: MasarColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedCertificates.isEmpty)
              const _EmptySection(
                icon: Icons.workspace_premium_outlined,
                text: 'لم تتم إضافة أي شهادات بعد',
              )
            else
              for (final certificate in _selectedCertificates)
                _EntryCard(
                  icon: Icons.workspace_premium_outlined,
                  title: certificate.title,
                  subtitle: certificate.issuer,
                  green: true,
                  onTap: () => _showCertificateDialog(
                    existing: certificate,
                  ),
                  onDelete: () {
                    setState(() {
                      _selectedCertificates.remove(certificate);
                    });
                  },
                ),
            const SizedBox(height: 28),
            _SectionHeader(
              title: 'المشاريع',
              icon: Icons.code_outlined,
              buttonText: 'إضافة مشروع',
              onPressed: () => _showProjectDialog(),
            ),
            const SizedBox(height: 6),
            const Text(
              'اكتبي اسم المشروع ووصفه بالإنجليزي. '
              'اضغطي على مشروع موجود لتعديله.',
              style: TextStyle(
                fontSize: 12,
                color: MasarColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedProjects.isEmpty)
              const _EmptySection(
                icon: Icons.code_outlined,
                text: 'لم تتم إضافة أي مشاريع بعد',
              )
            else
              for (final project in _selectedProjects)
                _EntryCard(
                  icon: Icons.code_outlined,
                  title: project.name,
                  subtitle: project.description,
                  technologies: project.technologies,
                  onTap: () => _showProjectDialog(
                    existing: project,
                  ),
                  onDelete: () {
                    setState(() {
                      _selectedProjects.remove(project);
                    });
                  },
                ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'حفظ والمتابعة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'يمكنك تعديل معلوماتك لاحقًا من الملف الشخصي.',
                style: TextStyle(
                  fontSize: 11,
                  color: MasarColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 42,
              color: MasarColors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              _loadError!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Container(
              width: double.infinity,
              color: MasarColors.background,
              child: SafeArea(
                child: AbsorbPointer(
                  absorbing: _isSaving,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: MasarColors.border,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.maybePop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'إكمال الملف الشخصي',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: MasarColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _loadError != null
                                ? _buildLoadError()
                                : _buildForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: MasarColors.primaryBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonText;
  final VoidCallback onPressed;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: MasarColors.primaryBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            buttonText,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<String> technologies;
  final bool green;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const _EntryCard({
    required this.icon,
    required this.title,
    this.subtitle,
    this.technologies = const [],
    this.green = false,
    this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: MasarColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: green
                        ? MasarColors.lightGreen
                        : MasarColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: green
                        ? MasarColors.primaryGreen
                        : MasarColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null &&
                          subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: MasarColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                      if (technologies.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: technologies.map((name) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: MasarColors.lightBlue,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: MasarColors.primaryBlue,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: MasarColors.error,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptySection({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: MasarColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillPickerDialog extends StatefulWidget {
  final List<Skill> skills;
  final Set<String> initialSelection;

  const _SkillPickerDialog({
    required this.skills,
    required this.initialSelection,
  });

  @override
  State<_SkillPickerDialog> createState() =>
      _SkillPickerDialogState();
}

class _SkillPickerDialogState
    extends State<_SkillPickerDialog> {
  final _search = TextEditingController();

  late final Set<String> _selected;

  String _query = '';
  String _category = 'All Skills';
  bool _selectedOnly = false;

  static const Map<String, List<String>> _groups = {
    'Programming Fundamentals': [
      'Programming Basics',
      'Object-Oriented Programming',
      'Data Structures',
      'Algorithms',
    ],
    'Programming Languages': [
      'Python',
      'Java',
      'JavaScript',
      'TypeScript',
      'Dart',
      'Kotlin',
      'Swift',
      'C',
      'C++',
      'C#',
    ],
    'Mobile Development': [
      'Dart',
      'Flutter',
      'Java',
      'Kotlin',
      'Swift',
      'Android Development',
      'iOS Development',
      'Mobile UI Development',
      'App Navigation',
      'State Management',
      'REST API Integration',
      'Local Data Storage',
      'Authentication',
      'Push Notifications',
      'Git',
      'Unit Testing',
      'Integration Testing',
    ],
    'Frontend Development': [
      'HTML',
      'CSS',
      'JavaScript',
      'TypeScript',
      'React',
      'Responsive Web Design',
      'REST API Integration',
      'Accessibility',
      'Git',
      'Unit Testing',
    ],
    'Backend Development': [
      'Python',
      'Java',
      'JavaScript',
      'C#',
      'Flask',
      'Django',
      'Node.js',
      'ASP.NET Core',
      'Server-Side Programming',
      'REST API Development',
      'Authentication',
      'Authorization',
      'Authentication and Authorization',
      'Input Validation',
      'Database Integration',
      'Git',
      'Unit Testing',
      'Integration Testing',
    ],
    'Databases': [
      'SQL',
      'Database Design',
      'MySQL',
      'PostgreSQL',
      'Oracle Database',
      'SQLite',
      'MongoDB',
      'Database Administration',
      'Query Optimization',
      'Backup and Recovery',
      'Database Security',
    ],
    'Data Analysis': [
      'Excel',
      'SQL',
      'Python',
      'Pandas',
      'NumPy',
      'Data Programming',
      'Data Cleaning',
      'Exploratory Data Analysis',
      'Statistics',
      'Data Visualization',
      'Power BI',
      'Data Interpretation',
    ],
    'AI & Machine Learning': [
      'Python',
      'NumPy',
      'Pandas',
      'Linear Algebra',
      'Statistics',
      'Data Preprocessing',
      'Machine Learning',
      'Model Evaluation',
      'scikit-learn',
      'Deep Learning',
      'TensorFlow',
      'PyTorch',
    ],
    'Cybersecurity': [
      'Cybersecurity Fundamentals',
      'Linux',
      'Networking Fundamentals',
      'Network Security',
      'Vulnerability Assessment',
      'Incident Response',
      'Wireshark',
      'Nmap',
    ],
    'Networking': [
      'Networking Fundamentals',
      'TCP/IP',
      'IP Addressing and Subnetting',
      'Routing',
      'Switching',
      'VLANs',
      'DNS',
      'DHCP',
      'Cisco Packet Tracer',
      'Wireshark',
    ],
    'Cloud & DevOps': [
      'Linux',
      'Cloud Computing',
      'AWS',
      'Microsoft Azure',
      'Google Cloud',
      'Docker',
      'Containerization',
      'Kubernetes',
      'CI/CD',
      'Infrastructure as Code',
      'Terraform',
      'Monitoring',
      'Git',
    ],
    'Software Testing': [
      'Manual Testing',
      'Test Design',
      'Bug Reporting',
      'Unit Testing',
      'Integration Testing',
      'API Testing',
      'Postman',
      'Test Automation',
      'Selenium',
    ],
    'UI/UX Design': [
      'Figma',
      'User Research',
      'User Flows',
      'Wireframing',
      'Prototyping',
      'Visual Design',
      'Usability Testing',
      'Accessibility',
    ],
    'Version Control & Collaboration': [
      'Git',
      'GitHub',
    ],
    'Soft Skills': [
      'Communication',
      'Teamwork',
      'Problem Solving',
      'Time Management',
      'Critical Thinking',
      'Continuous Learning',
      'Technical Writing',
      'Leadership',
    ],
    'Development Tools & Integration': [
      'APIs',
      'REST API Integration',
      'REST API Development',
      'Git',
      'GitHub',
      'Postman',
    ],
  };

  String _key(String value) {
    return value.trim().toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelection);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _inGroup(Skill skill, String category) {
    if (category == 'All Skills') return true;

    if (category == 'Other Skills') {
      return !_groups.values.any(
        (names) => names.any(
          (name) => _key(name) == _key(skill.name),
        ),
      );
    }

    return (_groups[category] ?? const <String>[]).any(
      (name) => _key(name) == _key(skill.name),
    );
  }

  List<String> get _categories {
    return [
      'All Skills',
      ..._groups.keys.where(
        (group) => widget.skills.any(
          (skill) => _inGroup(skill, group),
        ),
      ),
      if (widget.skills.any(
        (skill) => _inGroup(skill, 'Other Skills'),
      ))
        'Other Skills',
    ];
  }

  List<Skill> get _visible {
    final query = _key(_query);

    final result = widget.skills.where((skill) {
      return _inGroup(skill, _category) &&
          (!_selectedOnly || _selected.contains(skill.id)) &&
          (query.isEmpty || _key(skill.name).contains(query));
    }).toList();

    result.sort(
      (a, b) => _key(a.name).compareTo(_key(b.name)),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 560,
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Choose Your Skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _search,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search skills...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _search.clear();

                              setState(() {
                                _query = '';
                              });
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _category = value;
                    });
                  },
                ),
                Material(
                  color: Colors.transparent,
                  child: CheckboxListTile(
                    value: _selectedOnly,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity:
                        ListTileControlAffinity.leading,
                    title: Text(
                      'Selected only (${_selected.length})',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedOnly = value == true;
                      });
                    },
                  ),
                ),
                Text(
                  '${visible.length} skills',
                  style: const TextStyle(
                    fontSize: 11,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(
                          child: Text('No matching skills.'),
                        )
                      : ListView.builder(
                          itemCount: visible.length,
                          itemBuilder: (_, index) {
                            final skill = visible[index];

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Material(
                                color: _selected.contains(skill.id)
                                    ? MasarColors.lightBlue
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: MasarColors.border,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CheckboxListTile(
                                  value:
                                      _selected.contains(skill.id),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor:
                                      MasarColors.primaryBlue,
                                  title: Text(
                                    skill.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked == true) {
                                        _selected.add(skill.id);
                                      } else {
                                        _selected.remove(skill.id);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          Set<String>.from(_selected),
                        );
                      },
                      child: Text(
                        'تأكيد الاختيار (${_selected.length})',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}