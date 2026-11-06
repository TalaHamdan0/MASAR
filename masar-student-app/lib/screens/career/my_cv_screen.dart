import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/models/student_model.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/profile_service.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';
import '../auth/complete_profile_screen.dart';

class MyCvScreen extends StatefulWidget {
  const MyCvScreen({super.key});

  @override
  State<MyCvScreen> createState() => _MyCvScreenState();
}

class _MyCvScreenState extends State<MyCvScreen> {
  Student? _student;
  bool _loading = true;
  bool _savingPdf = false;
  String? _error;

  static const Map<String, String> _translations = {
    'جامعة العلوم الإسلامية العالمية':
        'The World Islamic Sciences and Education University',
    'علم الحاسوب': 'Computer Science',
    'علوم الحاسوب': 'Computer Science',
    'هندسة البرمجيات': 'Software Engineering',
    'نظم شبكات الحاسوب': 'Computer Network Systems',
    'أمن وسرية المعلومات والشبكات':
        'Information and Network Security',
    'السنة الأولى': 'First Year',
    'السنة الثانية': 'Second Year',
    'السنة الثالثة': 'Third Year',
    'السنة الرابعة': 'Fourth Year',
    'تطوير تطبيقات الموبايل': 'Mobile Application Development',
    'تطوير الواجهات الأمامية': 'Front-End Development',
    'تطوير الباكند': 'Back-End Development',
    'تطوير الويب المتكامل': 'Full-Stack Web Development',
    'تحليل البيانات': 'Data Analysis',
    'علم البيانات': 'Data Science',
    'الذكاء الاصطناعي وتعلم الآلة':
        'Artificial Intelligence and Machine Learning',
    'الأمن السيبراني': 'Cybersecurity',
    'الشبكات': 'Networking',
    'الحوسبة السحابية وDevOps': 'Cloud Computing and DevOps',
    'ضمان الجودة واختبار البرمجيات':
        'Quality Assurance and Software Testing',
    'تصميم UI/UX': 'UI/UX Design',
    'إدارة قواعد البيانات': 'Database Administration',
    'الإحصاء': 'Statistics',
    'التواصل': 'Communication',
    'العمل الجماعي': 'Teamwork',
    'حل المشكلات': 'Problem Solving',
    'التفكير النقدي': 'Critical Thinking',
    'إدارة الوقت': 'Time Management',
    'القيادة': 'Leadership',
    'التكيف': 'Adaptability',
    'الإبداع': 'Creativity',
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await ProfileService.getMyProfile();

      if (!mounted) return;

      final student = AuthSession.updateProfile(data);

      MasarMockData.currentStudent = student;
      MasarMockData.student = student;

      setState(() {
        _student = student;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  String? _careerPathTitle(Student student) {
    final id = student.careerPathId;

    if (id == null || id.trim().isEmpty) {
      return null;
    }

    for (final path in MasarMockData.careerPaths) {
      if (path.id == id) {
        return path.title;
      }
    }

    return null;
  }

  Future<void> _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CompleteProfileScreen(),
      ),
    );

    if (mounted) {
      await _loadProfile();
    }
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

  String _englishValue(String value) {
    final trimmed = value.trim();
    return _translations[trimmed] ?? trimmed;
  }

  Map<String, String> _prepareEnglishFields(Student student) {
    final values = <String, String>{};

    void add(String key, String label, String original) {
      final text = _englishValue(original);

      if (!_isEnglishText(text)) {
        throw FormatException(
          '$label يحتاج بيانات إنجليزية. '
          'يرجى تعديله من بيانات الملف قبل إنشاء السيرة الذاتية.',
        );
      }

      values[key] = text;
    }

    final name = student.nameEn.trim();

    if (name.isEmpty) {
      throw const FormatException(
        'يرجى إضافة الاسم باللغة الإنجليزية من تعديل بيانات الملف '
        'وحفظه مرة واحدة.',
      );
    }

    if (!RegExp(r"^[A-Za-z][A-Za-z .'-]*$").hasMatch(name) ||
        RegExp(r'[A-Za-z]').allMatches(name).length < 2 ||
        name.length > 200) {
      throw const FormatException(
        'يرجى تصحيح الاسم الإنجليزي من بيانات الملف.',
      );
    }

    values['name'] = name;

    add('email', 'البريد', student.email);
    add('university', 'الجامعة', student.university);
    add('major', 'التخصص', student.major);
    add(
      'academicYear',
      'السنة الدراسية',
      student.academicYear,
    );

    final careerPath = _careerPathTitle(student);

    if (careerPath != null) {
      add('careerPath', 'المسار المهني', careerPath);
    }

    for (var i = 0; i < student.skills.length; i++) {
      add(
        'skill_$i',
        'المهارة ${student.skills[i].name}',
        student.skills[i].name,
      );
    }

    for (var i = 0; i < student.softSkills.length; i++) {
      add(
        'softSkill_$i',
        'المهارة ${student.softSkills[i].name}',
        student.softSkills[i].name,
      );
    }

    for (var i = 0; i < student.certificates.length; i++) {
      final item = student.certificates[i];

      add(
        'certificateTitle_$i',
        'اسم الشهادة ${i + 1}',
        item.title,
      );

      add(
        'certificateIssuer_$i',
        'جهة الشهادة ${i + 1}',
        item.issuer,
      );

      add(
        'certificateDate_$i',
        'تاريخ الشهادة ${i + 1}',
        item.date,
      );
    }

    for (var i = 0; i < student.projects.length; i++) {
      final item = student.projects[i];

      add(
        'projectName_$i',
        'اسم المشروع ${i + 1}',
        item.name,
      );

      add(
        'projectDescription_$i',
        'وصف المشروع ${i + 1}',
        item.description,
      );

      add(
        'github_$i',
        'رابط المشروع ${i + 1}',
        item.githubUrl ?? '',
      );

      for (var j = 0; j < item.technologies.length; j++) {
        add(
          'technology_${i}_$j',
          'تقنيات المشروع ${i + 1}',
          item.technologies[j],
        );
      }
    }

    return values;
  }

  String _pdfFilename(String name) {
    final safeName = name
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    return '${safeName}_CV.pdf';
  }

  pw.Widget _pdfTitle(String title) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(
        top: 18,
        bottom: 8,
      ),
      padding: const pw.EdgeInsets.only(bottom: 5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.blueGrey300,
          ),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        '$label: ${value.isEmpty ? "Not provided" : value}',
        style: const pw.TextStyle(fontSize: 11),
      ),
    );
  }

  void _addPdfParagraph(
    List<pw.Widget> content,
    String text,
  ) {
    final words = text.split(RegExp(r'\s+'));
    var chunk = '';

    void appendChunk() {
      if (chunk.isEmpty) return;

      content.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Text(
            chunk,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      );

      chunk = '';
    }

    for (final word in words) {
      if (chunk.isNotEmpty &&
          chunk.length + word.length > 350) {
        appendChunk();
      }

      chunk = chunk.isEmpty ? word : '$chunk $word';
    }

    appendChunk();
  }

  Future<void> _saveCvAsPdf() async {
    final student = _student;

    if (student == null || _savingPdf || _loading) {
      return;
    }

    setState(() {
      _savingPdf = true;
    });

    try {
      final english = _prepareEnglishFields(student);

      final regularFont =
          await PdfGoogleFonts.notoSansRegular();

      final boldFont =
          await PdfGoogleFonts.notoSansBold();

      if (!mounted) return;

      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          maxPages: 100,
          margin: const pw.EdgeInsets.all(36),
          textDirection: pw.TextDirection.ltr,
          build: (_) {
            final content = <pw.Widget>[
              pw.Text(
                english['name']!,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                english['email']!,
                style: const pw.TextStyle(
                  fontSize: 11,
                ),
              ),
              _pdfTitle('EDUCATION'),
              _pdfLine(
                'University',
                english['university']!,
              ),
              _pdfLine(
                'Major',
                english['major']!,
              ),
              _pdfLine(
                'Academic Year',
                english['academicYear']!,
              ),
            ];

            final careerPath = english['careerPath'];

            if (careerPath != null &&
                careerPath.isNotEmpty) {
              content.addAll([
                _pdfTitle('CAREER INTEREST'),
                pw.Text(careerPath),
              ]);
            }

            if (student.skills.isNotEmpty) {
              content.add(
                _pdfTitle('TECHNICAL SKILLS'),
              );

              content.add(
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    for (
                      var i = 0;
                      i < student.skills.length;
                      i++
                    )
                      pw.Text(
                        english['skill_$i']!,
                        style: const pw.TextStyle(
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              );
            }

            if (student.softSkills.isNotEmpty) {
              content.add(
                _pdfTitle('SOFT SKILLS'),
              );

              content.add(
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    for (
                      var i = 0;
                      i < student.softSkills.length;
                      i++
                    )
                      pw.Text(
                        english['softSkill_$i']!,
                        style: const pw.TextStyle(
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              );
            }

            if (student.certificates.isNotEmpty) {
              content.add(
                _pdfTitle('CERTIFICATES'),
              );

              for (
                var i = 0;
                i < student.certificates.length;
                i++
              ) {
                content.addAll([
                  pw.Text(
                    english['certificateTitle_$i']!,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    english['certificateIssuer_$i']!,
                    style: const pw.TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ]);

                final date =
                    english['certificateDate_$i']!;

                if (date.isNotEmpty) {
                  content.add(
                    pw.Text(
                      date,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  );
                }

                content.add(
                  pw.SizedBox(height: 12),
                );
              }
            }

            if (student.projects.isNotEmpty) {
              content.add(
                _pdfTitle('PROJECTS'),
              );

              for (
                var i = 0;
                i < student.projects.length;
                i++
              ) {
                final project = student.projects[i];

                content.addAll([
                  pw.Text(
                    english['projectName_$i']!,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                ]);

                _addPdfParagraph(
                  content,
                  english['projectDescription_$i']!,
                );

                if (project.technologies.isNotEmpty) {
                  content.add(
                    pw.SizedBox(height: 4),
                  );

                  content.add(
                    pw.Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: [
                        for (
                          var j = 0;
                          j < project.technologies.length;
                          j++
                        )
                          pw.Text(
                            english['technology_${i}_$j']!,
                            style: const pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  );
                }

                final githubUrl = english['github_$i']!;

                if (githubUrl.isNotEmpty) {
                  content.addAll([
                    pw.SizedBox(height: 5),
                    pw.Text(
                      githubUrl,
                      style: const pw.TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ]);
                }

                content.add(
                  pw.SizedBox(height: 14),
                );
              }
            }

            return content;
          },
          footer: (pdfContext) {
            return pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                '${pdfContext.pageNumber} / '
                '${pdfContext.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            );
          },
        ),
      );

      final bytes = await pdf.save();

      if (!mounted) return;

      final result = await Printing.sharePdf(
        bytes: bytes,
        filename: _pdfFilename(student.nameEn),
      );

      if (!mounted) return;

      if (!result) {
        _showMessage(
          'لم يتم تأكيد حفظ الملف.',
        );
      }
    } on FormatException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } catch (error) {
      debugPrint('MASAR PDF: $error');

      if (mounted) {
        _showMessage(
          'تعذر تجهيز ملف PDF. '
          'يرجى التحقق من اتصال الإنترنت لتحميل الخط '
          'ثم إعادة المحاولة.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _savingPdf = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasarColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('الملف المهني'),
        actions: [
          IconButton(
            onPressed: _loading || _savingPdf
                ? null
                : _loadProfile,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث البيانات',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 3,
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
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

    final student = _student;

    if (student == null) {
      return const Center(
        child: Text('لا توجد بيانات لعرضها.'),
      );
    }

    final careerPath = _careerPathTitle(student);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 390,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _decoration(22),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor:
                          MasarColors.lightBlue,
                      child: Icon(
                        Icons.person_outline,
                        size: 38,
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      student.nameEn.trim().isNotEmpty
                          ? student.nameEn
                          : student.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (careerPath != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        careerPath,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MasarColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      student.email,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed:
                    _savingPdf ? null : _editProfile,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'إضافة أو تعديل بيانات الملف',
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  backgroundColor:
                      MasarColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _section(
                'المعلومات الشخصية',
                Icons.person_outline,
                Column(
                  children: [
                    _info(
                      'الاسم',
                      student.nameEn,
                    ),
                    _info(
                      'البريد',
                      student.email,
                    ),
                  ],
                ),
              ),
              _section(
                'البيانات الأكاديمية',
                Icons.school_outlined,
                Column(
                  children: [
                    _info(
                      'الجامعة',
                      student.university,
                    ),
                    _info(
                      'التخصص',
                      student.major,
                    ),
                    _info(
                      'السنة الدراسية',
                      student.academicYear,
                    ),
                  ],
                ),
              ),
              if (careerPath != null)
                _section(
                  'المسار المهني',
                  Icons.route_outlined,
                  Text(careerPath),
                ),
              _section(
                'المهارات التقنية',
                Icons.code_outlined,
                _skills(
                  student.skills
                      .map((item) => item.name)
                      .toList(),
                ),
              ),
              _section(
                'المهارات الشخصية',
                Icons.psychology_outlined,
                _skills(
                  student.softSkills
                      .map((item) => item.name)
                      .toList(),
                ),
              ),
              _section(
                'الشهادات',
                Icons.workspace_premium_outlined,
                student.certificates.isEmpty
                    ? const Text(
                        'لم تتم إضافة شهادات.',
                      )
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          for (
                            final item
                                in student.certificates
                          )
                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(item.issuer),
                                  if (item.date.isNotEmpty)
                                    Text(item.date),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
              _section(
                'المشاريع',
                Icons.folder_outlined,
                student.projects.isEmpty
                    ? const Text(
                        'لم تتم إضافة مشاريع.',
                      )
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          for (
                            final item in student.projects
                          )
                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 16,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(item.description),
                                  if (
                                    item.technologies
                                        .isNotEmpty
                                  ) ...[
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    _skills(
                                      item.technologies,
                                    ),
                                  ],
                                  if (
                                    item.githubUrl != null &&
                                    item.githubUrl!.isNotEmpty
                                  ) ...[
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SelectableText(
                                      item.githubUrl!,
                                      textDirection:
                                          TextDirection.ltr,
                                      style:
                                          const TextStyle(
                                        color: MasarColors
                                            .primaryBlue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed:
                    _savingPdf ? null : _saveCvAsPdf,
                icon: _savingPdf
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.picture_as_pdf_outlined,
                      ),
                label: Text(
                  _savingPdf
                      ? 'جارٍ تجهيز الملف...'
                      : 'إنشاء السيرة الذاتية',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  foregroundColor:
                      MasarColors.primaryBlue,
                  side: const BorderSide(
                    color: MasarColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(double radius) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: MasarColors.border,
      ),
    );
  }

  Widget _section(
    String title,
    IconData icon,
    Widget child,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),
      decoration: _decoration(18),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: MasarColors.primaryBlue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: MasarColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'غير محدد' : value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skills(List<String> names) {
    if (names.isEmpty) {
      return const Text(
        'لم تتم إضافة مهارات.',
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: names.map((name) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: MasarColors.lightBlue,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: MasarColors.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}