import 'package:flutter/material.dart';

class CompanySettingsScreen extends StatefulWidget {
  const CompanySettingsScreen({super.key});

  @override
  State<CompanySettingsScreen> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  // الألوان
  static const Color primaryBlue = Color(0xFF3182F6);
  static const Color darkBlue = Color(0xFF16376B);
  static const Color iconBlue = Color(0xFF6689BF);
  static const Color borderBlue = Color(0xFFD6E5FC);
  static const Color backgroundColor = Color(0xFFF5F8FD);
  static const Color secondaryText = Color(0xFF7185A5);

  // بيانات الشركة
  final TextEditingController _nameController = TextEditingController(
    text: 'شركة التقنية الذكية',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'info@company.com',
  );

  final TextEditingController _phoneController = TextEditingController(
    text: '+962 7 9000 0000',
  );

  final TextEditingController _addressController = TextEditingController(
    text: 'عمان، الأردن',
  );

  // الإشعارات
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // =========================================================
  // رسالة تنبيه
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryBlue,
        ),
      );
  }

  // =========================================================
  // اختيار شعار الشركة
  // =========================================================

  void _selectCompanyLogo() {
    _showMessage('يمكن ربط هذا الزر بخاصية اختيار صورة الشعار');
  }

  // =========================================================
  // حقول كلمة المرور
  // =========================================================

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 12, color: darkBlue),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(fontSize: 11, color: secondaryText),
        prefixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: secondaryText,
            size: 19,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: borderBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: borderBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: primaryBlue, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  // =========================================================
  // نافذة تغيير كلمة المرور - حجم أصغر وفي منتصف الشاشة
  // =========================================================

  void _showChangePasswordDialog() {
    final dialogFormKey = GlobalKey<FormState>();

    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool hideOldPassword = true;
    bool hideNewPassword = true;
    bool hideConfirmPassword = true;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.white,
            elevation: 12,

            // هام: التحكم بحجم النافذة ومكانها
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420, maxHeight: 500),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Form(
                      key: dialogFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // عنوان النافذة
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'تغيير كلمة المرور',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'إغلاق',
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: secondaryText,
                                  size: 21,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // كلمة المرور الحالية
                          _passwordField(
                            label: 'كلمة المرور الحالية',
                            controller: oldPasswordController,
                            obscureText: hideOldPassword,
                            onToggle: () {
                              setDialogState(() {
                                hideOldPassword = !hideOldPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'أدخل كلمة المرور الحالية';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // كلمة المرور الجديدة
                          _passwordField(
                            label: 'كلمة المرور الجديدة',
                            controller: newPasswordController,
                            obscureText: hideNewPassword,
                            onToggle: () {
                              setDialogState(() {
                                hideNewPassword = !hideNewPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'أدخل كلمة المرور الجديدة';
                              }

                              if (value.length < 8) {
                                return '8 أحرف على الأقل';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // تأكيد كلمة المرور
                          _passwordField(
                            label: 'تأكيد كلمة المرور الجديدة',
                            controller: confirmPasswordController,
                            obscureText: hideConfirmPassword,
                            onToggle: () {
                              setDialogState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'أكد كلمة المرور الجديدة';
                              }

                              if (value != newPasswordController.text) {
                                return 'كلمتا المرور غير متطابقتين';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // الأزرار
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE7EFFB),
                                    foregroundColor: darkBlue,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('إلغاء'),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (dialogFormKey.currentState!
                                        .validate()) {
                                      Navigator.pop(dialogContext);

                                      _showMessage(
                                        'تم التحقق من الحقول. '
                                        'يلزم ربط تغيير كلمة المرور '
                                        'بنظام المصادقة.',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('حفظ'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      oldPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    });
  }

  // =========================================================
  // حقول بيانات الشركة
  // =========================================================

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          fontSize: 13,
          color: darkBlue,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12, color: secondaryText),
          prefixIcon: Icon(icon, color: iconBlue, size: 23),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borderBlue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borderBlue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryBlue, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // عنوان القسم
  // =========================================================

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1764D9), size: 23),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // بطاقة القسم
  // =========================================================

  Widget _sectionCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: borderBlue),
      ),
      child: child,
    );
  }

  // =========================================================
  // إعدادات الإشعارات
  // =========================================================

  Widget _notificationTile({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: iconBlue, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: darkBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      activeColor: Colors.white,
      activeTrackColor: primaryBlue,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFD6DEEA),
      onChanged: onChanged,
    );
  }

  // =========================================================
  // حفظ التغييرات
  // =========================================================

  void _saveChanges() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _showMessage('تم التحقق من البيانات بنجاح');
    }
  }

  // =========================================================
  // الواجهة الرئيسية
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,

        // شريط العنوان
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 64,
          title: const Text(
            'إعدادات الشركة',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: darkBlue,
              size: 20,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: Color(0xFFE3EAF5)),
          ),
        ),

        // محتوى الصفحة
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شعار الشركة
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E7F0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.business_rounded,
                            size: 58,
                            color: Color(0xFF8498B5),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: -5,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: _selectCompanyLogo,
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 21,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // معلومات الشركة الأساسية
                  _sectionCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'معلومات الشركة الأساسية',
                          Icons.domain_rounded,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          label: 'اسم الشركة',
                          icon: Icons.business_rounded,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال اسم الشركة';
                            }
                            return null;
                          },
                        ),

                        _buildTextField(
                          label: 'البريد الإلكتروني',
                          icon: Icons.mail_outline_rounded,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }

                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(value.trim())) {
                              return 'البريد الإلكتروني غير صحيح';
                            }

                            return null;
                          },
                        ),

                        _buildTextField(
                          label: 'رقم الهاتف',
                          icon: Icons.phone_rounded,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال رقم الهاتف';
                            }
                            return null;
                          },
                        ),

                        _buildTextField(
                          label: 'العنوان',
                          icon: Icons.location_on_rounded,
                          controller: _addressController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال العنوان';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // إعدادات الإشعارات
                  _sectionCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'إعدادات الإشعارات',
                          Icons.notifications_none_rounded,
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: borderBlue, height: 1),

                        _notificationTile(
                          title: 'استقبال الإشعارات عبر البريد الإلكتروني',
                          icon: Icons.mail_outline_rounded,
                          value: _emailNotifications,
                          onChanged: (value) {
                            setState(() {
                              _emailNotifications = value;
                            });
                          },
                        ),

                        const Divider(color: borderBlue, height: 1),

                        _notificationTile(
                          title: 'استقبال الإشعارات الفورية',
                          icon: Icons.notifications_none_rounded,
                          value: _pushNotifications,
                          onChanged: (value) {
                            setState(() {
                              _pushNotifications = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // تغيير كلمة المرور
                  _sectionCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'تغيير كلمة المرور',
                          Icons.lock_outline_rounded,
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          'قم بتحديث كلمة المرور الخاصة بك لحماية حسابك',
                          style: TextStyle(fontSize: 11, color: secondaryText),
                        ),

                        const SizedBox(height: 14),

                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _showChangePasswordDialog,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: borderBlue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.key_rounded,
                                    color: iconBlue,
                                    size: 23,
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'تغيير كلمة المرور',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: darkBlue,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                    color: darkBlue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // زر حفظ التغييرات
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                      label: const Text(
                        'حفظ التغييرات',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
