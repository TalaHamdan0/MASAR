import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'auth_session.dart';

class TrainingService {
  static const Duration _timeout = Duration(seconds: 20);
  static const String _trainingPath = '/api/v1/students/training';

  static Map<String, String> _headers() {
    final token = AuthSession.accessToken;
    if (token == null || token.trim().isEmpty) {
      throw const ApiException('يرجى تسجيل الدخول أولًا.');
    }
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // تم إزالة التعقيد وجعل الـ Return ديناميكي وآمن
  static Future<dynamic> _sendRequest(
    String method,
    String path, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? bodyData,
  }) async {
    final headers = _headers();
    final baseUri = Uri.parse(ApiService.baseUrl);

    var uri = baseUri.replace(path: '${baseUri.path}$path');
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    try {
      http.Response response;
      if (method == 'GET') {
        response = await http.get(uri, headers: headers).timeout(_timeout);
      } else {
        response = await http
            .post(uri, headers: headers, body: jsonEncode(bodyData))
            .timeout(_timeout);
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 401) {
        throw const ApiException(
          'انتهت جلسة الدخول. يرجى تسجيل الدخول مجددًا.',
        );
      }
      if (response.statusCode == 403) {
        throw const ApiException('لا توجد صلاحية للقيام بهذا الإجراء.');
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (decoded is Map &&
            (decoded['message'] != null || decoded['error'] != null)) {
          throw ApiException(decoded['message'] ?? decoded['error']);
        }
        throw ApiException('حدث خطأ (رمز الخطأ: ${response.statusCode}).');
      }

      return decoded;
    } on TimeoutException {
      throw const ApiException('انتهت مهلة الاتصال. حاول مجددًا.');
    } on http.ClientException {
      throw const ApiException('تعذر الاتصال بالخادم. تأكد من تشغيل الباكند.');
    }
  }

  // تقديم الطالب على فرصة تدريب (يعتمد على الـ Token وجلسة المستخدم في الباك إند)
  static Future<dynamic> applyForTraining({required int opportunityId}) async {
    if (opportunityId <= 0) {
      throw const ApiException('معلومات فرصة التدريب غير صالحة.');
    }

    return await _sendRequest(
      'POST',
      '$_trainingPath/apply',
      bodyData: {'opportunity_id': opportunityId},
    );
  }

  // متابعة الطالب لطلباته وحالتها (بدون الحاجة لتمرير رقم الطالب يدوياً)
  static Future<List<TrainingApplication>> getStudentApplications() async {
    final body = await _sendRequest('GET', '$_trainingPath/applications');
    final data = body['applications'] ?? body['data'];
    if (data is! List) {
      throw const ApiException('قائمة الطلبات غير صالحة.');
    }

    return data
        .map((item) => TrainingApplication.fromJson(_asObject(item)))
        .toList();
  }

  // جلب فرص التدريب مع البحث والفلاتر والصفحات
  static Future<TrainingOffersPage> getOffers({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? governorate,
    int? trackId,
  }) async {
    if (page < 1 || pageSize < 1 || pageSize > 100) {
      throw const ApiException('إعدادات تحميل فرص التدريب غير صالحة.');
    }

    final query = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (governorate != null && governorate.trim().isNotEmpty) {
      query['governorate'] = governorate.trim();
    }
    if (trackId != null) {
      query['track_id'] = trackId.toString();
    }

    final body = await _sendRequest(
      'GET',
      '$_trainingPath/offers',
      queryParameters: query,
    );
    final data = body['data'];
    if (data is! List) {
      throw const ApiException('قائمة فرص التدريب غير صالحة.');
    }

    return TrainingOffersPage(
      offers: data
          .map((item) => TrainingOffer.fromJson(_asObject(item)))
          .toList(),
      page: _asInt(body['page']),
      pageSize: _asInt(body['page_size']),
      total: _asInt(body['total']),
      totalPages: _asInt(body['total_pages']),
    );
  }

  // جلب التفاصيل الكاملة لفرصة تدريب واحدة
  static Future<TrainingOffer> getOfferDetails(int offerId) async {
    if (offerId <= 0) {
      throw const ApiException('رقم فرصة التدريب غير صالح.');
    }

    final body = await _sendRequest('GET', '$_trainingPath/offers/$offerId');
    return TrainingOffer.fromJson(_asObject(body['data']));
  }

