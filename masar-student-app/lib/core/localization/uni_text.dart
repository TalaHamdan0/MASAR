import 'package:flutter/material.dart';
import '../state/university_dashboard_preferences.dart';

class UniLocalizations {
  static const Map<String, String> _en = {
    'الرئيسية': 'Home',
    'الطلاب': 'Students',
    'الشركات': 'Companies',
    'طلبات التدريب': 'Training Applications',
    'التدريبات الحالية': 'Current Trainings',
    'التقارير': 'Reports',
    'الإشعارات': 'Notifications',
    'الإعدادات': 'Settings',
    'تسجيل الخروج': 'Log out',
    'إلغاء': 'Cancel',
    'هل أنت متأكد أنك تريد تسجيل الخروج من لوحة التحكم؟':
        'Are you sure you want to log out of the dashboard?',
    'مسؤول التدريب': 'Training Administrator',
    'University Dashboard': 'University Dashboard',
    'بوابة الجامعة': 'University Portal',
    'إدارة ومتابعة برامج التدريب الميداني':
        'Manage and monitor field training programs',
    'الرقم الجامعي / الوظيفي': 'University / Employee Number',
    'الرقم الوظيفي': 'Employee Number',
    'الجامعة': 'University',
    'الحساب': 'Account',
    'الإعدادات العامة': 'General Settings',
    'التدريبات': 'Trainings',
    'عن النظام': 'About',
    'لغة النظام': 'System Language',
    'مظهر النظام': 'Appearance',
    'منصة مسار': 'MASAR Platform',
    'إدارة إعدادات بوابة الجامعة وتفضيلات النظام':
        'Manage the university portal settings and system preferences',
    'إشعارات حول حالة التدريبات الحالية':
        'Notifications about current training status',
    'إعادة المحاولة': 'Try Again',
    'استلام إشعار عند وصول طلب تدريب جديد':
        'Receive a notification when a new training application arrives',
    'التنبيه عند وجود تقرير تدريبي يحتاج إلى مراجعة':
        'Get notified when a training report needs review',
    'العربية': 'Arabic',
    'الوضع الداكن': 'Dark mode',
    'الوضع الفاتح': 'Light mode',
    'بوابة إدارة ومتابعة برامج التدريب الميداني':
        'Portal for managing and monitoring field training programs',
    'ابحث باسم الطالب، الرقم الجامعي، التخصص أو المسار...':
        'Search by student name, university number, major or career path...',
    'اسم الطالب': 'Student Name',
    'البريد الإلكتروني': 'Email',
    'التخصص': 'Major',
    'التدريب المكتمل': 'Completed Training',
    'التفاصيل': 'Details',
    'الحسابات النشطة': 'Active Accounts',
    'الرقم الجامعي': 'University Number',
    'الشهادات': 'Certificates',
    'الطالب': 'Student',
    'الكل': 'All',
    'المسار المهني': 'Career Path',
    'المسار والتدريب': 'Career Path & Training',
    'المشاريع': 'Projects',
    'المعدل التراكمي': 'GPA',
    'المعلومات الأكاديمية': 'Academic Information',
    'المهارات': 'Skills',
    'حالة التدريب': 'Training Status',
    'حالة الحساب': 'Account Status',
    'حدث خطأ أثناء تحميل بيانات الطلاب.':
        'An error occurred while loading student data.',
    'حساب نشط': 'Active Account',
    'رقم الهاتف': 'Phone Number',
    'ساعات التدريب': 'Training Hours',
    'طالب': 'Student',
    'طالب مسجل': 'Registered Student',
    'عرض التفاصيل': 'View Details',
    'غير محدد': 'Not specified',
    'في التدريب': 'In Training',
    'قائمة الطلاب': 'Students List',
    'لا توجد نتائج تطابق البحث أو الفلاتر':
        'No results match your search or filters',
    'لا يوجد طلاب مسجلون حاليًا': 'There are no registered students currently',
    'لم يبدأ': 'Not Started',
    'متأخر': 'Delayed',
    'مستمر': 'Ongoing',
    'مكتمل': 'Completed',
    'مكتملة': 'Completed',
    'ملغي': 'Cancelled',
    'نشط': 'Active',
    'نشطة': 'Active',
    'متوقفة مؤقتًا': 'Temporarily paused',
    'إجمالي التدريبات': 'Total Trainings',
    'ابحث باسم الطالب أو الرقم الجامعي أو الشركة...':
        'Search by student name, university number or company...',
    'الالتزام والانضباط': 'Commitment & Discipline',
    'التقييم السري': 'Confidential Evaluation',
    'التقييم العام': 'Overall Evaluation',
    'التقييم سري وغير متاح للطالب':
        'This evaluation is confidential and is not available to the student',
    'الحالة': 'Status',
    'الشركة': 'Company',
    'الفترة': 'Period',
    'المسار': 'Track',
    'بيانات التدريب': 'Training Information',
    'بيانات الطالب': 'Student Information',
    'تاريخ إرسال التقييم': 'Evaluation Submission Date',
    'تاريخ البداية': 'Start Date',
    'تاريخ النهاية': 'End Date',
    'تدريبات مستمرة': 'Ongoing Trainings',
    'تفاصيل التدريب': 'Training Details',
    'تقييم جهة التدريب - سري عن الطالب':
        'Company Evaluation - Confidential to Student',
    'تقييم جهة التدريب السري': 'Confidential Company Evaluation',
    'تم استلام التقييم السري. اضغط على "عرض التقييم" لعرض التفاصيل.':
        'The confidential evaluation has been received. Select "View Evaluation" to see its details.',
    'جهة التدريب': 'Training Provider',
    'عرض التقييم': 'View Evaluation',
    'قريب من الإنجاز': 'Near Completion',
    'قريبة من الإنجاز': 'Near Completion',
    'لا توجد تدريبات مطابقة للبحث أو الفلتر':
        'No trainings match your search or filter',
    'لم يتم استلام التقييم السري من جهة التدريب حتى الآن.':
        'The confidential evaluation has not been received from the training provider yet.',
    'لم يصل': 'Not received',
    'وصل': 'Received',
    'ملاحظات جهة التدريب': 'Training Provider Notes',
    'التقارير والإحصائيات': 'Reports & Analytics',
    'الطلاب المتدربون': 'Trainees',
    'تقرير الشركات': 'Company Report',
    'توزيع الطلاب حسب الساعات المكتملة': 'Students by Completed Hours',
    'ساعة لكل طالب': 'hours per student',
    'طالب أكمل الساعات': 'Students completed their hours',
    'لا توجد بيانات ساعات تدريب لهذه الفترة':
        'No training-hours data for this period',
    'لا توجد بيانات شركات لهذه الفترة': 'No company data for this period',
    'متوسط الساعات': 'Average Hours',
    'من إجمالي التدريبات': 'of total trainings',
    'نسبة الإكمال': 'Completion Rate',
    'نظرة شاملة على أداء التدريب والطلاب':
        'An overview of training and student performance',
    'نظرة عامة على الساعات': 'Hours Overview',
    'هذا الأسبوع': 'This Week',
    'هذا الشهر': 'This Month',
    'هذا العام': 'This Year',
    'هذا الفصل': 'This Semester',
    'أحدث طلبات التدريب': 'Latest Training Applications',
    'إجمالي الطلاب': 'Total Students',
    'التاريخ': 'Date',
    'التدريب المتوفر': 'Available Training',
    'التنبيهات المهمة': 'Important Alerts',
    'الشركات المسجلة': 'Registered Companies',
    'الطلاب بالتدريب': 'Students in Training',
    'الطلاب حسب التخصص': 'Students by Major',
    'الفصل التدريبي 2026 / 2027': 'Training Semester 2026 / 2027',
    'تابع أداء الطلبة وإدارة برامج التدريب من مكان واحد.':
        'Monitor student performance and manage training programs in one place.',
    'تحتاج مراجعة': 'Needs Review',
    'تدريبات مكتملة': 'Completed Trainings',
    'تعذر تحميل بيانات الصفحة': 'Unable to load page data',
    'تقارير بحاجة للمراجعة': 'Reports need review',
    'جديد': 'New',
    'حدث خطأ أثناء تحميل البيانات.': 'An error occurred while loading data.',
    'شركة': 'Company',
    'طالب يتدرب حالياً': 'Student currently training',
    'طلاب قريبون من إكمال التدريب': 'Students close to completing training',
    'طلبات تدريب جديدة': 'New Training Applications',
    'طلبات جديدة': 'New Applications',
    'قيد التدريب': 'In Training',
    'لا توجد بيانات طلاب لعرضها حالياً.':
        'There is no student data to display right now.',
    'لا توجد طلبات تدريب حالياً.':
        'There are no training applications currently.',
    'مقبول': 'Accepted',
    'قيد المراجعة': 'Under Review',
    'مرفوض': 'Rejected',
    'إجمالي الطلبات': 'Total Applications',
    'إغلاق': 'Close',
    'ابحث باسم الطالب أو رقمه أو الشركة أو التدريب':
        'Search by student name, number, company or training',
    'التدريب': 'Training',
    'التدريب المطلوب': 'Requested Training',
    'الطلبات المرفوضة': 'Rejected Applications',
    'الطلبات المقبولة': 'Accepted Applications',
    'الوثائق': 'Documents',
    'الوثائق المرفقة': 'Attached Documents',
    'تاريخ التقديم': 'Submission Date',
    'تاريخ الطلب': 'Application Date',
    'تعرض هذه الصفحة تفاصيل الطلب وحالته الحالية.':
        'This page displays the application details and its current status.',
    'تفاصيل طلب التدريب': 'Training Application Details',
    'حالة الطلب': 'Application Status',
    'عرض': 'View',
    'كل الحالات': 'All statuses',
    'لا توجد طلبات مطابقة للبحث': 'No applications match your search',
    'متابعة طلبات الطلاب والاطلاع على تفاصيل كل طلب وحالته.':
        'Track student applications and view each application details and status.',
    'معلومات الطالب': 'Student Information',
    'معلومات الطلب': 'Application Information',
    'إجمالي الفرص': 'Total Opportunities',
    'إدارة الجهات التدريبية ومتابعة الشركات المسجلة في المنصة':
        'Manage training providers and monitor companies registered on the platform',
    'إدارة الشركات': 'Company Management',
    'إعادة ضبط الفلاتر': 'Reset Filters',
    'ابحث باسم الشركة أو المجال أو الموقع...':
        'Search by company name, field or location...',
    'التدريبات المتوفرة': 'Available Trainings',
    'الشركات المتاحة للتدريب': 'Companies Available for Training',
    'الشركات النشطة': 'Active Companies',
    'المتدربون': 'Trainees',
    'المجال': 'Field',
    'الموقع': 'Location',
    'حالة الشركة': 'Company Status',
    'فرصة تدريب': 'Training Opportunity',
    'كل المجالات': 'All fields',
    'لا توجد شركات مطابقة للبحث': 'No companies match your search',
    'لا يوجد طلاب متدربون حاليًا': 'There are no trainees currently',
    'نبذة عن الشركة': 'About the Company',
    'تابع آخر المستجدات والإجراءات المطلوبة':
        'Follow the latest updates and required actions',
    'تحتاج بعض الإشعارات إلى مراجعة أو إجراء':
        'Some notifications need review or action',
    'تحديد الكل كمقروء': 'Mark All as Read',
    'تحديد كمقروء': 'Mark as Read',
    'خيارات': 'Options',
    'غير مقروءة': 'Unread',
    'لا توجد إشعارات حاليًا': 'There are no notifications right now',
    'لا توجد إشعارات غير مقروءة': 'There are no unread notifications',
    'أدخل الرقم الجامعي/الوظيفي': 'Enter the university / employee number',
    'يرجى إدخال الرقم الجامعي / الوظيفي':
        'Please enter the university / employee number',
    'يرجى إدخال رقم وظيفي صحيح': 'Please enter a valid employee number',
    'حدث خطأ غير متوقع أثناء تسجيل الدخول.':
        'An unexpected error occurred during sign in.',
    'تعذر حفظ الإعدادات:': 'Unable to save settings:',
    'تم حفظ الإعدادات بنجاح': 'Settings saved successfully',
    'تعذر تحديث الإشعارات:': 'Unable to update notifications:',
    'تعذر تحديد الإشعار كمقروء:': 'Unable to mark notification as read:',
    'تم تحديد جميع الإشعارات كمقروءة':
        'All notifications have been marked as read',
    'إدارة ومتابعة بيانات الطلاب وحالة التدريب':
        'Manage and monitor student records and training status',
    'قائمة التدريبات': 'Training List',
    'متابعة الطلاب المسجلين حاليًا في برامج التدريب الميداني':
        'Monitor students currently enrolled in field training programs',
    'أمس': 'Yesterday',
    'اختر لغة النظام': 'Choose system language',
    'اختر مظهر النظام': 'Choose system appearance',
    'تعذر حفظ الإعداد العام:': 'Unable to save general setting:',
    'قائمة طلبات التدريب': 'Training Applications List',
    'v1.0.0': 'v1.0.0',
    'جامعة العلوم الإسلامية العالمية':
        'The World Islamic Sciences and Education University',
    'الآن': 'Now',
    'أكملوا 280 ساعة': 'Completed 280 hours',
    'طالب نشط في التدريب': 'active student in training',
    'لا توجد وثائق مرفقة': 'No documents attached',
    'الإجراء': 'Action',
    'قبول': 'Accept',
    'رفض': 'Reject',
    'تأكيد قبول الطلب': 'Confirm Application Acceptance',
    'تأكيد رفض الطلب': 'Confirm Application Rejection',
    'هل أنت متأكدة من قبول طلب التدريب لهذا الطالب؟':
        "Are you sure you want to accept this student's training application?",
    'هل أنت متأكدة من رفض طلب التدريب لهذا الطالب؟':
        "Are you sure you want to reject this student's training application?",
    'تأكيد القبول': 'Confirm Acceptance',
    'تأكيد الرفض': 'Confirm Rejection',
    'تم قبول طلب التدريب بنجاح':
        'The training application was accepted successfully',
    'تم رفض طلب التدريب بنجاح':
        'The training application was rejected successfully',
    'بانتظار مراجعة الشركة': 'Waiting for company review',
    'لا يتطلب إجراءً من الجامعة': 'No university action is required',
  };

