
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'package:masar_student_app/core/models/certificate_model.dart';
import 'package:masar_student_app/core/models/project_model.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/models/student_model.dart';

class MasarMockData {
  // ============================================================
  // Career Paths
  // ============================================================

  static final List<CareerPath> careerPaths = [
    const CareerPath(
      id: 'data_analyst',
      title: 'محللة بيانات',
      description:
          'تحليل البيانات واستخراج المعلومات والنتائج التي تساعد في اتخاذ القرارات.',
      requiredSkills: [
        'Python',
        'SQL',
        'Excel',
        'Power BI',
        'الإحصاء',
      ],
    ),

    const CareerPath(
      id: 'data_scientist',
      title: 'عالمة بيانات',
      description:
          'استخدام البيانات والإحصاء والتعلم الآلي لبناء نماذج وتحليلات متقدمة.',
      requiredSkills: [
        'Python',
        'SQL',
        'الإحصاء',
        'Machine Learning',
        'Data Visualization',
      ],
    ),

    const CareerPath(
      id: 'ml_engineer',
      title: 'مهندسة تعلم آلي',
      description:
          'تطوير ونشر حلول الذكاء الاصطناعي والتعلم الآلي وربطها بالتطبيقات والأنظمة.',
      requiredSkills: [
        'Python',
        'Machine Learning',
        'Deep Learning',
        'Git',
        'APIs',
      ],
    ),
  ];

  // ============================================================
  // Technical Skills
  // ============================================================

  static final List<Skill> skills = [
    const Skill(
      id: 'python',
      name: 'Python',
      level: 80,
      status: 'قوي',
    ),

    const Skill(
      id: 'excel',
      name: 'Excel',
      level: 90,
      status: 'قوي',
    ),

    const Skill(
      id: 'sql',
      name: 'SQL',
      level: 30,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'power_bi',
      name: 'Power BI',
      level: 20,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'statistics',
      name: 'الإحصاء',
      level: 40,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'machine_learning',
      name: 'Machine Learning',
      level: 25,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'data_visualization',
      name: 'Data Visualization',
      level: 45,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'deep_learning',
      name: 'Deep Learning',
      level: 10,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'git',
      name: 'Git',
      level: 35,
      status: 'بحاجة إلى تطوير',
    ),

    const Skill(
      id: 'apis',
      name: 'APIs',
      level: 20,
      status: 'بحاجة إلى تطوير',
    ),
  ];

  // ============================================================
  // Soft Skills
  // ============================================================

  static final List<SoftSkill> softSkills = [
    const SoftSkill(
      id: 'communication',
      name: 'التواصل',
      level: 80,
    ),
    const SoftSkill(
      id: 'teamwork',
      name: 'العمل الجماعي',
      level: 85,
    ),
    const SoftSkill(
      id: 'problem_solving',
      name: 'حل المشكلات',
      level: 75,
    ),
    const SoftSkill(
      id: 'time_management',
      name: 'إدارة الوقت',
      level: 70,
    ),
    const SoftSkill(
      id: 'leadership',
      name: 'القيادة',
      level: 60,
    ),
  ];

  // ============================================================
  // Certificates
  // ============================================================

  static final List<Certificate> certificates = [
    const Certificate(
      id: 'cert_1',
      title: 'IBM Data Science Professional Certificate',
      issuer: 'IBM / Coursera',
      date: '',
    ),

    const Certificate(
      id: 'cert_2',
      title: 'Python for Data Science',
      issuer: 'IBM',
      date: '',
    ),
  ];

  // ============================================================
  // Projects
  // ============================================================

  static final List<Project> projects = [
    const Project(
      id: 'project_1',
      name: 'تحليل بيانات العملاء',
      description:
          'مشروع لتحليل بيانات العملاء واستخراج الأنماط والمؤشرات المهمة.',
      technologies: [
        'Python',
        'Pandas',
        'Matplotlib',
      ],
      githubUrl: null,
    ),

    const Project(
      id: 'project_2',
      name: 'Customer Churn Prediction',
      description:
          'مشروع لتوقع احتمالية مغادرة العملاء باستخدام Machine Learning.',
      technologies: [
        'Python',
        'Scikit-learn',
        'Pandas',
      ],
      githubUrl: null,
    ),
  ];

