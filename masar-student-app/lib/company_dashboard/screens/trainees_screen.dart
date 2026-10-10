import 'package:flutter/material.dart';

// ============================================================
// Model المتدرب
// ============================================================

class Trainee {
  final int id;
  final String name;
  final String track;
  final String startDate;
  final int completedHours;
  final int totalHours;
  final int attendanceDays;
  final int absenceDays;
  final List<String> weeklyReports;

  Trainee({
    required this.id,
    required this.name,
    required this.track,
    required this.startDate,
    required this.completedHours,
    required this.totalHours,
    required this.attendanceDays,
    required this.absenceDays,
    required this.weeklyReports,
  });

  double get progressPercentage =>
      (completedHours / totalHours).clamp(0.0, 1.0);

  int get remainingHours => totalHours - completedHours;
}

// ============================================================
// الشاشة الرئيسية للمتدربين
// ============================================================

class TraineesScreen extends StatefulWidget {
  const TraineesScreen({super.key});

  @override
  State<TraineesScreen> createState() => _TraineesScreenState();
}

class _TraineesScreenState extends State<TraineesScreen> {
  String searchQuery = '';

  // ============================================================
  // بيانات المتدربين
  // ============================================================

  final List<Trainee> trainees = [
    Trainee(
      id: 1,
      name: 'ليان أحمد',
      track: 'Data Analysis',
      startDate: '2026/09/01',
      completedHours: 164,
      totalHours: 280,
      attendanceDays: 22,
      absenceDays: 1,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
        'الأسبوع الثاني - مكتمل',
        'الأسبوع الثالث - قيد المراجعة',
      ],
    ),
    Trainee(
      id: 2,
      name: 'أحمد محمود',
      track: 'Web Development',
      startDate: '2026/08/15',
      completedHours: 210,
      totalHours: 280,
      attendanceDays: 28,
      absenceDays: 0,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
        'الأسبوع الثاني - مكتمل',
        'الأسبوع الثالث - مكتمل',
        'الأسبوع الرابع - مكتمل',
      ],
    ),
    Trainee(
      id: 3,
      name: 'سارة خالد',
      track: 'UI/UX Design',
      startDate: '2026/09/10',
      completedHours: 90,
      totalHours: 280,
      attendanceDays: 12,
      absenceDays: 2,
      weeklyReports: ['الأسبوع الأول - مكتمل'],
    ),
    Trainee(
      id: 4,
      name: 'عمر الفاروق',
      track: 'Networking',
      startDate: '2026/08/01',
      completedHours: 240,
      totalHours: 280,
      attendanceDays: 31,
      absenceDays: 0,
      weeklyReports: [
        'الأسبوع الأول - مكتمل',
        'الأسبوع الثاني - مكتمل',
        'الأسبوع الثالث - مكتمل',
        'الأسبوع الرابع - مكتمل',
        'الأسبوع الخامس - قيد المراجعة ',
      ],
    ),
    Trainee(
      id: 5,
      name: 'رنيم السعيد',
      track: 'Programming',
      startDate: '2026/09/05',
      completedHours: 120,
      totalHours: 280,
      attendanceDays: 16,
      absenceDays: 1,
      weeklyReports: ['الأسبوع الأول - مكتمل', 'الأسبوع الثاني - مكتمل'],
    ),
    Trainee(
      id: 6,
      name: 'حمزة العمري',
      track: 'CyberSecurity',
      startDate: '2026/09/12',
      completedHours: 75,
      totalHours: 280,
      attendanceDays: 10,
      absenceDays: 0,
      weeklyReports: ['الأسبوع الأول - مكتمل'],
    ),
  ];

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final filteredTrainees = trainees.where((t) {
      return t.name.contains(searchQuery) ||
          t.track.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildTraineesList(filteredTrainees),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header الشاشة مع زر الرجوع
  // ============================================================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المتدربين',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17243A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'قائمة الطلاب الذين تم قبولهم ويباشرون التدريب حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: Color(0xFF7C899E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // شريط البحث
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: TextField(
        onChanged: (val) {
          setState(() {
            searchQuery = val.trim();
          });
        },
        decoration: const InputDecoration(
          hintText: 'ابحث باسم المتدرب أو المسار التدريبي...',
          hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 13),
          prefixIcon: Icon(Icons.search, color: Color(0xFF0D6EFD)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ============================================================
  // قائمة المتدربين
  // ============================================================

  Widget _buildTraineesList(List<Trainee> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Text(
            'لا يوجد متدربون مطابقون للبحث',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final trainee = list[index];
        return _buildTraineeCard(trainee);
      },
    );
  }

  // ============================================================
  // بطاقة المتدرب
  // ============================================================

  Widget _buildTraineeCard(Trainee trainee) {
    final percentageInt = (trainee.progressPercentage * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE7F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFEBF3FE),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF1D61E7),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainee.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF17243A),
                        ),
                      ),
                      Text(
                        trainee.track,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '%$percentageInt',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D6EFD),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==================================================
          // الساعات
          // ==================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الساعات: ${trainee.completedHours} / ${trainee.totalHours} ساعة',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A6A85),
                ),
              ),
              Text(
                'المتبقية: ${trainee.remainingHours} ساعة',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ==================================================
          // شريط التقدم
          // ==================================================
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFEBF1F9),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 10,
                      width: constraints.maxWidth * trainee.progressPercentage,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0D6EFD),
                            Color(0xFF0040A8),
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ==================================================
          // زر التفاصيل
          // ==================================================
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () => _showTraineeDetailsDialog(trainee),
              icon: const Icon(Icons.person_search, size: 18),
              label: const Text(
                'عرض تفاصيل الطالب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EFD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Modal التفاصيل
  // ============================================================

  void _showTraineeDetailsDialog(Trainee trainee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.account_circle,
                  color: Color(0xFF0D6EFD),
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تفاصيل المتدرب: ${trainee.name}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),

                    _buildSectionHeader('المعلومات والمسار'),

                    _buildInfoRow('اسم الطالب:', trainee.name),

                    _buildInfoRow('المسار التدريبي:', trainee.track),

                    _buildInfoRow('تاريخ بداية التدريب:', trainee.startDate),

                    const SizedBox(height: 16),

                    _buildSectionHeader('الساعات والتقدم'),

                    _buildInfoRow(
                      'الساعات المنجزة:',
                      '${trainee.completedHours} ساعة',
                    ),

                    _buildInfoRow(
                      'الساعات المتبقية:',
                      '${trainee.remainingHours} ساعة',
                    ),

                    _buildInfoRow(
                      'الإجمالي المطلوبة:',
                      '${trainee.totalHours} ساعة',
                    ),

                    const SizedBox(height: 16),

                    _buildSectionHeader('الحضور والغياب ⏱️'),

                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBadge(
                            'أيام الحضور',
                            '${trainee.attendanceDays} يوم',
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBadge(
                            'أيام الغياب',
                            '${trainee.absenceDays} يوم',
                            Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionHeader('التقارير الأسبوعية 📝'),

                    ...trainee.weeklyReports.map(
                      (report) => Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.description,
                              size: 18,
                              color: Color(0xFF0D6EFD),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                report,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
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
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // عناصر المساعدة للبناء (Helper Widgets)
  // ============================================================

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D6EFD),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: Color(0xFF5A6A85),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17243A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
