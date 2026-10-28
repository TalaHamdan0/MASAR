import 'package:flutter/material.dart';

import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  String? _selectedMajor;
  String? _selectedAcademicYear;
  String? _selectedCareerPath;

  String _profileText(
    Map<String, dynamic> profile,
    String key,
  ) {
    return profile[key]?.toString() ?? '';
  }

  String? _matchingValue(
    String? value,
    List<String> options,
  ) {
    if (value == null || !options.contains(value)) {
      return null;
    }

    return value;
  }

  @override
  void initState() {
    super.initState();

    final profile = MasarMockData.profileMockData;

    _nameController = TextEditingController(
      text: _profileText(profile, 'name'),
    );

    _selectedMajor = _matchingValue(
      profile['major']?.toString(),
      MasarMockData.majors,
    );

    _selectedAcademicYear = _matchingValue(
      profile['academicYear']?.toString(),
      MasarMockData.academicYears,
    );

    final careerPathValue =
        MasarMockData.currentStudent?.careerPathId ??
            profile['careerPath']?.toString();

    final matchingCareerPaths =
        MasarMockData.careerPaths.where(
      (path) =>
          path.id == careerPathValue ||
          path.title == careerPathValue,
    ).toList();

    _selectedCareerPath = matchingCareerPaths.isNotEmpty
        ? matchingCareerPaths.first.id
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = MasarMockData.profileMockData;

    final studentNumber = _profileText(
      profile,
      'studentNumber',
    );

    final email = _profileText(
      profile,
      'email',
    );

    final university = _profileText(
      profile,
      'university',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_right,
            size: 30,
            color: MasarColors.darkBlue,
          ),
        ),
        title: const Text('تعديل الملف الشخصي'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
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
                initialValue: studentNumber,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'الرقم الجامعي',
                  hintText: 'غير متوفر حاليًا',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: university,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'الجامعة',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedMajor,
                decoration: const InputDecoration(
                  labelText: 'التخصص',
                ),
                items: MasarMockData.majors.map((major) {
                  return DropdownMenuItem<String>(
                    value: major,
                    child: Text(major),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMajor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'اختر التخصص';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAcademicYear,
                decoration: const InputDecoration(
                  labelText: 'السنة الدراسية',
                ),
                items: MasarMockData.academicYears.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAcademicYear = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'اختر السنة الدراسية';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCareerPath,
                decoration: const InputDecoration(
                  labelText: 'المسار المهني',
                ),
                items: MasarMockData.careerPaths.map((path) {
                  return DropdownMenuItem<String>(
                    value: path.id,
                    child: Text(path.title),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCareerPath = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('حفظ التغييرات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final major = _selectedMajor!;
    final academicYear = _selectedAcademicYear!;
    final currentStudent = MasarMockData.currentStudent;

    if (currentStudent != null) {
      final updatedStudent = currentStudent.copyWith(
        name: name,
        major: major,
        academicYear: academicYear,
        careerPathId: _selectedCareerPath,
      );

      MasarMockData.updateStudent(updatedStudent);
    } else {
      final profile = MasarMockData.profileMockData;

      profile['name'] = name;
      profile['major'] = major;
      profile['academicYear'] = academicYear;
      profile['careerPath'] = _selectedCareerPath;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم تحديث البيانات مؤقتًا داخل التطبيق.',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }
}