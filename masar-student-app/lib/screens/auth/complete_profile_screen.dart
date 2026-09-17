import 'package:flutter/material.dart';

import '../../core/models/career_path_model.dart';
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

  // =========================
  // Form
  // =========================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // =========================
  // Selected Values
  // =========================

  String? _selectedMajor;
  String? _selectedAcademicYear;
  String? _selectedCareerPath;

  // =========================
  // Selected Skills
  // =========================

  final List<String> _selectedSkills = [];

  // =========================
  // GPA
  // =========================

  final TextEditingController _gpaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadStudentData();
  }

  // =========================
  // Load Existing Student
  // =========================

  void _loadStudentData() {
    final Student? student =
        MasarMockData.currentStudent;

    if (student == null) {
      return;
    }

    if (student.major.isNotEmpty) {
      _selectedMajor = student.major;
    }

    if (student.academicYear.isNotEmpty) {
      _selectedAcademicYear =
          student.academicYear;
    }

    if (student.careerPathId != null) {
      _selectedCareerPath =
          student.careerPathId;
    }

    _gpaController.text =
        student.gpa;
  }

  @override
  void dispose() {
    _gpaController.dispose();

    super.dispose();
  }

  // =========================
  // Save Profile
  // =========================

  void _saveProfile() {
    // Check required fields.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Student? oldStudent =
        MasarMockData.currentStudent;

    if (oldStudent == null) {
      return;
    }

    // Convert selected skill names
    // into Skill objects.
    final List<Skill> selectedSkills =
        _selectedSkills.map((skillName) {
      return Skill(
        id: skillName
            .toLowerCase()
            .replaceAll(' ', '_'),

        name: skillName,

        // The real level will be
        // determined by SkillMirror.
        level: 0,

        status: 'Not Assessed',
      );
    }).toList();

    // Create an updated Student.
    final Student updatedStudent = Student(
      id: oldStudent.id,

      name: oldStudent.name,

      major: _selectedMajor!,

      university:
          oldStudent.university,

      academicYear:
          _selectedAcademicYear!,

      email: oldStudent.email,

      // Optional.
      careerPathId:
          _selectedCareerPath,

      // Optional.
      gpa:
          _gpaController.text.trim(),

      // Can be empty.
      skills:
          selectedSkills,

      // Not added yet.
      softSkills:
          oldStudent.softSkills,

      // Certificates are added later.
      //certificates:
      //    oldStudent.certificates,
      certificates: MasarMockData.certificates,
    );

    // Save the updated student.
    MasarMockData.currentStudent =
        updatedStudent;

    // Go to Home.
    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  // =========================
  // Skill Selection
  // =========================

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          MasarColors.background,

      body: SafeArea(
        child: Directionality(
          textDirection:
              TextDirection.rtl,

          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 32,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [

                  // =========================
                  // Title
                  // =========================

                  const Text(
                    'أكمل ملفك الشخصي',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'بعض المعلومات تساعدنا على تخصيص تجربتك في مسار',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w500,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Required fields explanation
                  const Text(
                    'الحقول المعلّمة بـ * مطلوبة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // Academic Information
                  // =========================

                  const Text(
                    'المعلومات الأكاديمية',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Major

                  const _RequiredLabel(
                    text: 'التخصص',
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _selectedMajor,

                    decoration:
                        const InputDecoration(
                      hintText:
                          'اختر تخصصك',

                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color:
                            MasarColors
                                .primaryBlue,
                      ),
                    ),

                    items:
                        MasarMockData.majors
                            .map(
                      (major) {
                        return DropdownMenuItem<
                            String>(
                          value: major,

                          child: Text(
                            major,
                            style:
                                const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ).toList(),

                    onChanged:
                        (value) {
                      setState(() {
                        _selectedMajor =
                            value;
                      });
                    },

                    validator:
                        (value) {
                      if (value ==
                              null ||
                          value.isEmpty) {
                        return 'يرجى اختيار التخصص';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Academic Year

                  const _RequiredLabel(
                    text: 'السنة الدراسية',
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value:
                        _selectedAcademicYear,

                    decoration:
                        const InputDecoration(
                      hintText:
                          'اختر السنة الدراسية',

                      prefixIcon: Icon(
                        Icons
                            .calendar_month_outlined,
                        color:
                            MasarColors
                                .primaryBlue,
                      ),
                    ),

                    items:
                        MasarMockData
                            .academicYears
                            .map(
                      (year) {
                        return DropdownMenuItem<
                            String>(
                          value: year,

                          child:
                              Text(
                            year,
                            style:
                                const TextStyle(
                              fontSize:
                                  14,
                            ),
                          ),
                        );
                      },
                    ).toList(),

                    onChanged:
                        (value) {
                      setState(() {
                        _selectedAcademicYear =
                            value;
                      });
                    },

                    validator:
                        (value) {
                      if (value ==
                              null ||
                          value.isEmpty) {
                        return 'يرجى اختيار السنة الدراسية';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // GPA - Optional

                  const Text(
                    'المعدل التراكمي',
                    textAlign:
                        TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                        _gpaController,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    textDirection:
                        TextDirection.rtl,

                    style:
                        const TextStyle(
                      fontSize: 15,
                      color:
                          MasarColors
                              .textPrimary,
                    ),

                    decoration:
                        const InputDecoration(
                      hintText:
                          'أدخل معدلك التراكمي',

                      prefixIcon:
                          Icon(
                        Icons
                            .analytics_outlined,
                        color:
                            MasarColors
                                .primaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // Career Information
                  // =========================

                  const Text(
                    'المعلومات المهنية',
                    textAlign:
                        TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Career Path - Optional

                  const Text(
                    'المسار المهني',
                    textAlign:
                        TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value:
                        _selectedCareerPath,

                    decoration:
                        const InputDecoration(
                      hintText:
                          'اختر المسار الذي تهتم به',

                      prefixIcon:
                          Icon(
                        Icons.work_outline,
                        color:
                            MasarColors
                                .primaryGreen,
                      ),
                    ),

                    items:
                        MasarMockData
                            .careerPaths
                            .map(
                      (CareerPath path) {
                        return DropdownMenuItem<
                            String>(
                          value:
                              path.id,

                          child:
                              Text(
                            path.title,
                            style:
                                const TextStyle(
                              fontSize:
                                  14,
                            ),
                          ),
                        );
                      },
                    ).toList(),

                    onChanged:
                        (value) {
                      setState(() {
                        _selectedCareerPath =
                            value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Current Skills - Optional

                  const Text(
                    'مهاراتك الحالية',
                    textAlign:
                        TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'اختر المهارات التي تمتلكها حاليًا',
                    textAlign:
                        TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          MasarColors
                              .textSecondary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children:
                        MasarMockData
                            .skills
                            .map(
                      (skill) {
                        final bool
                            isSelected =
                            _selectedSkills
                                .contains(
                          skill.name,
                        );

                        return FilterChip(
                          label:
                              Text(
                            skill.name,
                            style:
                                TextStyle(
                              fontSize:
                                  13,
                              fontWeight:
                                  FontWeight
                                      .w600,
                              color: isSelected
                                  ? Colors
                                      .white
                                  : MasarColors
                                      .darkBlue,
                            ),
                          ),

                          selected:
                              isSelected,

                          selectedColor:
                              MasarColors
                                  .primaryBlue,

                          backgroundColor:
                              MasarColors
                                  .lightBlue,

                          checkmarkColor:
                              Colors
                                  .white,

                          onSelected:
                              (_) {
                            _toggleSkill(
                              skill.name,
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),

                  const SizedBox(height: 34),

                  // =========================
                  // Save Button
                  // =========================

                  SizedBox(
                    height: 54,

                    child:
                        FilledButton(
                      onPressed:
                          _saveProfile,

                      child:
                          const Text(
                        'حفظ ومتابعة',
                        style:
                            TextStyle(
                          fontSize:
                              16,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ======================================================
// Required Field Label
// ======================================================

class _RequiredLabel
    extends StatelessWidget {
  final String text;

  const _RequiredLabel({
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return RichText(
      textAlign:
          TextAlign.right,

      text: TextSpan(
        children: [

          TextSpan(
            text: text,

            style:
                const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
              color:
                  MasarColors.darkBlue,
            ),
          ),

          const TextSpan(
            text: ' *',

            style:
                TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
              color:
                  MasarColors.error,
            ),
          ),
        ],
      ),
    );
  }
}