import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/mikrotik_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();
  final _routerNameController = TextEditingController();
  final _routerIpController = TextEditingController();
  final _routerUserController = TextEditingController();
  final _routerPassController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _isSendingCode = false;
  bool _isVerifyingCode = false;
  bool _codeSent = false;
  bool _isConnectingRouter = false;

  final AuthService _authService = AuthService();
  final MikroTikService _mikroTikService = MikroTikService();

  @override
  void initState() {
    super.initState();
    _loadSavedRouter();
  }

  Future<void> _loadSavedRouter() async {
    final creds = await _mikroTikService.loadRouterCredentials();
    setState(() {
      _routerNameController.text = creds['name'] ?? '';
      _routerIpController.text = creds['ip'] ?? '';
      _routerUserController.text = creds['username'] ?? '';
      _routerPassController.text = creds['password'] ?? '';
    });
  }

  Future<void> _sendCode() async {
    setState(() => _isSendingCode = true);
    final phone = _phoneController.text.trim();
    await _authService.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (_) {
        setState(() {
          _codeSent = true;
          _isSendingCode = false;
        });
      },
      onError: (msg) {
        setState(() => _isSendingCode = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      },
    );
  }

  Future<void> _verifyCode() async {
    setState(() => _isVerifyingCode = true);
    final phone = _phoneController.text.trim();
    final code = _smsController.text.trim();
    final ok = await _authService.confirmSmsCode(
      smsCode: code,
      phoneNumber: phone,
    );
    setState(() => _isVerifyingCode = false);
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('رمز التحقق غير صحيح')));
    } else {
      await _storage.write(key: 'phone_number', value: phone);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التحقق من رقم الهاتف بنجاح')),
      );
    }
  }

  Future<void> _connectRouter() async {
    setState(() => _isConnectingRouter = true);
    final name = _routerNameController.text.trim();
    final ip = _routerIpController.text.trim();
    final user = _routerUserController.text.trim();
    final pass = _routerPassController.text.trim();

    final ok = await _mikroTikService.connect(
      ip: ip,
      username: user,
      password: pass,
    );
    setState(() => _isConnectingRouter = false);

    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فشل الاتصال بالراوتر')));
      return;
    }

    await _mikroTikService.saveRouterCredentials(
      routerName: name,
      ip: ip,
      username: user,
      password: pass,
    );

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.black,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // شعار الأسد (Placeholder)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.gold, width: 2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield,
                          color: AppTheme.gold,
                          size: 32,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'ST_Manager',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ربطك بالعالم بسرعة وثقة',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الخيار الأول: التحقق برقم الهاتف (صلاحيات 3 أيام مجانية)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف (مع رمز الدولة)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold, width: 2),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                if (!_codeSent)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _isSendingCode ? null : _sendCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                      ),
                      child: _isSendingCode
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'إرسال رمز التحقق',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                if (_codeSent) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: _smsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'رمز التحقق',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold, width: 2),
                      ),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _isVerifyingCode ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                      ),
                      child: _isVerifyingCode
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'تأكيد الرمز',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                const Text(
                  'الخيار الثاني: الاتصال بالراوتر (API MikroTik)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _routerNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'اسم الراوتر',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold, width: 2),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _routerIpController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'IP الراوتر',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold, width: 2),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _routerUserController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold, width: 2),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _routerPassController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'كلمة السر',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gold, width: 2),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _isConnectingRouter ? null : _connectRouter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                    ),
                    child: _isConnectingRouter
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'دخول إلى لوحة التحكم',
                            style: TextStyle(color: Colors.black),
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
}
