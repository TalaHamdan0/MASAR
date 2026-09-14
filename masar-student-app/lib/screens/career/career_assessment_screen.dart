import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'skill_mirror_screen.dart';

class CareerAssessmentScreen extends StatefulWidget {
  const CareerAssessmentScreen({super.key});

  @override
  State<CareerAssessmentScreen> createState() =>
      _CareerAssessmentScreenState();
}

class _CareerAssessmentScreenState
    extends State<CareerAssessmentScreen> {

  int currentQuestion = 0;

  // -1 يعني لم يتم اختيار إجابة
  final List<int> answers = List.filled(10, -1);

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'ما مدى معرفتك بلغة Python؟',
      'skill': 'Python',
      'options': [
        'مبتدئ جداً',
        'مبتدئ',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى قدرتك على كتابة SQL Queries؟',
      'skill': 'SQL',
      'options': [
        'لا أعرف SQL',
        'أعرف الأساسيات',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى استخدامك لـ Excel في تحليل البيانات؟',
      'skill': 'Excel',
      'options': [
        'لم أستخدمه',
        'استخدام بسيط',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى معرفتك بـ Power BI؟',
      'skill': 'Power BI',
      'options': [
        'لا أعرفه',
        'أعرف الأساسيات',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى فهمك لمفاهيم الإحصاء؟',
      'skill': 'الإحصاء',
      'options': [
        'ضعيف',
        'أعرف الأساسيات',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى معرفتك بمفاهيم Machine Learning؟',
      'skill': 'Machine Learning',
      'options': [
        'لا أعرفها',
        'أعرف الأساسيات',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى قدرتك على عرض البيانات بصرياً؟',
      'skill': 'Data Visualization',
      'options': [
        'ضعيف',
        'مبتدئ',
        'جيد',
        'متقدم',
      ],
    },
    {
      'question': 'ما مدى قدرتك على حل المشاكل وتحليلها؟',
      'skill': 'Problem Solving',
      'options': [
        'أحتاج لتطويرها',
        'مقبول',
        'جيد',
        'ممتاز',
      ],
    },
    {
      'question': 'ما مدى قدرتك على العمل ضمن فريق؟',
      'skill': 'Teamwork',
      'options': [
        'أحتاج لتطويرها',
        'مقبول',
        'جيد',
        'ممتاز',
      ],
    },
    {
      'question': 'ما مدى ثقتك في تنفيذ مشروع Data Analysis كامل؟',
      'skill': 'Data Analysis',
      'options': [
        'لا أستطيع حالياً',
        'أستطيع بمساعدة',
        'أستطيع بشكل جيد',
        'أستطيع بشكل مستقل',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final selectedAnswer = answers[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Assessment'),
      ),

      body: SafeArea(
        child: Column(
          children: [

            // Progress
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentQuestion + 1} of 10',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MasarColors.textPrimary,
                        ),
                      ),

                      Text(
                        '${((currentQuestion + 1) / 10 * 100).round()}%',
                        style: const TextStyle(
                          color: MasarColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: (currentQuestion + 1) / 10,
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: MasarColors.lightBlue,
                    color: MasarColors.primaryBlue,
                  ),
                ],
              ),
            ),

            // Question + Answers
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    const SizedBox(height: 20),

                    // Question number
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${currentQuestion + 1}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: MasarColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      question['question'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ...List.generate(
                      question['options'].length,
                      (index) {
                        final isSelected = selectedAnswer == index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                answers[currentQuestion] = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? MasarColors.lightBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? MasarColors.primaryBlue
                                      : MasarColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [

                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? MasarColors.primaryBlue
                                            : MasarColors.textSecondary,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 13,
                                              height: 13,
                                              decoration:
                                                  const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: MasarColors
                                                    .primaryBlue,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      question['options'][index],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: MasarColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      selectedAnswer == -1 ? null : _nextQuestion,
                  child: Text(
                    currentQuestion == 9
                        ? 'Finish Assessment'
                        : 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion() {
    if (currentQuestion < 9) {
      setState(() {
        currentQuestion++;
      });
    } else {
      _finishAssessment();
    }
  }

  void _finishAssessment() {

    // تحويل الإجابات إلى نسب مئوية
    final Map<String, int> skillScores = {};

    for (int i = 0; i < questions.length; i++) {
      final skill = questions[i]['skill'];

      // الإجابة من 0 إلى 3
      // نحولها إلى 0 - 100
      final score = ((answers[i] + 1) / 4 * 100).round();

      skillScores[skill] = score;
    }

    // حساب readiness
    int total = 0;

    for (final answer in answers) {
      total += answer + 1;
    }

    final int readinessScore =
        ((total / (answers.length * 4)) * 100).round();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SkillMirrorScreen(
          readinessScore: readinessScore,
          skillScores: skillScores,
        ),
      ),
    );
  }
}