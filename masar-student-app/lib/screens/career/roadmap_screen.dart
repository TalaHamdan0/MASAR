
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../theme/masar_theme.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;
  bool _saving = false;

  static const _statusLabels = {
    'NOT_STARTED': 'لم تبدأ',
    'IN_PROGRESS': 'قيد التنفيذ',
    'COMPLETED': 'مكتملة',
  };

  static const Map<String, Color> _statusColors = {
    'NOT_STARTED': Color(0xFF64748B),
    'IN_PROGRESS': Color(0xFFD97706),
    'COMPLETED': Color(0xFF16834A),
  };

  static const Map<String, Color> _statusBackgrounds = {
    'NOT_STARTED': Color(0xFFF1F5F9),
    'IN_PROGRESS': Color(0xFFFFF7ED),
    'COMPLETED': Color(0xFFECFDF3),
  };

  IconData _statusIcon(String status) {
    switch (status) {
      case 'COMPLETED':
        return Icons.check_circle_outline;
      case 'IN_PROGRESS':
        return Icons.timelapse;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  Color _statusColor(String status) {
    return _statusColors[status] ?? const Color(0xFF64748B);
  }

  Color _statusBackground(String status) {
    return _statusBackgrounds[status] ??
        const Color(0xFFF1F5F9);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  List<Map<String, dynamic>> _list(String key) {
    final value = _data?[key];

    if (value is! List) return [];

    return value.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? payload,
  }) async {
    final token = AuthSession.accessToken;

    if (token == null || token.trim().isEmpty) {
      throw const ApiException('سجّلي الدخول مجددًا.');
    }

    final uri = Uri.parse('${ApiService.baseUrl}$path');
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      if (payload != null) 'Content-Type': 'application/json',
    };

    try {
      final http.Response response;

      if (method == 'POST') {
        response = await http
            .post(
              uri,
              headers: headers,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 20));
      } else if (method == 'PUT') {
        response = await http
            .put(
              uri,
              headers: headers,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 20));
      } else {
        response = await http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 20));
      }

      if (AuthSession.accessToken != token) {
        throw const ApiException(
          'تغيّرت جلسة الدخول. افتحي الشاشة من الحساب الحالي.',
        );
      }

      Map<String, dynamic>? body;

      try {
        final decoded = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (decoded is Map<String, dynamic>) {
          body = decoded;
        }
      } on FormatException {
        body = null;
      }

      if (response.statusCode != 200 &&
          response.statusCode != 201) {
        final error = body?['error'];

        if (error is Map<String, dynamic> &&
            error['message'] is String) {
          throw ApiException(error['message'] as String);
        }

        throw ApiException(
          response.statusCode == 404
              ? 'خدمة خارطة الطريق غير متاحة. أعيدي تشغيل الباكند.'
              : 'تعذر إكمال العملية حاليًا.',
        );
      }

      final data = body?['data'];

      if (data is! Map<String, dynamic>) {
        throw const ApiException(
          'استجابة خارطة الطريق غير مكتملة.',
        );
      }

      final pathData = data['path'];
      final items = data['items'];
      final tasks = data['personalTasks'];

      if (pathData is! Map<String, dynamic> ||
          pathData['id'] is! String ||
          pathData['title'] is! String ||
          items is! List ||
          tasks is! List) {
        throw const ApiException(
          'بيانات خارطة الطريق غير صالحة.',
        );
      }

      for (final item in [...items, ...tasks]) {
        if (item is! Map<String, dynamic> ||
            item['id'] is! String ||
            item['title'] is! String ||
            !_statusLabels.containsKey(item['status'])) {
          throw const ApiException(
            'بيانات إحدى الخطوات غير صالحة.',
          );
        }
      }

      for (final item in items) {
        final resources =
            (item as Map<String, dynamic>)['resources'];

        if (resources is! List ||
            resources.any(
              (resource) =>
                  resource is! Map<String, dynamic> ||
                  resource['title'] is! String,
            )) {
          throw const ApiException(
            'بيانات مصادر التعلّم غير صالحة.',
          );
        }
      }

      return data;
    } on TimeoutException {
      throw const ApiException(
        'انتهت المهلة دون تأكيد. أعيدي تحميل الشاشة '
        'للتحقق من آخر حالة محفوظة.',
      );
    } on http.ClientException {
      throw const ApiException(
        'تعذر الوصول للباكند. تأكدي أنه شغّال.',
      );
    }
  }

  Future<void> _load() async {
    if (_saving) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data =
          await _request('/api/v1/students/me/roadmap');

      if (!mounted) return;

      setState(() {
        _data = data;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  String get _pathId {
    final path = _data?['path'];

    return path is Map<String, dynamic>
        ? path['id'] as String
        : '';
  }

  Future<void> _save(
    String path, {
    required Map<String, dynamic> payload,
    String method = 'PUT',
  }) async {
    if (_saving || _loading || _data == null) return;

    final pathId = _pathId;

    setState(() {
      _saving = true;
    });

    try {
      final data = await _request(
        path,
        method: method,
        payload: {
          ...payload,
          'careerPathId': pathId,
        },
      );

      if (!mounted) return;

      setState(() {
        _data = data;
      });
    } catch (error) {
      _message(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _changeStatus(
    Map<String, dynamic> item, {
    required bool personal,
  }) async {
    if (_saving || _loading) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                18, 20, 18, 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'حالة التقدّم',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'اختر الحالة المناسبة لهذه الخطوة',
                    style: TextStyle(
                      fontSize: 13,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final entry in _statusLabels.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Builder(
                        builder: (context) {
                          final isSelected =
                              item['status'] == entry.key;
                          final color =
                              _statusColor(entry.key);
                          final background =
                              _statusBackground(entry.key);

                          return Material(
                            color: background,
                            borderRadius:
                                BorderRadius.circular(15),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(15),
                              onTap: () {
                                Navigator.pop(
                                  sheetContext,
                                  entry.key,
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 17,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : color.withOpacity(0.20),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _statusIcon(entry.key),
                                      color: color,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      Text(
                                        'المحددة',
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.check,
                                        color: color,
                                        size: 22,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted ||
        selected == null ||
        selected == item['status']) {
      return;
    }

    final section = personal ? 'tasks' : 'items';

    await _save(
      '/api/v1/students/me/roadmap/$section/${item['id']}',
      payload: {'status': selected},
    );
  }

  Future<void> _showAddTaskDialog() async {
    String title = '';

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('إضافة مهمة جديدة'),
            content: TextField(
              autofocus: true,
              maxLength: 120,
              onChanged: (value) {
                title = value;
              },
              decoration: const InputDecoration(
                hintText: 'اكتب اسم المهمة',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (title.trim().isEmpty) return;

                  Navigator.pop(
                    dialogContext,
                    title.trim(),
                  );
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    await _save(
      '/api/v1/students/me/roadmap/tasks',
      method: 'POST',
      payload: {'title': result},
    );
  }

  Future<void> _openResource(dynamic value) async {
    if (value is! String) {
      _message('رابط المصدر غير متاح.');
      return;
    }

    final uri = Uri.tryParse(value);

    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      _message('رابط المصدر غير صالح.');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _message('تعذر فتح المصدر.');
      }
    } catch (_) {
      _message('تعذر فتح المصدر.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MasarColors.background,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _error != null
                    ? _buildError()
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: _buildContent(),
                      ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 1,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.route_outlined,
            size: 48,
            color: MasarColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _load,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final items = _list('items');
    final personalTasks = _list('personalTasks');
    final path = _data!['path'] as Map<String, dynamic>;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'خارطة الطريق',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: _saving ? null : _load,
              tooltip: 'تحديث',
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'خطوات عملية تساعدك على تطوير مسارك المهني '
          'والوصول إلى أهدافك.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: MasarColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          path['title'] as String,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: MasarColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 20),
        _buildProgressBanner(items),
        const SizedBox(height: 12),
        if (_saving)
          const LinearProgressIndicator()
        else
          const SizedBox(height: 4),
        const SizedBox(height: 20),
        const Text(
          'خطة التطوير',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'اتبع الخطوات بالترتيب وحدّث حالتها أثناء التعلّم.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: MasarColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          _notice('لا توجد خطوات متاحة لهذا المسار حاليًا.')
        else
          for (var index = 0; index < items.length; index++)
            _buildStep(items[index], index + 1),
        const SizedBox(height: 22),
        const Text(
          'مهامي الشخصية',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (personalTasks.isEmpty)
          _notice('أضف المهام التي تساعدك على تحقيق أهدافك.')
        else
          for (final task in personalTasks)
            _buildPersonalTask(task),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _saving ? null : _showAddTaskDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة مهمة جديدة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: MasarColors.primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(
              color: MasarColors.primaryBlue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBanner(
    List<Map<String, dynamic>> items,
  ) {
    final completed = items
        .where((item) => item['status'] == 'COMPLETED')
        .length;

    final progress = items.isEmpty
        ? 0.0
        : completed / items.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasarColors.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تقدّمك في خارطة الطريق',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            items.isEmpty
                ? 'لا توجد خطوات متاحة بعد'
                : '$completed من أصل ${items.length} خطوات مكتملة',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'حسب الخطوات التي تم تحديدها كمكتملة.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    Map<String, dynamic> item,
    int number,
  ) {
    final status = item['status'] as String;
    final description =
        item['description'] as String? ?? '';
    final hours = item['estimatedHours'];
    final resources = (item['resources'] as List)
        .cast<Map<String, dynamic>>();
    final selectedInProfile =
        item['selectedInProfile'] == true;

    final color = _statusColor(status);
    final background = _statusBackground(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.30),
        ),
      ),
      child: ExpansionTile(
        key: ValueKey('roadmap-${item['id']}'),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: status == 'COMPLETED'
              ? const Icon(Icons.check)
              : Text('$number'),
        ),
        title: Text(
          item['title'] as String,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusLabels[status]!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        children: [
          if (description.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: MasarColors.textSecondary,
                ),
              ),
            ),
          if (hours is num && hours > 0) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الوقت التقديري: $hours ساعة',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
          if (selectedInProfile) ...[
            const SizedBox(height: 10),
            _notice(
              'المهارة المرتبطة بهذه الخطوة مسجّلة في ملفك. '
              'يمكنك مراجعتها وتحديد حالة الخطوة بنفسك.',
            ),
          ],
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'مصادر التعلّم',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (resources.isEmpty)
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'لا توجد مصادر مضافة لهذه الخطوة بعد.',
                style: TextStyle(
                  fontSize: 12,
                  color: MasarColors.textSecondary,
                ),
              ),
            )
          else
            for (final resource in resources)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.open_in_new,
                  color: MasarColors.primaryBlue,
                ),
                title: Text(
                  resource['title'] as String,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle:
                    (resource['description'] as String? ?? '')
                            .isEmpty
                        ? null
                        : Text(
                            resource['description'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                enabled: resource['url'] is String,
                onTap: () {
                  _openResource(resource['url']);
                },
              ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _saving
                  ? null
                  : () => _changeStatus(
                        item,
                        personal: false,
                      ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('تحديث حالة الخطوة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTask(
    Map<String, dynamic> task,
  ) {
    final status = task['status'] as String;
    final color = _statusColor(status);
    final background = _statusBackground(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.30),
        ),
      ),
      child: ListTile(
        leading: Icon(
          _statusIcon(status),
          color: color,
          size: 26,
        ),
        title: Text(
          task['title'] as String,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusLabels[status]!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        trailing: Icon(
          Icons.edit_outlined,
          size: 20,
          color: color,
        ),
        enabled: !_saving,
        onTap: () {
          _changeStatus(
            task,
            personal: true,
          );
        },
      ),
    );
  }

  Widget _notice(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          height: 1.6,
          color: MasarColors.textSecondary,
        ),
      ),
    );
  }
}