  static String translate(String value) {
    if (!UniversityDashboardPreferences.instance.isEnglish) return value;
    final direct = _en[value];
    if (direct != null) return direct;

    if (value.startsWith('مرحباً ')) {
      return 'Welcome, ${value.substring('مرحباً '.length)}';
    }
    if (value.startsWith('منذ ') && value.endsWith(' دقيقة')) {
      return '${value.substring('منذ '.length, value.length - ' دقيقة'.length)} minutes ago';
    }
    if (value.startsWith('منذ ') && value.endsWith(' ساعة')) {
      return '${value.substring('منذ '.length, value.length - ' ساعة'.length)} hours ago';
    }
    if (value.startsWith('قبل ') && value.endsWith(' أيام')) {
      return '${value.substring(4, value.length - 4)} days ago';
    }
    if (value.startsWith('منذ ') && value.endsWith(' أيام')) {
      return '${value.substring('منذ '.length, value.length - ' أيام'.length)} days ago';
    }
    if (value.endsWith(' إشعارات غير مقروءة')) {
      return '${value.substring(0, value.length - ' إشعارات غير مقروءة'.length)} unread notifications';
    }
    if (value.endsWith(' ساعة')) {
      return '${value.substring(0, value.length - ' ساعة'.length)} hours';
    }
    if (value.endsWith(' طلب')) {
      return '${value.substring(0, value.length - ' طلب'.length)} requests';
    }
    if (value.endsWith(' تقارير')) {
      return '${value.substring(0, value.length - ' تقارير'.length)} reports';
    }
    if (value.endsWith(' طالب')) {
      return '${value.substring(0, value.length - ' طالب'.length)} students';
    }
    if (value.endsWith(' شركة')) {
      return '${value.substring(0, value.length - ' شركة'.length)} companies';
    }
    if (value.endsWith(' وثيقة مرفقة')) {
      final count = value.substring(0, value.length - ' وثيقة مرفقة'.length);
      return '$count attached documents';
    }
    if (value.startsWith('يوجد ') &&
        value.contains(' طلب تدريب جديد بحاجة إلى مراجعة.')) {
      final count = value.substring(5, value.indexOf(' طلب تدريب جديد'));
      return '$count new training applications need review.';
    }
    if (value.startsWith('يوجد ') &&
        value.contains(' تقرير تدريبي بانتظار المراجعة.')) {
      final count = value.substring(5, value.indexOf(' تقرير تدريبي'));
      return '$count training reports are waiting for review.';
    }
    if (value.startsWith('تم إكمال ') &&
        value.contains(' تدريبات خلال هذا الأسبوع.')) {
      final count = value.substring(
        'تم إكمال '.length,
        value.indexOf(' تدريبات'),
      );
      return '$count trainings were completed this week.';
    }
    if (value.startsWith('تعذر حفظ الإعدادات:')) {
      return 'Unable to save settings: ${value.substring('تعذر حفظ الإعدادات:'.length).trim()}';
    }
    if (value.startsWith('تعذر تحديث الإشعارات:')) {
      return 'Unable to update notifications: ${value.substring('تعذر تحديث الإشعارات:'.length).trim()}';
    }
    if (value.startsWith('تعذر تحديد الإشعار كمقروء:')) {
      return 'Unable to mark notification as read: ${value.substring('تعذر تحديد الإشعار كمقروء:'.length).trim()}';
    }
    if (value.startsWith('تعذر تحديث حالة الطلب:')) {
      return 'Unable to update application status: ${value.substring('تعذر تحديث حالة الطلب:'.length).trim()}';
    }
    return value;
  }
}

/// Same API shape as the common Text constructor, with dashboard-only
/// Arabic/English translation applied to its displayed string.
class UniText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const UniText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
    // Listen directly to preference changes. Some dashboard labels are
    // const UniText widgets inside const subtrees, so relying only on the
    // page's rebuild can leave their translated value stale. This listener
    // updates every UniText immediately when the language changes.
    return AnimatedBuilder(
      animation: UniversityDashboardPreferences.instance,
      builder: (context, _) {
        return Text(
          UniLocalizations.translate(data),
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
        );
      },
    );
  }
}
