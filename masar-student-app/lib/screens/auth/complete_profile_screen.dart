import 'package:flutter/material.dart';

import '../../core/models/certificate_model.dart';
import '../../core/models/project_model.dart';
import '../../core/models/skill_model.dart';
import '../../core/models/student_model.dart';
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
  String? _selectedMajor;
  String? _selectedAcademicYear;

  final List<String> _selectedSkills = [];
  final List<Certificate> _selectedCertificates = [];
  final List<Project> _selectedProjects = [];

  final TextEditingController _gpaController =
      TextEditingController();

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

  // ============================================================
  // LOAD CURRENT STUDENT DATA
  // ============================================================

  void _loadStudentData() {
    final student = MasarMockData.currentStudent;

    if (student == null) return;

    _selectedMajor = student.major;
    _selectedAcademicYear = student.academicYear;

    _gpaController.text = student.gpa;

    _selectedSkills.clear();

    for (final skill in student.skills) {
      _selectedSkills.add(skill.name);
    }

    _selectedCertificates
      ..clear()
      ..addAll(student.certificates);

    _selectedProjects
      ..clear()
      ..addAll(student.projects);
  }

  // ============================================================
  // ADD SKILL
  // ============================================================

  void _showAddSkillDialog() {
    String? selectedSkill;

    final availableSkills = MasarMockData.skills
        .where(
          (skill) => !_selectedSkills.contains(skill.name),
        )
        .toList();

    if (availableSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تمت إضافة جميع المهارات المتاحة.',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
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
                      Navigator.pop(context);
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
                              _selectedSkills.add(
                                selectedSkill!,
                              );
                            });

                            Navigator.pop(context);
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

  // ============================================================
  // ADD CERTIFICATE
  // ============================================================

  void _showAddCertificateDialog() {
    final titleController = TextEditingController();
    final issuerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الشهادة',
                    hintText: 'مثال: IBM Data Science',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: issuerController,
                  decoration: const InputDecoration(
                    labelText: 'الجهة المانحة',
                    hintText: 'مثال: IBM',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty ||
                      issuerController.text.trim().isEmpty) {
                    return;
                  }

                  setState(() {
                    _selectedCertificates.add(
                      Certificate(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        title: titleController.text.trim(),
                        issuer: issuerController.text.trim(),
                        date: '',
                      ),
                    );
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  'إضافة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ADD PROJECT
  // ============================================================

  void _showAddProjectDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final technologiesController = TextEditingController();
    final githubController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المشروع',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'وصف المشروع',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: technologiesController,
                    decoration: const InputDecoration(
                      labelText: 'التقنيات المستخدمة',
                      hintText: 'Python, SQL, Power BI',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: githubController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'GitHub Link (اختياري)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      descriptionController.text.trim().isEmpty) {
                    return;
                  }

                  final technologies = technologiesController
                      .text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  setState(() {
                    _selectedProjects.add(
                      Project(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        name: nameController.text.trim(),
                        description:
                            descriptionController.text.trim(),
                        technologies: technologies,
                        githubUrl:
                            githubController.text.trim().isEmpty
                                ? null
                                : githubController.text.trim(),
                      ),
                    );
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  'إضافة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  void _saveProfile() {
    if (_selectedMajor == null ||
        _selectedAcademicYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إكمال المعلومات الأكاديمية المطلوبة.',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      return;
    }

    final oldStudent = MasarMockData.currentStudent;

    if (oldStudent == null) return;

    final selectedSkillObjects = _selectedSkills.map((name) {
      final originalSkill = MasarMockData.skills.firstWhere(
        (skill) => skill.name == name,
      );

      return Skill(
        id: originalSkill.id,
        name: originalSkill.name,

        // المستوى لا يتم إدخاله من الطالب.
        // سيتم تقييمه لاحقًا من الاختبار.
        level: 0,

        status: 'Not Assessed',
      );
    }).toList();

    final updatedStudent = Student(
      id: oldStudent.id,
      name: oldStudent.name,
      major: _selectedMajor!,
      university: oldStudent.university,
      academicYear: _selectedAcademicYear!,
      email: oldStudent.email,

      // المسار يتم اختياره لاحقًا من Home.
      careerPathId: null,

      gpa: _gpaController.text.trim(),

      skills: selectedSkillObjects,

      softSkills: oldStudent.softSkills,

      certificates: _selectedCertificates,

      projects: _selectedProjects,
    );

    MasarMockData.currentStudent = updatedStudent;

    MasarMockData.isFirstLogin = false;

    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,

        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),

            child: Container(
              width: double.infinity,
              color: MasarColors.background,

              child: SafeArea(
                child: Column(
                  children: [
                    // ==================================================
                    // APP BAR
                    // ==================================================

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

                    // ==================================================
                    // CONTENT
                    // ==================================================

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

                            // ==================================================
                            // ACADEMIC INFORMATION
                            // ==================================================

                            _SectionTitle(
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
                              items: MasarMockData.majors
                                  .map(
                                    (major) =>
                                        DropdownMenuItem<String>(
                                      value: major,
                                      child: Text(
                                        major,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
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
                              items: MasarMockData.academicYears
                                  .map(
                                    (year) =>
                                        DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(
                                        year,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
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

                            // ==================================================
                            // SKILLS
                            // ==================================================

                            _SectionHeader(
                              title: 'مهاراتك الحالية',
                              icon: Icons.auto_awesome_outlined,
                              buttonText: 'إضافة مهارة',
                              onPressed: _showAddSkillDialog,
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              'أضف المهارات التي تمتلكها حاليًا. سيتم تقييم مستوى كل مهارة لاحقًا من خلال اختبار المسار المهني.',
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
                                children: _selectedSkills
                                    .map(
                                      (skill) => _SkillCard(
                                        skillName: skill,
                                        onDelete: () {
                                          setState(() {
                                            _selectedSkills
                                                .remove(skill);
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 28),

                            // ==================================================
                            // CERTIFICATES
                            // ==================================================

                            _SectionHeader(
                              title: 'الشهادات',
                              icon: Icons.workspace_premium_outlined,
                              buttonText: 'إضافة شهادة',
                              onPressed:
                                  _showAddCertificateDialog,
                            ),

                            const SizedBox(height: 12),

                            if (_selectedCertificates.isEmpty)
                              const _EmptySection(
                                icon:
                                    Icons.workspace_premium_outlined,
                                text: 'لم تتم إضافة أي شهادات بعد',
                              )
                            else
                              Column(
                                children: _selectedCertificates
                                    .map(
                                      (certificate) =>
                                          _CertificateCard(
                                        certificate: certificate,
                                        onDelete: () {
                                          setState(() {
                                            _selectedCertificates
                                                .remove(certificate);
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 28),

                            // ==================================================
                            // PROJECTS
                            // ==================================================

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
                                children: _selectedProjects
                                    .map(
                                      (project) => _ProjectCard(
                                        project: project,
                                        onDelete: () {
                                          setState(() {
                                            _selectedProjects
                                                .remove(project);
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 32),

                            // ==================================================
                            // SAVE BUTTON
                            // ==================================================

                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _saveProfile,
                                child: const Text(
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
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

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

// ============================================================
// SECTION HEADER WITH ADD BUTTON
// ============================================================

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

// ============================================================
// SKILL CARD
// ============================================================

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

// ============================================================
// CERTIFICATE CARD
// ============================================================

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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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

// ============================================================
// PROJECT CARD
// ============================================================

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
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                    children: project.technologies
                        .map(
                          (technology) => Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: MasarColors.lightBlue,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text(
                              technology,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 9,
                                color:
                                    MasarColors.primaryBlue,
                              ),
                            ),
                          ),
                        )
                        .toList(),
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

// ============================================================
// EMPTY SECTION
// ============================================================

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