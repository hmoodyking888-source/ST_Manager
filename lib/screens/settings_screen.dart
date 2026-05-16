import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/mikrotik_service.dart';
import '../services/telegram_service.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _chatIdController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final TelegramService _telegramService = TelegramService();
  final MikroTikService _mikroTikService = MikroTikService();

  bool _isLinking = false;

  @override
  void initState() {
    super.initState();
    _loadChatId();
  }

  Future<void> _loadChatId() async {
    final chatId = await _storage.read(key: 'telegram_chat_id');
    if (chatId != null) {
      setState(() {
        _chatIdController.text = chatId;
      });
    }
  }

  Future<void> _linkTelegram() async {
    setState(() => _isLinking = true);
    final chatId = _chatIdController.text.trim();
    if (chatId.isEmpty) {
      setState(() => _isLinking = false);
      return;
    }

    await _storage.write(key: 'telegram_chat_id', value: chatId);

    final creds = await _mikroTikService.loadRouterCredentials();
    final routerIp = creds['ip'] ?? '';
    final phone = await _storage.read(key: 'phone_number') ?? 'unknown';

    await _telegramService.sendMessage(
      chatId: chatId,
      text:
          '✅ تم ربط تطبيق ST_Manager مع هذا الحساب.\n📱 الهاتف: $phone\n🌐 الراوتر: $routerIp',
    );

    await _mikroTikService.injectTelegramScriptToRouter(
      routerIp: routerIp,
      phoneNumber: phone,
      chatId: chatId,
    );

    setState(() => _isLinking = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم ربط بوت التليجرام وحقن السكربت في الراوتر'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.black,
        appBar: AppBar(title: const Text('الإعدادات')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ربط بوت التليجرام',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              const Text(
                'أدخل chat_id الخاص بالقناة أو الجروب أو الحساب الذي تريد استقبال التنبيهات عليه.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _chatIdController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Chat ID',
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
                  onPressed: _isLinking ? null : _linkTelegram,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                  ),
                  child: _isLinking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'ربط البوت وحقن السكربت',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 4),
      ),
    );
  }
}
