import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ApplicantsMonthlyDetailsScreen extends StatefulWidget {
  const ApplicantsMonthlyDetailsScreen({super.key});

  @override
  State<ApplicantsMonthlyDetailsScreen> createState() =>
      _ApplicantsMonthlyDetailsScreenState();
}

class _ApplicantsMonthlyDetailsScreenState
    extends State<ApplicantsMonthlyDetailsScreen> {
  String selectedPeriod = 'آخر 6 أشهر';

  final Map<String, List<MonthData>> periods = {
    'آخر 3 أشهر': [
      MonthData('مارس', 42),
      MonthData('أبريل', 57),
      MonthData('مايو', 68),
    ],
    'آخر 6 أشهر': [
      MonthData('يناير', 20),
      MonthData('فبراير', 36),
      MonthData('مارس', 42),
      MonthData('أبريل', 57),
      MonthData('مايو', 68),
    ],
    'آخر سنة': [
      MonthData('يونيو', 15),
      MonthData('يوليو', 18),
      MonthData('أغسطس', 21),
      MonthData('سبتمبر', 24),
      MonthData('أكتوبر', 27),
      MonthData('نوفمبر', 25),
      MonthData('ديسمبر', 18),
      MonthData('يناير', 20),
      MonthData('فبراير', 36),
      MonthData('مارس', 42),
      MonthData('أبريل', 57),
      MonthData('مايو', 68),
    ],
    'كل الفترة': [
      MonthData('يونيو', 15),
      MonthData('يوليو', 18),
      MonthData('أغسطس', 21),
      MonthData('سبتمبر', 24),
      MonthData('أكتوبر', 27),
      MonthData('نوفمبر', 25),
      MonthData('ديسمبر', 18),
      MonthData('يناير', 20),
      MonthData('فبراير', 36),
      MonthData('مارس', 42),
      MonthData('أبريل', 57),
      MonthData('مايو', 68),
    ],
  };

  List<MonthData> get currentData => periods[selectedPeriod]!;

  // تثبيت إجمالي المتقدمين على 248 بناءً على طلبك
  int get totalApplicants => 248;

  double get average {
    if (currentData.isEmpty) return 0;
    int sum = currentData.fold(0, (prev, element) => prev + element.value);
    return sum / currentData.length;
  }

  MonthData get highest {
    return currentData.reduce((a, b) => a.value > b.value ? a : b);
  }

  MonthData get lowest {
    return currentData.reduce((a, b) => a.value < b.value ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff4f7fb),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                const SizedBox(height: 18),
                buildSummary(),
                const SizedBox(height: 18),
                buildChart(),
                const SizedBox(height: 18),
                buildTable(),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffeaf3ff),
                      foregroundColor: const Color(0xff0869e8),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 1. الهيدر بدون أزرار رجوع علوية وعناوين تبدأ من اليمين
  // ============================================================
  Widget buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xffeaf3ff),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.bar_chart,
                      color: Color(0xff0869e8),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    'تفاصيل أعداد المتقدمين شهرياً',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff132f5e),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'يمكنك الاطلاع على الإحصائيات التفصيلية لأعداد المتقدمين خلال الفترة المحددة',
                style: TextStyle(color: Color(0xff71819b), fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PopupMenuButton<String>(
              onSelected: (value) => setState(() => selectedPeriod = value),
              itemBuilder: (context) => periods.keys.map((period) {
                return PopupMenuItem<String>(
                  value: period,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(period, style: const TextStyle(fontSize: 13)),
                  ),
                );
              }).toList(),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffd6e2f1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Color(0xff17396d),
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      selectedPeriod,
                      style: const TextStyle(
                        color: Color(0xff17396d),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff17396d),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // تعديل رسالة التنبيه لتصبح "تم تصدير التقرير بنجاح"
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تصدير التقرير بنجاح')),
                );
              },
              icon: const Icon(Icons.download, size: 16),
              label: const Text(
                'تصدير التقرير',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0869e8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // 2. الكروت العلوية (Summary Cards) - تم تعديل أسلوب وحجم الخطوط لتطابق الصورة
  // ============================================================
  Widget buildSummary() {
    return Row(
      children: [
        Expanded(
          child: buildCard(
            'إجمالي المتقدمين',
            '$totalApplicants',
            'متقدم',
            Icons.people_outline,
            const Color(0xff0869e8),
            const Color(0xffeaf3ff),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildCard(
            'متوسط المتقدمين شهرياً',
            average.toStringAsFixed(1),
            'متقدم',
            Icons.analytics_outlined,
            const Color(0xff0869e8),
            const Color(0xffeaf3ff),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildCard(
            'أعلى شهر',
            '${highest.value}',
            highest.month,
            Icons.trending_up,
            const Color(0xff10b981),
            const Color(0xffe6f4ea),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildCard(
            'أقل شهر',
            '${lowest.value}',
            lowest.month,
            Icons.trending_down,
            const Color(0xffef4444),
            const Color(0xfffde8e8),
          ),
        ),
      ],
    );
  }

  Widget buildCard(
    String title,
    String val,
    String sub,
    IconData icon,
    Color color,
    Color bgIcon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffeef2f6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff1e293b),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  val,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0f172a),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(
                    color: Color(0xff64748b),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgIcon,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. الرسم البياني (Line Chart)
  // ============================================================
  Widget buildChart() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffeef2f6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أعداد المتقدمين شهرياً',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xff132f5e),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) =>
                      FlLine(color: const Color(0xfff1f5f9), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}',
                        style: const TextStyle(
                          color: Color(0xff94a3b8),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        int index = val.toInt();
                        if (index >= 0 && index < currentData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              currentData[index].month,
                              style: const TextStyle(
                                color: Color(0xff71819b),
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: currentData
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(
                            e.key.toDouble(),
                            e.value.value.toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xff0869e8),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xff0869e8).withOpacity(0.2),
                          const Color(0xff0869e8).withOpacity(0.01),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 4. الجدول التفصيلي (Data Table)
  // ============================================================
  Widget buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffeef2f6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.list_alt, color: Color(0xff0869e8), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'الجدول التفصيلي',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff132f5e),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: periods.keys.map((p) {
                    bool isSelected = selectedPeriod == p;
                    return GestureDetector(
                      onTap: () => setState(() => selectedPeriod = p),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff0869e8)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff71819b),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: const Color(0xfff1f5f9)),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xfff8fafc),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'الشهر',
                    style: TextStyle(
                      color: Color(0xff132f5e),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'عدد المتقدمين',
                    style: TextStyle(
                      color: Color(0xff132f5e),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'نسبة التغيير',
                    style: TextStyle(
                      color: Color(0xff132f5e),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: currentData.asMap().entries.map((entry) {
                int index = entry.key;
                MonthData item = entry.value;

                String changeText = '-';
                Color changeColor = const Color(0xff71819b);
                if (index > 0) {
                  int prevValue = currentData[index - 1].value;
                  if (prevValue != 0) {
                    double change =
                        ((item.value - prevValue) / prevValue) * 100;
                    changeText =
                        '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
                    changeColor = change > 0
                        ? const Color(0xff10b981)
                        : const Color(0xffef4444);
                  }
                }

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.month,
                        style: const TextStyle(color: Color(0xff475569)),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.value}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff132f5e),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        changeText,
                        style: TextStyle(
                          color: changeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthData {
  final String month;
  final int value;
  MonthData(this.month, this.value);
}
