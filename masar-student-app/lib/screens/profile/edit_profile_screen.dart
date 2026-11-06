
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();

  Map<String, dynamic> _profile = {};

  List<Map<String, dynamic>> _programs = [];
  List<Map<String, dynamic>> _skillsCatalog = [];
  List<Map<String, dynamic>> _careerPaths = [];

  List<Map<String, dynamic>> _technicalSkills = [];
  List<Map<String, dynamic>> _softSkills = [];
  List<Map<String, dynamic>> _certificates = [];
  List<Map<String, dynamic>> _projects = [];

  String? _selectedProgramId;
  String? _selectedAcademicYear;
  String? _selectedCareerPathId;

  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    super.dispose();
  }

  String get _baseUrl => ApiService.baseUrl;

  String get _token => AuthSession.accessToken ?? '';

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  String _text(dynamic value) => value?.toString() ?? '';

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  List<Map<String, dynamic>> _maps(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int _version() {
    final value = _profile['version'];
    if (value is int) return value;
    return int.tryParse(_text(value)) ?? 0;
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    if (_token.isEmpty) {
      throw Exception('يرجى تسجيل الدخول أولًا.');
    }

    final uri = Uri.parse('$_baseUrl$path');

    late http.Response response;

    if (method == 'PUT') {
      response = await http
          .put(
            uri,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
    } else {
      response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 20));
    }

    dynamic decoded;

    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw Exception('استجابة الخادم غير صالحة.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('استجابة الخادم غير صالحة.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      final error = decoded['error'];

      if (error is Map && error['message'] != null) {
        throw Exception(error['message'].toString());
      }

      if (decoded['message'] != null) {
        throw Exception(decoded['message'].toString());
      }

      throw Exception(
        'تعذر تنفيذ الطلب (${response.statusCode}).',
      );
    }

    final data = decoded['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('بيانات الخادم غير صالحة.');
    }

    return data;
  }

  void _setProfile(Map<String, dynamic> profile) {
    _profile = profile;

    _nameController.text = _text(profile['name']);
    _nameEnController.text = _text(profile['nameEn']);

    _selectedProgramId = _text(profile['programId']);
    _selectedAcademicYear = _text(profile['academicYear']);
    _selectedCareerPathId = _text(profile['careerPathId']);

    _technicalSkills = _maps(profile['skills']);
    _softSkills = _maps(profile['softSkills']);
    _certificates = _maps(profile['certificates']);
    _projects = _maps(profile['projects']);
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _request('/api/v1/students/me'),
        _request('/api/v1/students/profile-options'),
        _request('/api/v1/students/career-paths'),
      ]);

      if (!mounted) return;

      final options = results[1];

      setState(() {
        _programs = _maps(options['programs']);
        _skillsCatalog = _maps(options['skills']);
        _careerPaths = _maps(results[2]['paths']);
        _setProfile(results[0]);
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = _message(error);
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String? _validSelection(
    String? value,
    List<String> options,
  ) {
    if (value == null || !options.contains(value)) {
      return null;
    }

    return value;
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor:
            isError ? MasarColors.error : null,
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_saving ||
        !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _saving = true);

    try {
      final programId = _selectedProgramId;
      final academicYear = _selectedAcademicYear;

      if (programId == null || programId.isEmpty) {
        throw Exception('يرجى اختيار التخصص.');
      }

      if (academicYear == null ||
          academicYear.isEmpty) {
        throw Exception('يرجى اختيار السنة الدراسية.');
      }

      final profileBody = <String, dynamic>{
        'version': _version(),
        'name': _nameController.text.trim(),
        'nameEn': _nameEnController.text.trim(),
        'programId': programId,
        'academicYear': academicYear,
        'skills': _technicalSkills.map((item) {
          return {
            'id': _text(item['id']),
            'level': item['level'] is int
                ? item['level']
                : int.tryParse(_text(item['level'])) ?? 0,
          };
        }).toList(),
        'softSkills': _softSkills.map((item) {
          return {
            'id': _text(item['id']),
            'level': item['level'] is int
                ? item['level']
                : int.tryParse(_text(item['level'])) ?? 0,
          };
        }).toList(),
        'certificates': _certificates.map((item) {
  return {
    'id': item['id'],
    'title': _text(item['title']),
    'issuer': _text(item['issuer']),
    'date': '',
  };
}).toList(),
        'projects': _projects.map((item) {
          return {
            'id': item['id'],
            'name': _text(item['name']),
            'description': _text(item['description']),
            'githubUrl': _text(item['githubUrl']),
            'technologies': List<String>.from(
              item['technologies'] ?? [],
            ),
          };
        }).toList(),
      };

      final savedProfile = await _request(
        '/api/v1/students/me/profile',
        method: 'PUT',
        body: profileBody,
      );

      _profile = savedProfile;

      final newPathId = _selectedCareerPathId;
      final currentPathId =
          _text(savedProfile['careerPathId']);

      if (newPathId != null &&
          newPathId.isNotEmpty &&
          newPathId != currentPathId) {
        _profile = await _request(
          '/api/v1/students/me/career-path',
          method: 'PUT',
          body: {
            'careerPathId': newPathId,
            'version': _version(),
          },
        );
      }

      if (!mounted) return;

      _showMessage('تم حفظ الملف الشخصي بنجاح.');
      Navigator.pop(context, true);
    } catch (error) {
      _showMessage(
        _message(error),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _addSkill({
    required bool soft,
  }) async {
    final expectedType =
        soft ? 'SOFT' : 'TECHNICAL';

    final catalog = _skillsCatalog.where((skill) {
      final type =
          _text(skill['type']).toUpperCase();

      if (soft) {
        return type == 'SOFT' ||
            type == 'SOFT_SKILL';
      }

      return type == 'TECHNICAL' ||
          type == 'TECHNICAL_SKILL';
    }).toList();

    if (catalog.isEmpty) {
      _showMessage(
        'لا توجد مهارات متاحة من نوع $expectedType.',
      );
      return;
    }

    String? selectedId;
    double level = 50;

    final result =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, update) {
            return AlertDialog(
              title: Text(
                soft
                    ? 'إضافة مهارة شخصية'
                    : 'إضافة مهارة تقنية',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'المهارة',
                    ),
                    items: catalog.map((skill) {
                      return DropdownMenuItem<String>(
                        value: _text(skill['id']),
                        child: Text(
                          _text(skill['name']),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      update(() {
                        selectedId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'المستوى: ${level.round()}%',
                  ),
                  Slider(
                    value: level,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (value) {
                      update(() => level = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: selectedId == null
                      ? null
                      : () {
                          final skill =
                              catalog.firstWhere(
                            (item) =>
                                _text(item['id']) ==
                                selectedId,
                          );

                          Navigator.pop(dialogContext, {
                            'id': selectedId,
                            'name': skill['name'],
                            'level': level.round(),
                          });
                        },
                  child: const Text('إضافة'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      final items =
          soft ? _softSkills : _technicalSkills;

      items.removeWhere(
        (item) =>
            _text(item['id']) ==
            _text(result['id']),
      );

      items.add(result);
    });
  }

  Future<void> _openCertificateEditor({
    int? index,
  }) async {
    final existing =
        index == null ? null : _certificates[index];

    final result =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return _CertificateEditorDialog(
          existing: existing,
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      if (index == null) {
        _certificates.add(result);
      } else {
        _certificates[index] = result;
      }
    });
  }

  Future<void> _openProjectEditor({
    int? index,
  }) async {
    final existing =
        index == null ? null : _projects[index];

    final result =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return _ProjectEditorDialog(
          existing: existing,
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      if (index == null) {
        _projects.add(result);
      } else {
        _projects[index] = result;
      }
    });
  }

  Future<bool> _confirmDelete(
    String title,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: Text(
            'هل تريد حذف "$title" من الملف الشخصي؟',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'حذف',
                style: TextStyle(
                  color: MasarColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Widget _section(
    String title,
    List<Map<String, dynamic>> items, {
    required VoidCallback onAdd,
    required String Function(
      Map<String, dynamic>,
    ) label,
    required void Function(int) onRemove,
    void Function(int)? onEdit,
    String? emptyMessage,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'إضافة',
                  onPressed: onAdd,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: MasarColors.primaryGreen,
                  ),
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Text(
                  emptyMessage ??
                      'لم تتم إضافة عناصر بعد.',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color:
                        MasarColors.textSecondary,
                  ),
                ),
              ),
            ...List.generate(items.length, (index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  label(items[index]),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: onEdit == null
                    ? null
                    : () => onEdit(index),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        tooltip: 'تعديل',
                        onPressed: () =>
                            onEdit(index),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color:
                              MasarColors.primaryBlue,
                        ),
                      ),
                    IconButton(
                      tooltip: 'حذف',
                      onPressed: () async {
                        final confirmed =
                            await _confirmDelete(
                          label(items[index]),
                        );

                        if (!confirmed || !mounted) {
                          return;
                        }

                        setState(() {
                          onRemove(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: MasarColors.error,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

 Widget _certificateSection() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.workspace_premium_outlined,
                color: MasarColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'الشهادات المهنية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'إضافة شهادة',
                onPressed: _openCertificateEditor,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: MasarColors.primaryGreen,
                ),
              ),
            ],
          ),

          if (_certificates.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'أضف شهاداتك المهنية لإبراز إنجازاتك ومهاراتك.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: MasarColors.textSecondary,
                ),
              ),
            ),

          ...List.generate(_certificates.length, (index) {
            final certificate = _certificates[index];

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MasarColors.lightBlue,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: MasarColors.primaryBlue,
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _text(certificate['title']),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _text(certificate['issuer']),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: MasarColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      tooltip: 'تعديل الشهادة',
                      onPressed: () {
                        _openCertificateEditor(index: index);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: MasarColors.primaryBlue,
                      ),
                    ),

                    IconButton(
                      tooltip: 'حذف الشهادة',
                      onPressed: () async {
                        final confirmed = await _confirmDelete(
                          _text(certificate['title']),
                        );

                        if (!confirmed || !mounted) return;

                        setState(() {
                          _certificates.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: MasarColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final academicYears = {
      ...MasarMockData.academicYears,
      if (_selectedAcademicYear != null &&
          _selectedAcademicYear!.isNotEmpty)
        _selectedAcademicYear!,
    }.toList();

    final programIds = _programs
        .map((item) => _text(item['id']))
        .toList();

    final pathIds = _careerPaths
        .map((item) => _text(item['id']))
        .toList();

    return Scaffold(
      backgroundColor: MasarColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_right,
            size: 30,
            color: MasarColors.darkBlue,
          ),
        ),
        title: const Text(
          'تعديل الملف الشخصي',
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text(
                            'إعادة المحاولة',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'الاسم الكامل بالعربي',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'أدخل الاسم الكامل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller:
                              _nameEnController,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'الاسم بالإنجليزي',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'أدخل الاسم بالإنجليزي';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _readOnlyField(
                          'الرقم الجامعي',
                          _text(_profile[
                              'studentNumber']),
                        ),
                        const SizedBox(height: 16),
                        _readOnlyField(
                          'البريد الإلكتروني',
                          _text(_profile['email']),
                        ),
                        const SizedBox(height: 16),
                        _readOnlyField(
                          'الجامعة',
                          _text(_profile['university']),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _validSelection(
                            _selectedProgramId,
                            programIds,
                          ),
                          decoration:
                              const InputDecoration(
                            labelText: 'التخصص',
                          ),
                          items:
                              _programs.map((program) {
                            return DropdownMenuItem<
                                String>(
                              value: _text(
                                  program['id']),
                              child: Text(
                                _text(
                                    program['name']),
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedProgramId =
                                  value;
                            });
                          },
                          validator: (value) =>
                              value == null
                                  ? 'اختر التخصص'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _validSelection(
                            _selectedAcademicYear,
                            academicYears,
                          ),
                          decoration:
                              const InputDecoration(
                            labelText:
                                'السنة الدراسية',
                          ),
                          items:
                              academicYears.map((year) {
                            return DropdownMenuItem<
                                String>(
                              value: year,
                              child: Text(year),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAcademicYear =
                                  value;
                            });
                          },
                          validator: (value) =>
                              value == null
                                  ? 'اختر السنة الدراسية'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _validSelection(
                            _selectedCareerPathId,
                            pathIds,
                          ),
                          decoration:
                              const InputDecoration(
                            labelText:
                                'المسار المهني',
                          ),
                          items:
                              _careerPaths.map((path) {
                            return DropdownMenuItem<
                                String>(
                              value:
                                  _text(path['id']),
                              child: Text(
                                _text(path['title']),
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCareerPathId =
                                  value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        _section(
                          'المهارات التقنية',
                          _technicalSkills,
                          onAdd: () =>
                              _addSkill(soft: false),
                          label: (item) =>
                              '${_text(item['name'])} '
                              '(${_text(item['level'])}%)',
                          onRemove: (index) =>
                              _technicalSkills
                                  .removeAt(index),
                        ),
                        const SizedBox(height: 12),
                        _section(
                          'المهارات الشخصية',
                          _softSkills,
                          onAdd: () =>
                              _addSkill(soft: true),
                          label: (item) =>
                              '${_text(item['name'])} '
                              '(${_text(item['level'])}%)',
                          onRemove: (index) =>
                              _softSkills
                                  .removeAt(index),
                        ),
                        const SizedBox(height: 12),
                        _certificateSection(),
                        const SizedBox(height: 12),
                        _section(
                          'المشاريع',
                          _projects,
                          onAdd: _openProjectEditor,
                          onEdit: (index) =>
                              _openProjectEditor(
                            index: index,
                          ),
                          label: (item) =>
                              _text(item['name']),
                          onRemove: (index) =>
                              _projects
                                  .removeAt(index),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saving
                                ? null
                                : _saveChanges,
                            child: _saving
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'حفظ التغييرات',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _readOnlyField(
    String label,
    String value,
  ) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'غير متوفر حاليًا',
      ),
    );
  }
}

class _CertificateEditorDialog extends StatefulWidget {
  final Map<String, dynamic>? existing;

  const _CertificateEditorDialog({
    this.existing,
  });

  @override
  State<_CertificateEditorDialog> createState() =>
      _CertificateEditorDialogState();
}

class _CertificateEditorDialogState
    extends State<_CertificateEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _issuerController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.existing?['title']?.toString() ?? '',
    );

    _issuerController = TextEditingController(
      text: widget.existing?['issuer']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context, {
      'id': widget.existing?['id'],
      'title': _titleController.text.trim(),
      'issuer': _issuerController.text.trim(),
      'date': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        8,
      ),
      title: Row(
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            color: MasarColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.existing == null
                  ? 'إضافة شهادة مهنية'
                  : 'تعديل شهادة مهنية',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'أضف شهاداتك المهنية إلى ملفك الشخصي.',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: MasarColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الشهادة *',
                    hintText: 'مثال: Python Essentials 1',
                    prefixIcon: Icon(
                      Icons.workspace_premium_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'أدخل اسم الشهادة';
                    }

                    if (value.trim().length > 200) {
                      return 'اسم الشهادة طويل جدًا';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _issuerController,
                  decoration: const InputDecoration(
                    labelText: 'الجهة المانحة *',
                    hintText: 'مثال: Cisco Networking Academy',
                    prefixIcon: Icon(
                      Icons.business_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'أدخل الجهة المانحة';
                    }

                    if (value.trim().length > 200) {
                      return 'اسم الجهة المانحة طويل جدًا';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),

        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_outlined),
          label: Text(
            widget.existing == null
                ? 'إضافة الشهادة'
                : 'حفظ التعديل',
          ),
        ),
      ],
    );
  }
}


class _ProjectEditorDialog extends StatefulWidget {
  final Map<String, dynamic>? existing;

  const _ProjectEditorDialog({
    this.existing,
  });

  @override
  State<_ProjectEditorDialog> createState() =>
      _ProjectEditorDialogState();
}

class _ProjectEditorDialogState
    extends State<_ProjectEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController
      _descriptionController;
  late final TextEditingController _githubController;
  late final TextEditingController
      _technologiesController;

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;

    _nameController = TextEditingController(
      text: existing?['name']?.toString() ?? '',
    );

    _descriptionController = TextEditingController(
      text: existing?['description']?.toString() ?? '',
    );

    _githubController = TextEditingController(
      text: existing?['githubUrl']?.toString() ?? '',
    );

    final technologies =
        existing?['technologies'];

    _technologiesController = TextEditingController(
      text: technologies is List
          ? technologies.join(', ')
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();
    _technologiesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context, {
      'id': widget.existing?['id'],
      'name': _nameController.text.trim(),
      'description':
          _descriptionController.text.trim(),
      'githubUrl': _githubController.text.trim(),
      'technologies': _technologiesController.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null
            ? 'إضافة مشروع'
            : 'تعديل المشروع',
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المشروع',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'أدخل اسم المشروع';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller:
                      _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'وصف المشروع',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'أدخل وصف المشروع';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _githubController,
                  decoration: const InputDecoration(
                    labelText:
                        'رابط GitHub (اختياري)',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';

                    if (text.isEmpty) return null;

                    final uri = Uri.tryParse(text);

                    if (uri == null ||
                        uri.scheme != 'https' ||
                        uri.host != 'github.com') {
                      return 'أدخل رابط GitHub صحيحًا';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller:
                      _technologiesController,
                  decoration: const InputDecoration(
                    labelText: 'التقنيات المستخدمة',
                    hintText:
                        'Flutter, Python, Oracle',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('حفظ المشروع'),
        ),
      ],
    );
  }
}
