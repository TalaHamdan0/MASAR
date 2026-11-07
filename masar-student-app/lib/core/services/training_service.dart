
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'auth_session.dart';

class TrainingService {
  static const Duration _timeout = Duration(seconds: 20);

  static const String _trainingPath =
      '/api/v1/students/training';

  static Map<String, String> _headers() {
    final token = AuthSession.accessToken;

    if (token == null || token.trim().isEmpty) {
      throw const ApiException(
        'يرجى تسجيل الدخول أولًا.',
      );
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final headers = _headers();

    final baseUri = Uri.parse(ApiService.baseUrl);

    final uri = baseUri.replace(
      path: '${baseUri.path}$path',
      queryParameters: queryParameters,
    );

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(_timeout);

      Map<String, dynamic> body;

      try {
        final decoded = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException();
        }

        body = decoded;
      } on FormatException {
        throw const ApiException(
          'استجابة خدمة التدريب غير صالحة.',
        );
      }

      if (response.statusCode == 401) {
        throw const ApiException(
          'انتهت جلسة الدخول أو لم يتم تسجيل الدخول. '
          'يرجى تسجيل الدخول مجددًا.',
        );
      }

      if (response.statusCode == 403) {
        throw const ApiException(
          'لا توجد صلاحية للوصول إلى فرص التدريب.',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        final message = body['message'];

        if (message is String &&
            message.trim().isNotEmpty) {
          throw ApiException(message);
        }

        throw ApiException(
          'تعذر تحميل بيانات التدريب '
          '(رمز الخطأ: ${response.statusCode}).',
        );
      }

      return body;
    } on TimeoutException {
      throw const ApiException(
        'انتهت مهلة الاتصال بخدمة التدريب. '
        'حاول مجددًا.',
      );
    } on http.ClientException {
      throw const ApiException(
        'تعذر الاتصال بخدمة التدريب. '
        'تأكد من تشغيل الباكند.',
      );
    }
  }

  // جلب فرص التدريب مع البحث والفلاتر والصفحات.
  static Future<TrainingOffersPage> getOffers({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? governorate,
    int? trackId,
  }) async {
    if (page < 1 || pageSize < 1 || pageSize > 100) {
      throw const ApiException(
        'إعدادات تحميل فرص التدريب غير صالحة.',
      );
    }

    final query = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    if (governorate != null &&
        governorate.trim().isNotEmpty) {
      query['governorate'] = governorate.trim();
    }

    if (trackId != null) {
      query['track_id'] = trackId.toString();
    }

    final body = await _get(
      '$_trainingPath/offers',
      queryParameters: query,
    );

    final data = body['data'];

    if (data is! List) {
      throw const ApiException(
        'قائمة فرص التدريب غير صالحة.',
      );
    }

    return TrainingOffersPage(
      offers: data.map((item) {
        return TrainingOffer.fromJson(
          _asObject(item),
        );
      }).toList(),
      page: _asInt(body['page']),
      pageSize: _asInt(body['page_size']),
      total: _asInt(body['total']),
      totalPages: _asInt(body['total_pages']),
    );
  }

  // جلب التفاصيل الكاملة لفرصة تدريب واحدة.
  static Future<TrainingOffer> getOfferDetails(
    int offerId,
  ) async {
    if (offerId <= 0) {
      throw const ApiException(
        'رقم فرصة التدريب غير صالح.',
      );
    }

    final body = await _get(
      '$_trainingPath/offers/$offerId',
    );

    return TrainingOffer.fromJson(
      _asObject(body['data']),
    );
  }

  // جلب المجالات التدريبية من Oracle.
  static Future<List<TrainingTrack>> getTracks() async {
    final body = await _get(
      '$_trainingPath/tracks',
    );

    final data = body['data'];

    if (data is! List) {
      throw const ApiException(
        'قائمة المجالات التدريبية غير صالحة.',
      );
    }

    return data.map((item) {
      return TrainingTrack.fromJson(
        _asObject(item),
      );
    }).toList();
  }

  static Map<String, dynamic> _asObject(
    dynamic value,
  ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    throw const ApiException(
      'بيانات التدريب المستلمة غير صالحة.',
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num && value == value.roundToDouble()) {
      return value.toInt();
    }

    throw const ApiException(
      'بيانات الأرقام المستلمة غير صالحة.',
    );
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

  factory TrainingTrack.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingTrack(
      id: TrainingService._asInt(
        json['training_track_id'],
      ),
      name: _string(json['track_name']),
      careerPathId: json['career_path_id'] == null
          ? null
          : TrainingService._asInt(
              json['career_path_id'],
            ),
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

  factory TrainingOffer.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingOffer(
      offerId: TrainingService._asInt(
        json['offer_id'],
      ),
      companyId: TrainingService._asInt(
        json['company_id'],
      ),
      companyName: _string(
        json['company_name'],
      ),
      title: _string(json['title']),
      description: _nullableString(
        json['description'],
      ),
      requirements: _nullableString(
        json['requirements'],
      ),
      learningOutcomes: _nullableString(
        json['learning_outcomes'],
      ),
      city: _nullableString(json['city']),
      governorate: _nullableString(
        json['governorate'],
      ),
      location: _nullableString(
        json['location'],
      ),
      workMode: _nullableString(
        json['work_mode'],
      ),
      trackId: json['training_track_id'] == null
          ? null
          : TrainingService._asInt(
              json['training_track_id'],
            ),
      trackName: _nullableString(
        json['track_name'],
      ),
      availableSlots: json['available_slots'] == null
          ? null
          : TrainingService._asInt(
              json['available_slots'],
            ),
      requiredHours: json['required_hours'] == null
          ? null
          : TrainingService._asInt(
              json['required_hours'],
            ),
      startDate: _nullableString(
        json['start_date'],
      ),
      endDate: _nullableString(
        json['end_date'],
      ),
      applicationDeadline: _nullableString(
        json['application_deadline'],
      ),
      companyDescription: _nullableString(
        json['company_description'],
      ),
      companyWebsite: _nullableString(
        json['website_url'],
      ),
      companyIndustry: _nullableString(
        json['industry'],
      ),
    );
  }
}

String _string(dynamic value) {
  return value is String ? value : '';
}

String? _nullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  return value is String ? value : null;
}
