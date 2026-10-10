import 'package:flutter/material.dart';

class EvaluationsScreen extends StatefulWidget {
  const EvaluationsScreen({super.key});

  @override
  State<EvaluationsScreen> createState() => _EvaluationsScreenState();
}

class _EvaluationsScreenState extends State<EvaluationsScreen> {
  // قائمة المتدربين مع معلومات المشرف الأكاديمي الخاص بكل متدرب
  final List<Map<String, String>> trainees = [
    {
      'name': 'ليان أحمد',
      'universitySupervisor': 'د. أسامة الخطيب (جامعة العلوم الإسلامية)',
    },
    {
      'name': 'أحمد محمود',
      'universitySupervisor': 'د. رانيا سعيد (جامعة العلوم الإسلامية)',
    },
    {
      'name': 'سارة خالد',
      'universitySupervisor': 'د. محمد العبدالله (جامعة العلوم الإسلامية)',
    },
  ];

  String? selectedTrainee = 'ليان أحمد';
  String? currentUniversitySupervisor =
      'د. أسامة الخطيب (جامعة العلوم الإسلامية)';

  // درجات معايير التقييم (تبدأ من 0)
  int commitmentRating = 0; // الالتزام
  int attendanceRating = 0; // الحضور
  int technicalRating = 0; // المهارات التقنية
  int communicationRating = 0; // التواصل
  int teamWorkRating = 0; // العمل الجماعي
  int qualityRating = 0; // جودة العمل

  final TextEditingController notesController = TextEditingController();

  // حساب التقييم العام تلقائياً (متوسط المعايير التي تم تقييمها فقط)
  double get overallRating {
    List<int> ratings = [
      commitmentRating,
      attendanceRating,
      technicalRating,
      communicationRating,
      teamWorkRating,
      qualityRating,
    ];

    // حساب المعايير المحددة (الأكبر من 0)
    List<int> activeRatings = ratings.where((r) => r > 0).toList();

    if (activeRatings.isEmpty) return 0.0;

    int sum = activeRatings.reduce((a, b) => a + b);
    return double.parse((sum / activeRatings.length).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF17243A),
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'التقييمات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17243A),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE8EDF5)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------
              // تنبيه السرية والمستلم
              // ----------------------------------------
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9EC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE8B2)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      color: Color(0xFFD9822B),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'هذا التقييم سري للغاية ولن يظهر للمشرفين الآخرين أو الطالب. يتم إرساله مباشرة لمشرف الطالب في الجامعة فقط.',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11.5,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF915413),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------
              // اختيار المتدرب ومعلومات مشرف الجامعة
              // ----------------------------------------
              const Text(
                'اختر المتدرب للتقييم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17243A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE1E8F2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedTrainee,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF4D8FF7),
                    ),
                    items: trainees.map((trainee) {
                      return DropdownMenuItem<String>(
                        value: trainee['name'],
                        child: Text(
                          trainee['name']!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTrainee = value;
                        var found = trainees.firstWhere(
                          (t) => t['name'] == value,
                        );
                        currentUniversitySupervisor =
                            found['universitySupervisor'];
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // عرض اسم مشرف الجامعة المستقبل للتقييم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      size: 16,
                      color: Color(0xFF3979D7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'المُستلِم: $currentUniversitySupervisor',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A5FA9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------
              // معايير التقييم النهائي
              // ----------------------------------------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE1E8F2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'معايير التقييم النهائي',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3979D7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRatingRow('الالتزام', commitmentRating, (rating) {
                      setState(() => commitmentRating = rating);
                    }),
                    _buildRatingRow('الحضور', attendanceRating, (rating) {
                      setState(() => attendanceRating = rating);
                    }),
                    _buildRatingRow('المهارات التقنية', technicalRating, (
                      rating,
                    ) {
                      setState(() => technicalRating = rating);
                    }),
                    _buildRatingRow('التواصل', communicationRating, (rating) {
                      setState(() => communicationRating = rating);
                    }),
                    _buildRatingRow('العمل الجماعي', teamWorkRating, (rating) {
                      setState(() => teamWorkRating = rating);
                    }),
                    _buildRatingRow('جودة العمل', qualityRating, (rating) {
                      setState(() => qualityRating = rating);
                    }),
                    const Divider(height: 28, color: Color(0xFFECEFF4)),

                    // التقييم العام المحسوب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'التقييم العام',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF17243A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: overallRating == 0.0
                                ? const Color(0xFFF3F4F6)
                                : const Color(0xFFEAF8EF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$overallRating / 5',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: overallRating == 0.0
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF2F9E5B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------
              // ملاحظات وتوصيات المشرف
              // ----------------------------------------
              const Text(
                'ملاحظات إضافية للمشرف في الجامعة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17243A),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 4,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'أضف أي ملاحظات أو توصيات هنا...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.5,
                    color: Color(0xFF9AA4B2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E6EF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E6EF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4D8FF7)),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ----------------------------------------
              // زر إرسال التقييم
              // ----------------------------------------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D8FF7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إرسال التقييم إلى $currentUniversitySupervisor بنجاح.',
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_clock_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'إرسال التقييم',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }

  // ودجت صف المعيار مع إمكانية إلغاء التعيين وإرجاعه للصفر
  Widget _buildRatingRow(
    String title,
    int currentRating,
    Function(int) onRatingSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: currentRating == 0
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFFF0F4FA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$currentRating/5',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: currentRating == 0
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4D8FF7),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF596579),
                ),
              ),
            ],
          ),
          Row(
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return GestureDetector(
                onTap: () {
                  // إذا كانت النجمة المحددة حالياً هي نفس النجمة المكبوسة، يتم النزول للصفر (0)
                  if (currentRating == starValue) {
                    onRatingSelected(0);
                  } else {
                    onRatingSelected(starValue);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    starValue <= currentRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: starValue <= currentRating
                        ? const Color(0xFFFFB020)
                        : const Color(0xFFCBD5E1),
                    size: 22,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
