import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';

class MyCvScreen extends StatelessWidget {
  const MyCvScreen({super.key});

  // ============================================================
  // Save CV as PDF - English Version
  // ============================================================

  Future<void> _saveCvAsPdf(BuildContext context) async {
    final student = MasarMockData.currentStudent;

    if (student == null) return;

    final careerPath = MasarMockData.selectedCareerPath;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(40),

        build: (context) => [
          // ======================================================
          // HEADER
          // ======================================================

          pw.Center(
            child: pw.Text(
              'CURRICULUM VITAE',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 8),

          pw.Center(
            child: pw.Text(
              'MASAR - Student Career Profile',
              style: const pw.TextStyle(
                fontSize: 11,
              ),
            ),
          ),

          pw.SizedBox(height: 25),

          // ======================================================
          // PERSONAL INFORMATION
          // ======================================================

          _pdfSectionTitle('PERSONAL INFORMATION'),

          pw.SizedBox(height: 8),

          _pdfInfoRow(
            'Name',
            _translateStudentName(student.name),
          ),

          _pdfInfoRow(
            'Email',
            student.email,
          ),

          pw.SizedBox(height: 18),

          // ======================================================
          // EDUCATION
          // ======================================================

          _pdfSectionTitle('EDUCATION'),

          pw.SizedBox(height: 8),

          _pdfInfoRow(
            'University',
            _translateUniversity(student.university),
          ),

          _pdfInfoRow(
            'Major',
            _translateMajor(student.major),
          ),

          _pdfInfoRow(
            'Academic Year',
            _translateAcademicYear(student.academicYear),
          ),

          _pdfInfoRow(
            'GPA',
            student.gpa,
          ),

          pw.SizedBox(height: 18),

          // ======================================================
          // CAREER PATH
          // ======================================================

          _pdfSectionTitle('CAREER PATH'),

          pw.SizedBox(height: 8),

          pw.Text(
            _translateCareerPath(careerPath.title),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 18),

          // ======================================================
          // TECHNICAL SKILLS
          // ======================================================

          _pdfSectionTitle('TECHNICAL SKILLS'),

          pw.SizedBox(height: 8),

          ...student.skills.map(
            (skill) => pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 5,
              ),
              child: pw.Text(
                '• ${skill.name} - ${skill.level}%',
                style: const pw.TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ),

          pw.SizedBox(height: 18),

          // ======================================================
          // SOFT SKILLS
          // ======================================================

          _pdfSectionTitle('SOFT SKILLS'),

          pw.SizedBox(height: 8),

          ...student.softSkills.map(
            (skill) => pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 5,
              ),
              child: pw.Text(
                '• ${_translateSoftSkill(skill.name)} - ${skill.level}%',
                style: const pw.TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ),

          pw.SizedBox(height: 18),

          // ======================================================
          // CERTIFICATES
          // ======================================================

          _pdfSectionTitle('CERTIFICATES'),

          pw.SizedBox(height: 8),

          if (student.certificates.isEmpty)
            pw.Text(
              'No certificates added.',
              style: const pw.TextStyle(
                fontSize: 11,
              ),
            ),

          ...student.certificates.map(
            (certificate) => pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 7,
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '• ${certificate.title}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 2),

                  pw.Text(
                    '  Issued by: ${certificate.issuer}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          pw.SizedBox(height: 18),

          // ======================================================
          // PROJECTS
          // ======================================================

          _pdfSectionTitle('PROJECTS'),

          pw.SizedBox(height: 8),

          if (student.projects.isEmpty)
            pw.Text(
              'No projects added.',
              style: const pw.TextStyle(
                fontSize: 11,
              ),
            ),

          ...student.projects.map(
            (project) => pw.Padding(
              padding: const pw.EdgeInsets.only(
                bottom: 10,
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '• ${project.name}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 3),

                  pw.Text(
                    project.description,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),

                  if (project.technologies.isNotEmpty) ...[
                    pw.SizedBox(height: 3),

                    pw.Text(
                      'Technologies: ${project.technologies.join(', ')}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async {
        return pdf.save();
      },
    );
  }

  // ============================================================
  // PDF Section Title
  // ============================================================

  pw.Widget _pdfSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(
        bottom: 6,
      ),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            width: 1,
          ),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 15,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // PDF Info Row
  // ============================================================

  pw.Widget _pdfInfoRow(
    String label,
    String value,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        bottom: 5,
      ),
      child: pw.Row(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Add To CV Bottom Sheet
  // ============================================================

  void _showAddToCvSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Add to CV',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _buildAddOption(
                  context,
                  Icons.psychology_outlined,
                  'Skill',
                ),

                _buildAddOption(
                  context,
                  Icons.workspace_premium_outlined,
                  'Certificate',
                ),

                _buildAddOption(
                  context,
                  Icons.school_outlined,
                  'Course',
                ),

                _buildAddOption(
                  context,
                  Icons.folder_outlined,
                  'Project',
                ),

                _buildAddOption(
                  context,
                  Icons.work_outline,
                  'Experience',
                ),

                _buildAddOption(
                  context,
                  Icons.menu_book_outlined,
                  'Education',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // Add Option
  // ============================================================

  Widget _buildAddOption(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: MasarColors.lightBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: MasarColors.primaryBlue,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),

      onTap: () async {
        Navigator.pop(context);

        if (title == 'Certificate' ||
            title == 'Course' ||
            title == 'Project' ||
            title == 'Experience') {
          await FilePicker.platform.pickFiles(
            allowMultiple: false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$title added to your CV',
              ),
            ),
          );
        }
      },
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final student = MasarMockData.currentStudent;
    final careerPath = MasarMockData.selectedCareerPath;

    if (student == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No student data available',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MasarColors.background,

      // ========================================================
      // App Bar
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My CV',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // Body
      // ========================================================

      body: Center(
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

                // ==================================================
                // CV HEADER
                // ==================================================

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(22),
                    border: Border.all(
                      color: MasarColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color:
                              MasarColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 38,
                          color:
                              MasarColors.primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        student.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        careerPath.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              MasarColors.primaryBlue,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        student.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // ADD TO CV
                // ==================================================

                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showAddToCvSheet(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                    ),
                    label: const Text(
                      'Add to CV',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          MasarColors.primaryBlue,
                      foregroundColor:
                          Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // PERSONAL INFORMATION
                // ==================================================

                _buildSectionCard(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Name',
                        student.name,
                      ),
                      _buildInfoRow(
                        'Email',
                        student.email,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // EDUCATION
                // ==================================================

                _buildSectionCard(
                  icon: Icons.school_outlined,
                  title: 'Education',
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'University',
                        student.university,
                      ),
                      _buildInfoRow(
                        'Major',
                        student.major,
                      ),
                      _buildInfoRow(
                        'Academic Year',
                        student.academicYear,
                      ),
                      _buildInfoRow(
                        'GPA',
                        student.gpa,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // CAREER PATH
                // ==================================================

                _buildSectionCard(
                  icon: Icons.route_outlined,
                  title: 'Career Path',
                  child: Text(
                    careerPath.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // TECHNICAL SKILLS
                // ==================================================

                _buildSectionCard(
                  icon: Icons.code_outlined,
                  title: 'Technical Skills',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: student.skills
                        .map(
                          (skill) =>
                              _buildSkillChip(
                            skill.name,
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // SOFT SKILLS
                // ==================================================

                _buildSectionCard(
                  icon:
                      Icons.psychology_outlined,
                  title: 'Soft Skills',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: student.softSkills
                        .map(
                          (skill) =>
                              _buildSkillChip(
                            skill.name,
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // CERTIFICATES
                // ==================================================

                _buildSectionCard(
                  icon: Icons
                      .workspace_premium_outlined,
                  title: 'Certificates',
                  child:
                      student.certificates.isEmpty
                          ? Text(
                              'No certificates added yet.',
                              style: TextStyle(
                                color: Colors
                                    .grey.shade600,
                                fontSize: 14,
                              ),
                            )
                          : Column(
                              children: student
                                  .certificates
                                  .map(
                                (certificate) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Icon(
                                          Icons
                                              .workspace_premium_outlined,
                                          size: 18,
                                          color:
                                              MasarColors
                                                  .primaryBlue,
                                        ),

                                        const SizedBox(
                                          width: 10,
                                        ),

                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                certificate
                                                    .title,
                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600,
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 3,
                                              ),

                                              Text(
                                                certificate
                                                    .issuer,
                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      12,
                                                  color: Colors
                                                      .grey
                                                      .shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // PROJECTS
                // ==================================================

                _buildSectionCard(
                  icon:
                      Icons.folder_outlined,
                  title: 'Projects',
                  child:
                      student.projects.isEmpty
                          ? Text(
                              'No projects added yet.',
                              style: TextStyle(
                                color: Colors
                                    .grey.shade600,
                                fontSize: 14,
                              ),
                            )
                          : Column(
                              children: student
                                  .projects
                                  .map(
                                (project) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      bottom: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Icon(
                                          Icons
                                              .folder_outlined,
                                          size: 18,
                                          color:
                                              MasarColors
                                                  .primaryBlue,
                                        ),

                                        const SizedBox(
                                          width: 10,
                                        ),

                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                project
                                                    .name,
                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600,
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 4,
                                              ),

                                              Text(
                                                project
                                                    .description,
                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      12,
                                                  color: Colors
                                                      .grey
                                                      .shade600,
                                                  height:
                                                      1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // SAVE AS PDF
                // ==================================================

                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _saveCvAsPdf(context);
                    },
                    icon: const Icon(
                      Icons
                          .picture_as_pdf_outlined,
                    ),
                    label: const Text(
                      'Save as PDF',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          MasarColors.primaryBlue,
                      side: BorderSide(
                        color:
                            MasarColors.primaryBlue,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      // ==========================================================
      // Bottom Navigation
      // ==========================================================

      bottomNavigationBar:
          const AppBottomNavBar(
        selectedIndex: 3,
      ),
    );
  }

  // ============================================================
  // Section Card
  // ============================================================

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color:
                      MasarColors.lightBlue,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color:
                      MasarColors.primaryBlue,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.bold,
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

  // ============================================================
  // Info Row
  // ============================================================

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color:
                    Colors.grey.shade600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Skill Chip
  // ============================================================

  Widget _buildSkillChip(
    String skill,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Text(
        skill,
        style: TextStyle(
          color:
              MasarColors.primaryBlue,
          fontSize: 12,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // English Translations For PDF
  // ============================================================

  String _translateStudentName(String name) {
    switch (name) {
      case 'ليان أحمد':
        return 'Layan Ahmad';

      default:
        return name;
    }
  }

  String _translateUniversity(String university) {
    switch (university) {
      case 'جامعة الأردن':
        return 'The University of Jordan';

      case 'الجامعة الهاشمية':
        return 'The Hashemite University';

      case 'جامعة اليرموك':
        return 'Yarmouk University';

      case 'جامعة العلوم والتكنولوجيا الأردنية':
        return 'Jordan University of Science and Technology';

      case 'جامعة الأميرة سمية للتكنولوجيا':
        return 'Princess Sumaya University for Technology';

      case 'جامعة مؤتة':
        return 'Mutah University';

      case 'جامعة البلقاء التطبيقية':
        return 'Al-Balqa Applied University';

      default:
        return university;
    }
  }

  String _translateMajor(String major) {
    switch (major) {
      case 'علم البيانات':
        return 'Data Science';

      case 'علوم الحاسوب':
        return 'Computer Science';

      case 'هندسة البرمجيات':
        return 'Software Engineering';

      case 'نظم المعلومات':
        return 'Information Systems';

      case 'الذكاء الاصطناعي':
        return 'Artificial Intelligence';

      case 'هندسة الحاسوب':
        return 'Computer Engineering';

      case 'الأمن السيبراني':
        return 'Cybersecurity';

      default:
        return major;
    }
  }

  String _translateAcademicYear(String year) {
    switch (year) {
      case 'السنة الأولى':
        return 'First Year';

      case 'السنة الثانية':
        return 'Second Year';

      case 'السنة الثالثة':
        return 'Third Year';

      case 'السنة الرابعة':
        return 'Fourth Year';

      case 'خريجة':
        return 'Graduate';

      default:
        return year;
    }
  }

  String _translateCareerPath(String title) {
    switch (title) {
      case 'محللة بيانات':
        return 'Data Analyst';

      case 'عالمة بيانات':
        return 'Data Scientist';

      case 'مهندسة تعلم آلي':
        return 'Machine Learning Engineer';

      default:
        return title;
    }
  }

  String _translateSoftSkill(String skill) {
    switch (skill) {
      case 'التواصل':
        return 'Communication';

      case 'العمل الجماعي':
        return 'Teamwork';

      case 'حل المشكلات':
        return 'Problem Solving';

      case 'إدارة الوقت':
        return 'Time Management';

      case 'القيادة':
        return 'Leadership';

      default:
        return skill;
    }
  }
}