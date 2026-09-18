import 'package:flutter/material.dart';

import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _gpaController;

  String? _selectedMajor;
  String? _selectedAcademicYear;
  String? _selectedCareerPath;

  @override
  void initState() {
    super.initState();

    final profile = MasarMockData.profileMockData;

    _nameController = TextEditingController(
      text: profile['name'],
    );

    _gpaController = TextEditingController(
      text: profile['gpa'],
    );

    _selectedMajor = profile['major'];
    _selectedAcademicYear = profile['academicYear'];
    //_selectedCareerPath = profile['careerPath'];
    final careerPathValue = profile['careerPath']?.toString();

final matchingCareerPaths = MasarMockData.careerPaths.where(
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
    _gpaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = MasarMockData.profileMockData;

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
                initialValue: profile['universityId'],
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'الرقم الجامعي',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: profile['email'],
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'البريد الجامعي',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: profile['university'],
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

TextFormField(
  controller: _gpaController,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  decoration: const InputDecoration(
    labelText: 'المعدل التراكمي',
  ),
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

    final profile = MasarMockData.profileMockData;

    // تحديث الـ Mock Data فقط
    profile['name'] = _nameController.text.trim();
    profile['major'] = _selectedMajor!;
    profile['academicYear'] = _selectedAcademicYear!;
    profile['gpa'] = _gpaController.text.trim();
    profile['careerPath'] = _selectedCareerPath;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم حفظ التغييرات بنجاح',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }
}