  // ============================================================
  // Student
  // ============================================================

  static Student student = Student(
    id: 'student_001',
    name: 'ليان أحمد',
    major: 'علم البيانات',
    university: 'جامعة الأردن',
    academicYear: 'السنة الثالثة',
    email: 'layan.ahmad@masar-demo.com',

    // المسار لا يتم اختياره في Complete Profile.
    // يتم اختياره من Home.
    careerPathId: null,

    gpa: '3.2',

    skills: skills,

    softSkills: softSkills,

    certificates: certificates,

    projects: projects,
  );

  // ============================================================
  // Current Student
  // ============================================================

  static Student? currentStudent = student;

  // ============================================================
  // First Login
  // ============================================================

  static bool isFirstLogin = true;

  // ============================================================
  // Selected Career Path
  // ============================================================

  static CareerPath get selectedCareerPath {
    final careerPathId = currentStudent?.careerPathId;

    if (careerPathId != null) {
      final matchingPath = getCareerPathById(careerPathId);

      if (matchingPath != null) {
        return matchingPath;
      }
    }

    return careerPaths.first;
  }

  // ============================================================
  // Career Path Helpers
  // ============================================================

  static CareerPath? getCareerPathById(String id) {
    try {
      return careerPaths.firstWhere(
        (careerPath) => careerPath.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // Skill Helpers
  // ============================================================

  static Skill? getSkillById(String id) {
    final studentSkills = currentStudent?.skills ?? skills;

    try {
      return studentSkills.firstWhere(
        (skill) => skill.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  static Skill? getSkillByName(String name) {
    final studentSkills = currentStudent?.skills ?? skills;

    try {
      return studentSkills.firstWhere(
        (skill) => skill.name == name,
      );
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // Skills Required For Selected Career
  // ============================================================

  static List<Skill> get selectedCareerSkills {
    final career = selectedCareerPath;

    final studentSkills = currentStudent?.skills ?? skills;

    return studentSkills
        .where(
          (skill) => career.requiredSkills.contains(skill.name),
        )
        .toList();
  }

  // ============================================================
  // Readiness Mock Data
  // ============================================================

  static int readinessScore = 72;

  static int skillsScore = 70;

  static int projectsScore = 60;

  static int certificationsScore = 80;

  static int eligibilityScore = 100;

  // ============================================================
  // About Me
  // ============================================================

  static String aboutMe =
      'طالبة علم بيانات مهتمة بتحليل البيانات والذكاء الاصطناعي '
      'وتطوير المهارات العملية والاستعداد لسوق العمل.';

  // ============================================================
  // Profile Visibility
  // ============================================================

  static bool profileVisibleToCompanies = true;

  // ============================================================
  // Profile Mock Data
  // ============================================================

  static Map<String, dynamic> profileMockData = {
    'name': 'ليان أحمد',
    'major': 'علم البيانات',
    'university': 'جامعة الأردن',
    'academicYear': 'السنة الثالثة',
    'email': 'layan.ahmad@masar-demo.com',
    'gpa': '3.2',
    'careerPath': null,
  };

  // ============================================================
  // University / Academic Data
  // ============================================================

  // هذا المتغير مستخدم في CreateAccountScreen
  static const String universityName = 'جامعة الأردن';

  static const List<String> universities = [
    'جامعة الأردن',
    'الجامعة الهاشمية',
    'جامعة اليرموك',
    'جامعة العلوم والتكنولوجيا الأردنية',
    'جامعة الأميرة سمية للتكنولوجيا',
    'جامعة مؤتة',
    'جامعة البلقاء التطبيقية',
  ];

  static const List<String> majors = [
    'علم البيانات',
    'علوم الحاسوب',
    'هندسة البرمجيات',
    'نظم المعلومات',
    'الذكاء الاصطناعي',
    'هندسة الحاسوب',
    'الأمن السيبراني',
  ];

  static const List<String> academicYears = [
    'السنة الأولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'خريجة',
  ];

  // ============================================================
  // Training Mock Data
  // ============================================================

  static const Map<String, dynamic> trainingOpportunity = {
    'company': 'Microsoft',
    'title': 'IT Support Intern',
    'location': 'عمّان',
    'startDate': '12/09/2026',
    'endDate': '12/12/2026',
    'hours': 120,
    'progress': 0,
  };

  // ============================================================
  // Internship Opportunities
  // ============================================================

  static final List<Map<String, dynamic>> internshipOpportunities = [
    {
      'id': 'internship_1',
      'company': 'Microsoft',
      'title': 'Data Analyst Intern',
      'location': 'عمّان',
      'type': 'Internship',
      'duration': '3 أشهر',
      'requiredSkills': [
        'Python',
        'SQL',
        'Excel',
        'Power BI',
      ],
    },
    {
      'id': 'internship_2',
      'company': 'Orange Jordan',
      'title': 'Data Science Intern',
      'location': 'عمّان',
      'type': 'Internship',
      'duration': '3 أشهر',
      'requiredSkills': [
        'Python',
        'SQL',
        'Machine Learning',
      ],
    },
    {
      'id': 'internship_3',
      'company': 'Amazon',
      'title': 'Machine Learning Intern',
      'location': 'Remote',
      'type': 'Internship',
      'duration': '3 أشهر',
      'requiredSkills': [
        'Python',
        'Machine Learning',
        'Git',
        'APIs',
      ],
    },
  ];

  // ============================================================
  // Notifications
  // ============================================================

  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 'notification_1',
      'title': 'أكمل تقييم الجاهزية',
      'message':
          'ابدأ تقييمك المهني لمعرفة مستوى مهاراتك والمسار المناسب لك.',
      'type': 'career',
      'isRead': false,
    },
    {
      'id': 'notification_2',
      'title': 'فرصة تدريب جديدة',
      'message':
          'تم العثور على فرصة تدريب قد تتناسب مع مهاراتك الحالية.',
      'type': 'training',
      'isRead': false,
    },
  ];

  // ============================================================
  // Update Career Path
  // ============================================================

  static void updateCareerPath(String careerPathId) {
    if (currentStudent == null) return;

    currentStudent = currentStudent!.copyWith(
      careerPathId: careerPathId,
    );

    profileMockData['careerPath'] = careerPathId;
  }

  // ============================================================
  // Update Student
  // ============================================================

  static void updateStudent(Student updatedStudent) {
    currentStudent = updatedStudent;

    profileMockData = {
      'name': updatedStudent.name,
      'major': updatedStudent.major,
      'university': updatedStudent.university,
      'academicYear': updatedStudent.academicYear,
      'email': updatedStudent.email,
      'gpa': updatedStudent.gpa,
      'careerPath': updatedStudent.careerPathId,
    };
  }

  // ============================================================
  // Update Skills After Assessment
  // ============================================================

  static void updateSkillLevels(
    Map<String, int> skillScores,
  ) {
    if (currentStudent == null) return;

    final updatedSkills = currentStudent!.skills.map((skill) {
      final newLevel = skillScores[skill.id];

      if (newLevel == null) {
        return skill;
      }

      String status;

      if (newLevel >= 70) {
        status = 'قوي';
      } else if (newLevel >= 50) {
        status = 'جيد';
      } else {
        status = 'بحاجة إلى تطوير';
      }

      return Skill(
        id: skill.id,
        name: skill.name,
        level: newLevel,
        status: status,
      );
    }).toList();

    currentStudent = currentStudent!.copyWith(
      skills: updatedSkills,
    );
  }
}
