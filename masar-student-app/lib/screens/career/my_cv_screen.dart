
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';

class MyCvScreen extends StatelessWidget {
  const MyCvScreen({super.key});

  // ============================================================
  // SAVE CV AS PDF
  // ============================================================

  Future<void> _saveCvAsPdf(BuildContext context) async {
    try {
      final pdf = pw.Document();

      // ==========================================================
      // CAIRO FONTS
      // ==========================================================

      final regularFont = pw.Font.ttf(
        await rootBundle.load(
          'assets/fonts/Cairo-Regular.ttf',
        ),
      );

      final boldFont = pw.Font.ttf(
        await rootBundle.load(
          'assets/fonts/Cairo-Bold.ttf',
        ),
      );

      final student = MasarMockData.student;
      final careerPath = MasarMockData.selectedCareerPath;

      // ==========================================================
      // PDF
      // ==========================================================

      pdf.addPage(
        pw.MultiPage(
          theme: pw.ThemeData.withFont(
            base: regularFont,
            bold: boldFont,
          ),

          margin: const pw.EdgeInsets.all(32),

          build: (context) {
            return [
              // ====================================================
              // RTL ONLY INSIDE PDF
              // ====================================================

              pw.Directionality(
                textDirection: pw.TextDirection.rtl,

                child: pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.stretch,

                  children: [

                    // ==============================================
                    // HEADER
                    // ==============================================

                    pw.Center(
                      child: pw.Text(
                        student.name,
                        textDirection:
                            pw.TextDirection.rtl,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 6),

                    pw.Center(
                      child: pw.Text(
                        careerPath.title,
                        textDirection:
                            pw.TextDirection.rtl,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 6),

                    // EMAIL - LTR
                    pw.Directionality(
                      textDirection:
                          pw.TextDirection.ltr,

                      child: pw.Center(
                        child: pw.Text(
                          student.email,
                          textDirection:
                              pw.TextDirection.ltr,
                          textAlign:
                              pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 25),

                    // ==============================================
                    // PERSONAL INFORMATION
                    // ==============================================

                    _pdfSectionTitle(
                      'Personal Information',
                      boldFont,
                    ),

                    pw.SizedBox(height: 8),

                    _pdfText(
                      'Name: ${student.name}',
                      regularFont,
                    ),

                    _pdfText(
                      'Major: ${student.major}',
                      regularFont,
                    ),

                    _pdfText(
                      'University: ${student.university}',
                      regularFont,
                    ),

                    _pdfText(
                      'Academic Year: ${student.academicYear}',
                      regularFont,
                    ),

                    pw.SizedBox(height: 18),

                    // ==============================================
                    // EDUCATION
                    // ==============================================

                    _pdfSectionTitle(
                      'Education',
                      boldFont,
                    ),

                    pw.SizedBox(height: 8),

                    _pdfText(
                      student.major,
                      regularFont,
                    ),

                    _pdfText(
                      student.university,
                      regularFont,
                    ),

                    _pdfText(
                      student.academicYear,
                      regularFont,
                    ),

                    // GPA - keep numbers natural
                    pw.Directionality(
                      textDirection:
                          pw.TextDirection.ltr,

                      child: pw.Align(
                        alignment:
                            pw.Alignment.centerRight,

                        child: pw.Text(
                          'GPA: ${student.gpa}',
                          textDirection:
                              pw.TextDirection.ltr,
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 18),

                    // ==============================================
                    // CAREER PATH
                    // ==============================================

                    _pdfSectionTitle(
                      'Career Path',
                      boldFont,
                    ),

                    pw.SizedBox(height: 8),

                    _pdfText(
                      careerPath.title,
                      regularFont,
                    ),

                    _pdfText(
                      careerPath.description,
                      regularFont,
                    ),

                    pw.SizedBox(height: 18),

                    // ==============================================
                    // TECHNICAL SKILLS
                    // ==============================================

                    _pdfSectionTitle(
                      'Technical Skills',
                      boldFont,
                    ),

                    pw.SizedBox(height: 8),

                    ...MasarMockData
                        .selectedCareerSkills
                        .map(
                      (skill) => pw.Padding(
                        padding:
                            const pw.EdgeInsets.only(
                          bottom: 5,
                        ),

                        child: pw.Text(
                          '• ${skill.name}',
                          textDirection:
                              pw.TextDirection.rtl,
                          textAlign:
                              pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 15),

                    // ==============================================
                    // SOFT SKILLS
                    // ==============================================

                    _pdfSectionTitle(
                      'Soft Skills',
                      boldFont,
                    ),

                    pw.SizedBox(height: 8),

                    ...student.softSkills.map(
                      (skill) => pw.Padding(
                        padding:
                            const pw.EdgeInsets.only(
                          bottom: 5,
                        ),

                        child: pw.Text(
                          '• ${skill.name}',
                          textDirection:
                              pw.TextDirection.rtl,
                          textAlign:
                              pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 15),

                    // ==============================================
                    // CERTIFICATES
                    // ==============================================

                    _pdfSectionTitle(
                      'Certificates',
                      boldFont,
                    ),

                    pw.SizedBox(height: 8),

                    ...student.certificates.map(
                      (certificate) => pw.Padding(
                        padding:
                            const pw.EdgeInsets.only(
                          bottom: 8,
                        ),

                        child: pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,

                          children: [

                            pw.Text(
                              certificate.title,
                              textDirection:
                                  pw.TextDirection.rtl,
                              textAlign:
                                  pw.TextAlign.right,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 11,
                              ),
                            ),

                            pw.SizedBox(height: 3),

                            // Issuer + date stay LTR
                            pw.Directionality(
                              textDirection:
                                  pw.TextDirection.ltr,

                              child: pw.Text(
                                '${certificate.issuer} • ${certificate.date}',
                                textDirection:
                                    pw.TextDirection.ltr,
                                textAlign:
                                    pw.TextAlign.left,
                                style: pw.TextStyle(
                                  font: regularFont,
                                  fontSize: 10,
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
            ];
          },
        ),
      );

      // ==========================================================
      // OPEN PDF SAVE / PRINT
      // ==========================================================

      await Printing.layoutPdf(
        onLayout: (format) async {
          return pdf.save();
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء إنشاء الـCV: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // PDF SECTION TITLE
  // ============================================================

  pw.Widget _pdfSectionTitle(
    String text,
    pw.Font boldFont,
  ) {
    return pw.Text(
      text,
      textDirection: pw.TextDirection.rtl,
      textAlign: pw.TextAlign.right,
      style: pw.TextStyle(
        font: boldFont,
        fontSize: 16,
      ),
    );
  }

  // ============================================================
  // PDF TEXT
  // ============================================================

  pw.Widget _pdfText(
    String text,
    pw.Font regularFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        bottom: 4,
      ),

      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(
          font: regularFont,
          fontSize: 11,
        ),
      ),
    );
  }

  // ============================================================
  // ADD TO CV - OPEN MENU
  // ============================================================

  void _showAddToCvSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,

      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Text(
                  'What do you want to add?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                _addOption(
                  sheetContext,
                  Icons.code,
                  'Skill',
                ),

                _addOption(
                  sheetContext,
                  Icons.workspace_premium,
                  'Certificate',
                ),

                _addOption(
                  sheetContext,
                  Icons.menu_book,
                  'Course',
                ),

                _addOption(
                  sheetContext,
                  Icons.folder,
                  'Project',
                ),

                _addOption(
                  sheetContext,
                  Icons.work,
                  'Experience',
                ),

                _addOption(
                  sheetContext,
                  Icons.school,
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
  // ADD OPTION
  // ============================================================

  Widget _addOption(
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
          color: MasarColors.textPrimary,
        ),
      ),

      trailing: IconButton(
        tooltip: 'Add $title',

        icon: const Icon(
          Icons.add_circle,
          size: 30,
          color: MasarColors.primaryBlue,
        ),

        onPressed: () async {
          final result =
              await FilePicker.platform.pickFiles(
            allowMultiple: false,
          );

          if (result == null ||
              result.files.isEmpty) {
            return;
          }

          final fileName =
              result.files.first.name;

          if (!context.mounted) return;

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$title selected: $fileName',
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final student = MasarMockData.student;
    final careerPath =
        MasarMockData.selectedCareerPath;

    // IMPORTANT:
    // NO Directionality here.
    // The screen keeps the same direction
    // as the rest of the application.

    return Scaffold(
      appBar: AppBar(
        title: const Text('My CV'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // HEADER
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 32,

                      backgroundColor:
                          MasarColors.lightBlue,

                      child: const Icon(
                        Icons.person,
                        size: 35,
                        color:
                            MasarColors.primaryBlue,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            student.name,
                            style:
                                Theme.of(context)
                                    .textTheme
                                    .titleLarge,
                          ),

                          const SizedBox(height: 4),

                          Text(
                            careerPath.title,
                            style:
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                          ),

                          const SizedBox(height: 4),

                          Text(
                            student.email,
                            style:
                                Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // PERSONAL INFORMATION
            // ==================================================

            _section(
              context,
              'Personal Information',
              [
                'Name: ${student.name}',
                'Major: ${student.major}',
                'University: ${student.university}',
                'Academic Year: ${student.academicYear}',
              ],
            ),

            // ==================================================
            // EDUCATION
            // ==================================================

            _section(
              context,
              'Education',
              [
                student.major,
                student.university,
                student.academicYear,
                'GPA: ${student.gpa}',
              ],
            ),

            // ==================================================
            // CAREER PATH
            // ==================================================

            _section(
              context,
              'Career Path',
              [
                careerPath.title,
                careerPath.description,
              ],
            ),

            // ==================================================
            // TECHNICAL SKILLS
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Technical Skills',
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium,
                    ),

                    const SizedBox(height: 12),

                    ...MasarMockData
                        .selectedCareerSkills
                        .map(
                      (skill) => Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 8,
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons
                                  .check_circle_outline,
                              size: 20,
                              color: MasarColors
                                  .primaryGreen,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                skill.name,
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

            const SizedBox(height: 12),

            // ==================================================
            // SOFT SKILLS
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Soft Skills',
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium,
                    ),

                    const SizedBox(height: 12),

                    ...student.softSkills.map(
                      (skill) => Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 8,
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons
                                  .check_circle_outline,
                              size: 20,
                              color: MasarColors
                                  .primaryGreen,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                skill.name,
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

            const SizedBox(height: 12),

            // ==================================================
            // CERTIFICATES
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Certificates',
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium,
                    ),

                    const SizedBox(height: 12),

                    ...student.certificates.map(
                      (certificate) => Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              certificate.title,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              '${certificate.issuer} • ${certificate.date}',
                              style:
                                  Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // BUTTONS
            // ==================================================

            Row(
              children: [

                // ADD TO CV
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAddToCvSheet(
                        context,
                      );
                    },

                    icon: const Icon(
                      Icons.add,
                    ),

                    label: const Text(
                      'Add to CV',
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(0, 52),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // SAVE PDF
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _saveCvAsPdf(context);
                    },

                    icon: const Icon(
                      Icons.picture_as_pdf,
                    ),

                    label: const Text(
                      'Save as PDF',
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(0, 52),

                      backgroundColor:
                          MasarColors.primaryBlue,

                      foregroundColor:
                          Colors.white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================      

      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 3,

),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _section(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style:
                    Theme.of(context)
                        .textTheme
                        .titleMedium,
              ),

              const SizedBox(height: 12),

              ...items.map(
                (item) => Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 5,
                  ),

                  child: Text(item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
