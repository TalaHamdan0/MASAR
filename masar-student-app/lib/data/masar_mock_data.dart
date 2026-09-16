import 'package:masar_student_app/core/models/student_model.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/models/certificate_model.dart';

class MasarMockData {
  // ============================================================
  // CAREER PATHS
  // ============================================================

  static const List<CareerPath> careerPaths = [
    CareerPath(
      id: 'data_analyst',
      title: 'Data Analyst',
      description:
          'تحليل البيانات واستخراج المعلومات التي تساعد في اتخاذ القرارات.',
      requiredSkills: [
        'Python',
        'SQL',
        'Excel',
        'Power BI',
        'الإحصاء',
      ],
    ),

    CareerPath(
      id: 'data_scientist',
      title: 'Data Scientist',
      description:
          'استخدام البيانات والإحصاء والتعلم الآلي لحل المشكلات والتنبؤ بالنتائج.',
      requiredSkills: [
        'Python',
        'SQL',
        'الإحصاء',
        'Machine Learning',
        'Data Visualization',
      ],
    ),

    CareerPath(
      id: 'ml_engineer',
      title: 'ML Engineer',
      description:
          'تطوير وتطبيق نماذج التعلم الآلي ودمجها داخل الأنظمة.',
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
  // TECHNICAL SKILLS
  // ============================================================

  static const List<Skill> skills = [
    Skill(
      id: 'python',
      name: 'Python',
      level: 80,
      status: 'Strong',
    ),

    Skill(
      id: 'excel',
      name: 'Excel',
      level: 90,
      status: 'Strong',
    ),

    Skill(
      id: 'sql',
      name: 'SQL',
      level: 30,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'power_bi',
      name: 'Power BI',
      level: 20,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'statistics',
      name: 'الإحصاء',
      level: 40,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'machine_learning',
      name: 'Machine Learning',
      level: 25,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'data_visualization',
      name: 'Data Visualization',
      level: 45,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'deep_learning',
      name: 'Deep Learning',
      level: 10,
      status: 'Beginner',
    ),

    Skill(
      id: 'git',
      name: 'Git',
      level: 35,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'apis',
      name: 'APIs',
      level: 20,
      status: 'Needs Improvement',
    ),
  ];

  // ============================================================
  // SOFT SKILLS
  // ============================================================

  static const List<SoftSkill> softSkills = [
    SoftSkill(
      id: 'communication',
      name: 'Communication',
      level: 80,
    ),

    SoftSkill(
      id: 'teamwork',
      name: 'Teamwork',
      level: 85,
    ),

    SoftSkill(
      id: 'problem_solving',
      name: 'Problem Solving',
      level: 75,
    ),

    SoftSkill(
      id: 'time_management',
      name: 'Time Management',
      level: 70,
    ),

    SoftSkill(
      id: 'leadership',
      name: 'Leadership',
      level: 60,
    ),
  ];

  // ============================================================
  // CERTIFICATES
  // ============================================================

  static const List<Certificate> certificates = [
    Certificate(
      id: 'cert_001',
      title: 'IBM Data Science Professional Certificate',
      issuer: 'IBM',
      date: '2026-09-12',
    ),

    Certificate(
      id: 'cert_002',
      title: 'Python for Data Science',
      issuer: 'IBM',
      date: '2026-08-20',
    ),
  ];

  // ============================================================
  // STUDENT
  // ============================================================

  static const Student student = Student(
    id: 'student_001',
    name: 'ليان أحمد',
    major: 'علم البيانات',
    university: 'جامعة الأردن',
    academicYear: 'السنة الثالثة',
    email: 'layan.ahmad@masar-demo.com',
    careerPathId: 'data_analyst',
    gpa: '3.2',
    skills: skills,
    softSkills: softSkills,
    certificates: certificates,
  );

  // ============================================================
  // READINESS SCORE
  // ============================================================

  static const int readinessScore = 72;

  static const int skillsScore = 70;

  static const int projectsScore = 60;

  static const int certificationsScore = 80;

  static const int eligibilityScore = 100;

  // ============================================================
  // SELECTED CAREER PATH
  // ============================================================

  static CareerPath get selectedCareerPath {
    return careerPaths.firstWhere(
      (path) => path.id == student.careerPathId,
    );
  }

  // ============================================================
  // SKILLS FOR SELECTED CAREER PATH
  // ============================================================

  static List<Skill> get selectedCareerSkills {
    return skills
        .where(
          (skill) =>
              selectedCareerPath.requiredSkills.contains(skill.name),
        )
        .toList();
  }

  // ============================================================
  // FIND SKILL BY ID
  // ============================================================

  static Skill? getSkillById(String id) {
    try {
      return skills.firstWhere(
        (skill) => skill.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // FIND CAREER PATH BY ID
  // ============================================================

  static CareerPath? getCareerPathById(String id) {
    try {
      return careerPaths.firstWhere(
        (path) => path.id == id,
      );
    } catch (_) {
      return null;
    }
  }
    // ============================================================
  // TRAINING
  // ============================================================

  static const String trainingCompany = 'Microsoft';

  static const String trainingPosition = 'IT Support Intern';

  static const String trainingLocation = 'عمان';

  static const String trainingStartDate = '12/09/2026';

  static const String trainingEndDate = '12/12/2026';

  static const int trainingHours = 120;

  static const double trainingProgress = 0.0;

  // ============================================================
  // ATTENDANCE
  // ============================================================

  static const List<Map<String, String>> attendance = [
    {
      'date': '23/09/2026',
      'day': 'الأربعاء',
      'status': 'حاضر',
    },
    {
      'date': '22/09/2026',
      'day': 'الثلاثاء',
      'status': 'حاضر',
    },
    {
      'date': '21/09/2026',
      'day': 'الاثنين',
      'status': 'غائب',
    },
    {
      'date': '20/09/2026',
      'day': 'الأحد',
      'status': 'حاضر',
    },
  ];

  // ============================================================
  // WEEKLY REPORTS
  // ============================================================

  static const List<Map<String, dynamic>> weeklyReports = [
    {
      'week': 1,
      'startDate': '12/09/2026',
      'endDate': '18/09/2026',
      'status': 'completed',
    },
    {
      'week': 2,
      'startDate': '19/09/2026',
      'endDate': '25/09/2026',
      'status': 'completed',
    },
    {
      'week': 3,
      'startDate': '26/09/2026',
      'endDate': '02/10/2026',
      'status': 'current',
    },
    {
      'week': 4,
      'startDate': '03/10/2026',
      'endDate': '09/10/2026',
      'status': 'locked',
    },
    {
      'week': 5,
      'startDate': '10/10/2026',
      'endDate': '16/10/2026',
      'status': 'locked',
    },
    {
      'week': 6,
      'startDate': '17/10/2026',
      'endDate': '23/10/2026',
      'status': 'locked',
    },
  ];

  // ============================================================
  // EVALUATION
  // ============================================================

  // هل مشرف الشركة قام بالتقييم؟
  static const bool hasCompanyEvaluation = false;

  // تقييم الشركة
  static const Map<String, double> companyEvaluation = {
    'الالتزام والانضباط': 4.5,
    'جودة العمل': 4.0,
    'التواصل': 4.5,
    'العمل ضمن الفريق': 4.0,
    'المبادرة والتعلم': 4.5,
  };

  // ملاحظات مشرف الشركة
  static const String companyEvaluationNotes =
      'أداء ممتاز والتزام واضح خلال فترة التدريب.';

  // التقييم السري
  // الطالب لا يستطيع الاطلاع عليه.
  static const bool hasSecretEvaluation = false;
}