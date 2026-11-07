
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = 'هذا الشهر';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التقارير والإحصائيات',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: MasarColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'نظرة شاملة على أداء التدريب والطلاب',
                        style: TextStyle(
                          fontSize: 13,
                          color: MasarColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: MasarColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: MasarColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: MasarColors.textSecondary,
                        ),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: MasarColors.textPrimary,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'هذا الأسبوع',
                            child: Text('هذا الأسبوع'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا الشهر',
                            child: Text('هذا الشهر'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا الفصل',
                            child: Text('هذا الفصل'),
                          ),
                          DropdownMenuItem(
                            value: 'هذا العام',
                            child: Text('هذا العام'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedPeriod = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'الطلاب المتدربون',
                      value: '346',
                      subtitle: 'طالب نشط في التدريب',
                      icon: Icons.people_alt_rounded,
                      iconColor: MasarColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'نسبة الإكمال',
                      value: '74%',
                      subtitle: 'من إجمالي التدريبات',
                      icon: Icons.donut_large_rounded,
                      iconColor: MasarColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'أكملوا 280 ساعة',
                      value: '254',
                      subtitle: 'طالب أكمل الساعات',
                      icon: Icons.check_circle_outline,
                      iconColor: MasarColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'متوسط الساعات',
                      value: '207',
                      subtitle: 'ساعة لكل طالب',
                      icon: Icons.access_time_rounded,
                      iconColor: MasarColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _hoursOverview(),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 2,
                    child: _companyReport(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 20,
                color: MasarColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.5,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hoursOverview() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: MasarColors.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نظرة عامة على الساعات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'توزيع الطلاب حسب الساعات المكتملة',
                    style: TextStyle(
                      fontSize: 11,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          _progressRow(
            title: 'أقل من 100 ساعة',
            value: 0.18,
            count: '62 طالب',
          ),
          const SizedBox(height: 18),
          _progressRow(
            title: '100 - 200 ساعة',
            value: 0.26,
            count: '90 طالب',
          ),
          const SizedBox(height: 18),
          _progressRow(
            title: '200 - 279 ساعة',
            value: 0.29,
            count: '100 طالب',
          ),
          const SizedBox(height: 18),
          _progressRow(
            title: '280 ساعة أو أكثر',
            value: 0.27,
            count: '94 طالب',
          ),
        ],
      ),
    );
  }

  Widget _progressRow({
    required String title,
    required double value,
    required String count,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: 11,
                color: MasarColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 9,
            backgroundColor: MasarColors.lightBlue,
            valueColor: AlwaysStoppedAnimation<Color>(
              MasarColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _companyReport() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MasarColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.business_rounded,
                  color: MasarColors.primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تقرير الشركات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _companyRow('شركة التقنية', '42 طالب', 0.82),
          const SizedBox(height: 18),
          _companyRow('شركة البرمجيات', '36 طالب', 0.71),
          const SizedBox(height: 18),
          _companyRow('شركة الحلول الرقمية', '29 طالب', 0.64),
          const SizedBox(height: 18),
          _companyRow('شركة المستقبل', '24 طالب', 0.52),
        ],
      ),
    );
  }

  Widget _companyRow(
    String name,
    String students,
    double value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
            Text(
              students,
              style: TextStyle(
                fontSize: 10.5,
                color: MasarColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: MasarColors.lightGreen,
            valueColor: AlwaysStoppedAnimation<Color>(
              MasarColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }
}
