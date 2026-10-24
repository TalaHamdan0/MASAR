import 'package:flutter/material.dart';

import '../../core/models/certificate_model.dart';
import '../../core/models/project_model.dart';
import '../../core/models/skill_model.dart';
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

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String? _selectedMajor;
  String? _selectedAcademicYear;
  int? _profileVersion;

  bool _isSaving = false;

  final List<String> _selectedSkills = [];
  final List<Certificate> _selectedCertificates = [];
  final List<Project> _selectedProjects = [];

  final TextEditingController _gpaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  @override
  void dispose() {
    _gpaController.dispose();
    super.dispose();
  }

  void _loadStudentData() {
    final student = MasarMockData.currentStudent;

    if (student == null) return;

    _selectedMajor =
        student.major.trim().isEmpty ? null : student.major;

    _selectedAcademicYear =
        student.academicYear.trim().isEmpty
            ? null
            : student.academicYear;

    _profileVersion = AuthSession.profileVersion;
    _gpaController.text = student.gpa;

    _selectedSkills
      ..clear()
      ..addAll(student.skills.map((skill) => skill.name));

    _selectedCertificates
      ..clear()
      ..addAll(student.certificates);

    _selectedProjects
      ..clear()
      ..addAll(student.projects);
  }

  List<String> get _majorOptions => <String>{
        ...MasarMockData.majors,
        if (_selectedMajor != null) _selectedMajor!,
      }.toList();

  List<String> get _academicYearOptions => <String>{
        ...MasarMockData.academicYears,
        if (_selectedAcademicYear != null) _selectedAcademicYear!,
      }.toList();

  Map<String, Skill> get _skillOptions => <String, Skill>{
        for (final skill in MasarMockData.skills)
          skill.name: skill,
        for (final skill
            in MasarMockData.currentStudent?.skills ?? <Skill>[])
          skill.name: skill,
      };

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
  }

  String? _requiredText(
    String? value,
    String label,
    int maximum,
  ) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال $label';
    }

    if (text.length > maximum) {
      return '$label: الحد الأقصى $maximum حرف';
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

    return null;
  }

  String? _validateGithub(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);

    if (text.length > 500 ||
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

  String _normalizeGpa(String value) {
    final result = StringBuffer();

    for (final rune in value.trim().runes) {
      if (rune >= 0x0660 && rune <= 0x0669) {
        result.writeCharCode(48 + rune - 0x0660);
      } else if (rune >= 0x06F0 && rune <= 0x06F9) {
        result.writeCharCode(48 + rune - 0x06F0);
      } else {
        result.writeCharCode(rune);
      }
    }

    return result
        .toString()
        .replaceAll('٫', '.')
        .replaceAll(',', '.');
  }

  void _showAddSkillDialog() {
    String? selectedSkill;

    final availableSkills = _skillOptions.values
        .where(
          (skill) => !_selectedSkills.contains(skill.name),
        )
        .toList();

    if (availableSkills.isEmpty) {
      _showMessage('تمت إضافة جميع المهارات المتاحة.');
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'إضافة مهارة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                content: DropdownButtonFormField<String>(
                  value: selectedSkill,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'اختر المهارة',
                    prefixIcon: Icon(
                      Icons.auto_awesome_outlined,
                    ),
                  ),
                  items: availableSkills.map((skill) {
                    return DropdownMenuItem<String>(
                      value: skill.name,
                      child: Text(
                        skill.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedSkill = value;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedSkill == null
                        ? null
                        : () {
                            setState(() {
                              _selectedSkills.add(selectedSkill!);
                            });

                            Navigator.pop(dialogContext);
                          },
                    child: const Text(
                      'إضافة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddCertificateDialog() {
    final dialogFormKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final issuerController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'إضافة شهادة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Form(
              key: dialogFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: (value) {
                        return _requiredText(
                          value,
                          'اسم الشهادة',
                          200,
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'اسم الشهادة',
                        hintText: 'مثال: IBM Data Science',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: issuerController,
                      validator: (value) {
                        return _requiredText(
                          value,
                          'الجهة المانحة',
                          200,
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'الجهة المانحة',
                        hintText: 'مثال: IBM',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!(dialogFormKey.currentState?.validate() ??
                      false)) {
                    return;
                  }

                  setState(() {
                    _selectedCertificates.add(
                      Certificate(
                        id: DateTime.now()
                            .microsecondsSinceEpoch
                            .toString(),
                        title: titleController.text.trim(),
                        issuer: issuerController.text.trim(),
                        date: '',
                      ),
                    );
                  });

                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إضافة',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProjectDialog() {
    final dialogFormKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final technologiesController = TextEditingController();
    final githubController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'إضافة مشروع',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Form(
              key: dialogFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        return _requiredText(
                          value,
                          'اسم المشروع',
                          200,
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'اسم المشروع',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        return _requiredText(
                          value,
                          'وصف المشروع',
                          2000,
                        );
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'وصف المشروع',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: technologiesController,
                      validator: _validateTechnologies,
                      decoration: const InputDecoration(
                        labelText: 'التقنيات المستخدمة',
                        hintText: 'Python, SQL, Power BI',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: githubController,
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
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!(dialogFormKey.currentState?.validate() ??
                      false)) {
                    return;
                  }

                  final technologies = _splitTechnologies(
                    technologiesController.text,
                  );

                  setState(() {
                    _selectedProjects.add(
                      Project(
                        id: DateTime.now()
                            .microsecondsSinceEpoch
                            .toString(),
                        name: nameController.text.trim(),
                        description:
                            descriptionController.text.trim(),
                        technologies: technologies,
                        githubUrl: githubController.text.trim().isEmpty
                            ? null
                            : githubController.text.trim(),
                      ),
                    );
                  });

                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إضافة',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    if (_selectedMajor == null ||
        _selectedMajor!.trim().isEmpty ||
        _selectedAcademicYear == null ||
        _selectedAcademicYear!.trim().isEmpty) {
      _showMessage('يرجى إكمال المعلومات الأكاديمية المطلوبة.');
      return;
    }

    final gpa = _normalizeGpa(_gpaController.text);
    final number = double.tryParse(gpa);

    if (gpa.isNotEmpty &&
        (gpa.length > 20 ||
            !RegExp(
              r'^(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$',
            ).hasMatch(gpa) ||
            number == null ||
            !number.isFinite ||
            number < 0)) {
      _showMessage('يرجى إدخال المعدل كقيمة رقمية صحيحة.');
      return;
    }

    if (_selectedSkills.length > 100 ||
        _selectedCertificates.length > 100 ||
        _selectedProjects.length > 100) {
      _showMessage(
        'الحد الأقصى 100 عنصر لكل من المهارات والشهادات والمشاريع.',
      );
      return;
    }

    final oldStudent = MasarMockData.currentStudent;
    final token = AuthSession.accessToken;
    final version = _profileVersion;

    if (oldStudent == null || token == null) {
      _showMessage('يرجى تسجيل الدخول قبل حفظ الملف.');
      return;
    }

    if (version == null) {
      _showMessage(
        'نسخة الملف غير متاحة في الجلسة. سجّلي الدخول مجددًا.',
      );
      return;
    }

    final options = _skillOptions;
    final selectedSkillObjects = <Skill>[];

    for (final name in _selectedSkills) {
      final source = options[name];

      if (source == null) {
        _showMessage(
          'تعذر تحديد إحدى المهارات؛ راجعي قائمة المهارات.',
        );
        return;
      }

      selectedSkillObjects.add(
        Skill(
          id: source.id,
          name: source.name,
          level: 0,
          status: 'Not Assessed',
        ),
      );
    }

    final draft = Student(
      id: oldStudent.id,
      name: oldStudent.name,
      major: _selectedMajor!,
      university: oldStudent.university,
      academicYear: _selectedAcademicYear!,
      email: oldStudent.email,
      careerPathId: oldStudent.careerPathId,
      gpa: gpa,
      skills: selectedSkillObjects,
      softSkills: List.of(oldStudent.softSkills),
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
      );

      if (!mounted) return;

      if (AuthSession.accessToken != token) {
        _showMessage(
          'تغيّرت جلسة الدخول؛ يرجى فتح الملف من الحساب الحالي.',
        );
        return;
      }

      if (data['profileCompleted'] != true ||
          data['version'] is! int ||
          (data['version'] as int) <= version) {
        throw const FormatException(
          'لم يرجع تأكيد مكتمل للحفظ.',
        );
      }

      final savedStudent = AuthSession.updateProfile(data);

      _profileVersion = AuthSession.profileVersion;

      MasarMockData.currentStudent = savedStudent;
      MasarMockData.student = savedStudent;
      MasarMockData.isFirstLogin = false;

      MasarMockData.profileMockData.addAll({
        'name': savedStudent.name,
        'major': savedStudent.major,
        'university': savedStudent.university,
        'academicYear': savedStudent.academicYear,
        'email': savedStudent.email,
        'gpa': savedStudent.gpa,
        'careerPath': savedStudent.careerPathId,
      });

      Navigator.pushReplacementNamed(context, '/home');
    } on ApiException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on FormatException {
      if (mounted) {
        _showMessage(
          'استجابة الحفظ غير مكتملة. لم يتم الانتقال للرئيسية.',
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
                                Navigator.pop(context);
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
                                  fontFamily: 'Cairo',
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
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            20,
                            20,
                            30,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'أكمل معلوماتك',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: MasarColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'أضف معلوماتك الأساسية حتى نتمكن من تخصيص تجربتك في مسار.',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
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
                                  prefixIcon: Icon(
                                    Icons.menu_book_outlined,
                                  ),
                                ),
                                items: _majorOptions.map((major) {
                                  return DropdownMenuItem<String>(
                                    value: major,
                                    child: Text(
                                      major,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  );
                                }).toList(),
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
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                                items: _academicYearOptions.map((year) {
                                  return DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(
                                      year,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAcademicYear = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _gpaController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'المعدل التراكمي',
                                  hintText: 'مثال: 3.2',
                                  prefixIcon: Icon(
                                    Icons.grade_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              _SectionHeader(
                                title: 'مهاراتك الحالية',
                                icon: Icons.auto_awesome_outlined,
                                buttonText: 'إضافة مهارة',
                                onPressed: _showAddSkillDialog,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'أضف المهارات التي تمتلكها حاليًا، مع شهاداتك ومشاريعك، لتوثيق خبراتك في ملفك المهني.',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
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
                                Column(
                                  children: _selectedSkills.map((skill) {
                                    return _SkillCard(
                                      skillName: skill,
                                      onDelete: () {
                                        setState(() {
                                          _selectedSkills.remove(skill);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 28),
                              _SectionHeader(
                                title: 'الشهادات',
                                icon: Icons.workspace_premium_outlined,
                                buttonText: 'إضافة شهادة',
                                onPressed: _showAddCertificateDialog,
                              ),
                              const SizedBox(height: 12),
                              if (_selectedCertificates.isEmpty)
                                const _EmptySection(
                                  icon: Icons.workspace_premium_outlined,
                                  text: 'لم تتم إضافة أي شهادات بعد',
                                )
                              else
                                Column(
                                  children: _selectedCertificates
                                      .map((certificate) {
                                    return _CertificateCard(
                                      certificate: certificate,
                                      onDelete: () {
                                        setState(() {
                                          _selectedCertificates
                                              .remove(certificate);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 28),
                              _SectionHeader(
                                title: 'المشاريع',
                                icon: Icons.code_outlined,
                                buttonText: 'إضافة مشروع',
                                onPressed: _showAddProjectDialog,
                              ),
                              const SizedBox(height: 12),
                              if (_selectedProjects.isEmpty)
                                const _EmptySection(
                                  icon: Icons.code_outlined,
                                  text: 'لم تتم إضافة أي مشاريع بعد',
                                )
                              else
                                Column(
                                  children: _selectedProjects.map((project) {
                                    return _ProjectCard(
                                      project: project,
                                      onDelete: () {
                                        setState(() {
                                          _selectedProjects.remove(project);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed:
                                      _isSaving ? null : _saveProfile,
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
                                            fontFamily: 'Cairo',
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
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: MasarColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
        Icon(
          icon,
          size: 21,
          color: MasarColors.primaryBlue,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
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
        Icon(
          icon,
          size: 21,
          color: MasarColors.primaryBlue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.add,
            size: 18,
          ),
          label: Text(
            buttonText,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String skillName;
  final VoidCallback onDelete;

  const _SkillCard({
    required this.skillName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: MasarColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              skillName,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MasarColors.textPrimary,
              ),
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
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final VoidCallback onDelete;

  const _CertificateCard({
    required this.certificate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: MasarColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certificate.title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  certificate.issuer,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: MasarColors.textSecondary,
                  ),
                ),
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
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.code_outlined,
              color: MasarColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: MasarColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                if (project.technologies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: project.technologies.map((technology) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: MasarColors.lightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          technology,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
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
        border: Border.all(
          color: MasarColors.border,
        ),
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
              fontFamily: 'Cairo',
              fontSize: 12,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}