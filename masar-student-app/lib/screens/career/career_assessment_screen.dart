
import 'package:flutter/material.dart';

import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/screens/career/career_readiness_screen.dart';

class CareerAssessmentScreen extends StatefulWidget {
  const CareerAssessmentScreen({super.key});

  @override
  State<CareerAssessmentScreen> createState() =>
      _CareerAssessmentScreenState();
}

class _CareerAssessmentScreenState
    extends State<CareerAssessmentScreen> {
  int currentQuestion = 0;

  final List<int?> answers = List.filled(10, null);

  final List<Map<String, dynamic>> questions = [
    {
      'skill': 'Python',
      'question': 'أي مكتبة تستخدم بشكل شائع لتحليل البيانات في Python؟',
      'options': [
        'Pandas',
        'Flutter',
        'Django',
        'Firebase',
      ],
      'correct': 0,
    },
    {
      'skill': 'Python',
      'question': 'ما وظيفة الدالة len() في Python؟',
      'options': [
        'حذف البيانات',
        'حساب طول العنصر',
        'تدريب النموذج',
        'إنشاء ملف',
      ],
      'correct': 1,
    },
    {
      'skill': 'SQL',
      'question': 'أي أمر يستخدم لجلب البيانات من قاعدة البيانات؟',
      'options': [
        'INSERT',
        'DELETE',
        'SELECT',
        'UPDATE',
      ],
      'correct': 2,
    },
    {
      'skill': 'SQL',
      'question': 'أي جزء من SQL يستخدم لتصفية النتائج؟',
      'options': [
        'WHERE',
        'ORDER BY',
        'GROUP BY',
        'JOIN',
      ],
      'correct': 0,
    },
    {
      'skill': 'Excel',
      'question': 'أي دالة تستخدم لحساب متوسط القيم؟',
      'options': [
        'SUM',
        'COUNT',
        'AVERAGE',
        'MAX',
      ],
      'correct': 2,
    },
    {
      'skill': 'Excel',
      'question': 'ما الأداة المناسبة لتلخيص البيانات في Excel؟',
      'options': [
        'Pivot Table',
        'WordArt',
        'Header',
        'Page Break',
      ],
      'correct': 0,
    },
    {
      'skill': 'Power BI',
      'question': 'ما الاستخدام الأساسي لـ Power BI؟',
      'options': [
        'إنشاء تطبيقات',
        'تحليل البيانات وإنشاء التقارير',
        'كتابة كود Python',
        'إرسال البريد',
      ],
      'correct': 1,
    },
    {
      'skill': 'Power BI',
      'question': 'أي عنصر يستخدم لعرض البيانات بصريًا في Power BI؟',
      'options': [
        'Visual',
        'Class',
        'Function',
        'Package',
      ],
      'correct': 0,
    },
    {
      'skill': 'الإحصاء',
      'question': 'كيف نحسب المتوسط الحسابي؟',
      'options': [
        'أكبر قيمة',
        'أصغر قيمة',
        'مجموع القيم ÷ عددها',
        'القيمة الأكثر تكرارًا',
      ],
      'correct': 2,
    },
    {
      'skill': 'الإحصاء',
      'question': 'أي مقياس يتأثر بالقيم المتطرفة بشكل أكبر؟',
      'options': [
        'Mean',
        'Median',
        'Mode',
        'Range',
      ],
      'correct': 0,
    },
  ];

  void nextQuestion() {
    if (answers[currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختاري إجابة أولاً'),
        ),
      );
      return;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      finishAssessment();
    }
  }

  void previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  void finishAssessment() {
    int correctAnswers = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i]['correct']) {
        correctAnswers++;
      }
    }

    final int score =
        ((correctAnswers / questions.length) * 100).round();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CareerReadinessScreen(
          readinessScore: score,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    final double progress =
        (currentQuestion + 1) / questions.length;

    return Scaffold(
      backgroundColor: MasarColors.background,

      appBar: AppBar(
        title: const Text('تقييم الجاهزية المهنية'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'السؤال ${currentQuestion + 1} من ${questions.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: MasarColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor:
                              MasarColors.lightBlue,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
                            MasarColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: MasarColors.lightGreen,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            question['skill'],
                            style: const TextStyle(
                              color: MasarColors.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          question['question'],
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                        ),

                        const SizedBox(height: 25),

                        ...List.generate(
                          question['options'].length,
                          (index) {
                            final bool selected =
                                answers[currentQuestion] ==
                                    index;

                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(15),
                                onTap: () {
                                  setState(() {
                                    answers[currentQuestion] =
                                        index;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? MasarColors.lightBlue
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(15),
                                    border: Border.all(
                                      color: selected
                                          ? MasarColors
                                              .primaryBlue
                                          : MasarColors.border,
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          shape:
                                              BoxShape.circle,
                                          color: selected
                                              ? MasarColors
                                                  .primaryBlue
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: selected
                                                ? MasarColors
                                                    .primaryBlue
                                                : MasarColors
                                                    .border,
                                          ),
                                        ),
                                        child: selected
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          question['options']
                                              [index],
                                          style:
                                              const TextStyle(
                                            fontSize: 14,
                                            height: 1.4,
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

                Container(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    20,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: MasarColors.border,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (currentQuestion > 0) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: previousQuestion,
                            child: const Text('السابق'),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: nextQuestion,
                          child: Text(
                            currentQuestion ==
                                    questions.length - 1
                                ? 'إنهاء التقييم'
                                : 'التالي',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