  // جلب المجالات التدريبية
  static Future<List<TrainingTrack>> getTracks() async {
    final body = await _sendRequest('GET', '$_trainingPath/tracks');
    final data = body['data'];
    if (data is! List) {
      throw const ApiException('قائمة المجالات التدريبية غير صالحة.');
    }

    return data.map((item) => TrainingTrack.fromJson(_asObject(item))).toList();
  }

  static Map<String, dynamic> _asObject(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const ApiException('بيانات التدريب المستلمة غير صالحة.');
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class TrainingOffersPage {
  final List<TrainingOffer> offers;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  const TrainingOffersPage({
    required this.offers,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

class TrainingTrack {
  final int id;
  final String name;
  final int? careerPathId;

  const TrainingTrack({
    required this.id,
    required this.name,
    this.careerPathId,
  });

  factory TrainingTrack.fromJson(Map<String, dynamic> json) {
    return TrainingTrack(
      id: TrainingService._asInt(json['training_track_id']),
      name: _string(json['track_name']),
      careerPathId: json['career_path_id'] == null
          ? null
          : TrainingService._asInt(json['career_path_id']),
    );
  }
}

class TrainingOffer {
  final int offerId;
  final int companyId;
  final String companyName;
  final String title;
  final String? description;
  final String? requirements;
  final String? learningOutcomes;
  final String? city;
  final String? governorate;
  final String? location;
  final String? workMode;
  final int? trackId;
  final String? trackName;
  final int? availableSlots;
  final int? requiredHours;
  final String? startDate;
  final String? endDate;
  final String? applicationDeadline;
  final String? companyDescription;
  final String? companyWebsite;
  final String? companyIndustry;

  const TrainingOffer({
    required this.offerId,
    required this.companyId,
    required this.companyName,
    required this.title,
    this.description,
    this.requirements,
    this.learningOutcomes,
    this.city,
    this.governorate,
    this.location,
    this.workMode,
    this.trackId,
    this.trackName,
    this.availableSlots,
    this.requiredHours,
    this.startDate,
    this.endDate,
    this.applicationDeadline,
    this.companyDescription,
    this.companyWebsite,
    this.companyIndustry,
  });

  factory TrainingOffer.fromJson(Map<String, dynamic> json) {
    return TrainingOffer(
      offerId: TrainingService._asInt(json['offer_id']),
      companyId: TrainingService._asInt(json['company_id']),
      companyName: _string(json['company_name']),
      title: _string(json['title']),
      description: _nullableString(json['description']),
      requirements: _nullableString(json['requirements']),
      learningOutcomes: _nullableString(json['learning_outcomes']),
      city: _nullableString(json['city']),
      governorate: _nullableString(json['governorate']),
      location: _nullableString(json['location']),
      workMode: _nullableString(json['work_mode']),
      trackId: json['training_track_id'] == null
          ? null
          : TrainingService._asInt(json['training_track_id']),
      trackName: _nullableString(json['track_name']),
      availableSlots: json['available_slots'] == null
          ? null
          : TrainingService._asInt(json['available_slots']),
      requiredHours: json['required_hours'] == null
          ? null
          : TrainingService._asInt(json['required_hours']),
      startDate: _nullableString(json['start_date']),
      endDate: _nullableString(json['end_date']),
      applicationDeadline: _nullableString(json['application_deadline']),
      companyDescription: _nullableString(json['company_description']),
      companyWebsite: _nullableString(json['website_url']),
      companyIndustry: _nullableString(json['industry']),
    );
  }
}

class TrainingApplication {
  final int applicationId;
  final int opportunityId;
  final String? opportunityTitle;
  final String? companyName;
  final String status;
  final String? appliedDate;

  const TrainingApplication({
    required this.applicationId,
    required this.opportunityId,
    this.opportunityTitle,
    this.companyName,
    required this.status,
    this.appliedDate,
  });

  factory TrainingApplication.fromJson(Map<String, dynamic> json) {
    return TrainingApplication(
      applicationId: TrainingService._asInt(json['application_id']),
      opportunityId: TrainingService._asInt(json['opportunity_id']),
      opportunityTitle: _nullableString(
        json['opportunity_title'] ?? json['title'],
      ),
      companyName: _nullableString(json['company_name']),
      status: _string(json['status']),
      appliedDate: _nullableString(json['applied_date']),
    );
  }
}

String _string(dynamic value) => value is String ? value : '';

String? _nullableString(dynamic value) {
  if (value == null) return null;
  return value is String ? value : null;
}
