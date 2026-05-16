import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:routeros_api/routeros_api.dart'; // استيراد المكتبة الصحيح
import '../models/router_status_model.dart';
import 'telegram_service.dart';

class MikroTikService {
  static final MikroTikService _instance = MikroTikService._internal();
  factory MikroTikService() => _instance;
  MikroTikService._internal();

  final _storage = const FlutterSecureStorage();
  late RouterOSClient _api; // 👈 التعديل الصحيح: اسم الكلاس الفعلي في المكتبة
  bool _connected = false;

  final StreamController<RouterStatus> _statusController =
      StreamController<RouterStatus>.broadcast();
  Timer? _timer;

  Stream<RouterStatus> get statusStream => _statusController.stream;
  bool get isConnected => _connected;

  // -------------------------------------------------------------
  // حفظ بيانات الراوتر
  // -------------------------------------------------------------
  Future<void> saveRouterCredentials({
    required String routerName,
    required String ip,
    required String username,
    required String password,
    int port = 8728,
  }) async {
    await _storage.write(key: 'router_name', value: routerName);
    await _storage.write(key: 'router_ip', value: ip);
    await _storage.write(key: 'router_username', value: username);
    await _storage.write(key: 'router_password', value: password);
    await _storage.write(key: 'router_port', value: port.toString());
  }

  Future<Map<String, String?>> loadRouterCredentials() async {
    final name = await _storage.read(key: 'router_name');
    final ip = await _storage.read(key: 'router_ip');
    final username = await _storage.read(key: 'router_username');
    final password = await _storage.read(key: 'router_password');
    final port = await _storage.read(key: 'router_port');
    return {
      'name': name,
      'ip': ip,
      'username': username,
      'password': password,
      'port': port,
    };
  }

  // -------------------------------------------------------------
  // الاتصال الحقيقي بالميكروتك
  // -------------------------------------------------------------
  Future<bool> connect({
    required String ip, // 👈 تمت إضافة الـ ip هنا بشكل صحيح كمتغير مطلوب
    required String username,
    required String password,
    int port = 8728,
  }) async {
    try {
      // 👈 استخدام الـ RouterOSClient الصحيح وتمرير المتغيرات كـ Parameters مسمية
      _api = RouterOSClient(
        host: ip,
        user: username,
        password: password,
        port: port,
      );

      await _api.connect();
      _connected = true;
      return true;
    } catch (e) {
      print("❌ MikroTik connection error: $e");
      _connected = false;
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      _api.close();
    } catch (_) {}
    _connected = false;
    _timer?.cancel();
  }

  // -------------------------------------------------------------
  // تشغيل التحديث كل ثانية
  // -------------------------------------------------------------
  void startStatusStream() {
    if (!_connected) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final status = await _fetchStatus();
      if (!_statusController.isClosed) {
        _statusController.add(status);
      }
    });
  }

  void stopStatusStream() {
    _timer?.cancel();
    _timer = null;
    if (!_statusController.isClosed) {
      _statusController.close();
    }
  }

  // -------------------------------------------------------------
  // جلب CPU / حرارة / فولت / سرعة / أكتف / نائم
  // -------------------------------------------------------------
  Future<RouterStatus> _fetchStatus() async {
    if (!_connected) return RouterStatus.initial();

    try {
      double cpu = 0;
      double temp = 0;
      double volt = 0;

      // 1. جلب الجهد والحرارة من الـ Health (المكتبة تستخدم دالة execute بدلاً من command)
      try {
        final health = await _api.execute('/system/health/print');
        if (health.isNotEmpty) {
          final h = health.first;
          temp = double.tryParse(h['temperature']?.toString() ?? '0') ?? 0;
          volt = double.tryParse(h['voltage']?.toString() ?? '0') ?? 0;
        }
      } catch (_) {}

      // 2. جلب الـ CPU من الـ Resource
      try {
        final resource = await _api.execute('/system/resource/print');
        if (resource.isNotEmpty) {
          cpu =
              double.tryParse(resource.first['cpu-load']?.toString() ?? '0') ??
                  0;
        }
      } catch (_) {}

      // Active users
      final active = await _api.execute('/ip/hotspot/active/print');
      final activeCount = active.length;

      // Sleeping users
      final users = await _api.execute('/ip/hotspot/user/print');
      final sleepingCount = users
          .where((u) => (u['disabled']?.toString() ?? 'false') == 'true')
          .length;

      // Speed
      final traffic = await _api.execute(
        '/interface/monitor-traffic',
        queries: ['?interface=ether1', '?once=yes'],
      );

      double speedMbps = 0;
      if (traffic.isNotEmpty) {
        final t = traffic.first;
        final rx =
            double.tryParse(t['rx-bits-per-second']?.toString() ?? '0') ?? 0;
        final tx =
            double.tryParse(t['tx-bits-per-second']?.toString() ?? '0') ?? 0;
        speedMbps = (rx + tx) / (1024 * 1024);
      }

      return RouterStatus(
        cpu: cpu,
        temperature: temp,
        voltage: volt,
        currentSpeedMbps: speedMbps,
        activeUsers: activeCount,
        sleepingUsers: sleepingCount,
      );
    } catch (e) {
      print("❌ Error fetching status: $e");
      return RouterStatus.initial();
    }
  }

  // -------------------------------------------------------------
  // اللوج
  // -------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getLogs() async {
    if (!_connected) return [];
    try {
      return await _api.execute('/log/print');
    } catch (e) {
      print("❌ Error fetching logs: $e");
      return [];
    }
  }

  // -------------------------------------------------------------
  // أعلى المستخدمين
  // -------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getTopUsers() async {
    if (!_connected) return [];
    try {
      final active = await _api.execute('/ip/hotspot/active/print');
      return active.take(4).toList();
    } catch (e) {
      print("❌ Error fetching top users: $e");
      return [];
    }
  }

  // -------------------------------------------------------------
  // أكسس بوينت
  // -------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getAccessPoints() async {
    if (!_connected) return [];
    try {
      return await _api.execute('/interface/wireless/print');
    } catch (e) {
      print("❌ Error fetching APs: $e");
      return [];
    }
  }

  Future<void> setAccessPointEnabled(String id, bool enabled) async {
    if (!_connected) return;
    try {
      await _api.execute('/interface/wireless/set', queries: [
        '.id=$id',
        'disabled=${enabled ? 'no' : 'yes'}',
      ]);
    } catch (e) {
      print("❌ Error setting AP: $e");
    }
  }

  // -------------------------------------------------------------
  // إنشاء بطاقة هوتسبوت
  // -------------------------------------------------------------
  Future<void> generateHotspotVoucher({
    required String username,
    required String password,
    required String profile,
    required String comment,
  }) async {
    if (!_connected) return;
    try {
      await _api.execute('/ip/hotspot/user/add', queries: [
        'name=$username',
        'password=$password',
        'profile=$profile',
        'comment=$comment',
      ]);
    } catch (e) {
      print("❌ Error generating voucher: $e");
    }
  }

  // -------------------------------------------------------------
  // حقن سكربت التليجرام
  // -------------------------------------------------------------
  Future<void> injectTelegramScriptToRouter({
    required String routerIp,
    required String phoneNumber,
    required String chatId,
  }) async {
    if (!_connected) return;

    final scriptName = 'telegram_notify_$phoneNumber';

    final scriptBody = """
:local chatId "$chatId";
:local botToken "8661374323:AAHQefglt5JZCdBAy3yXgMwHtw3Pom0PwI8";
:local routerIp "$routerIp";

/tool fetch url=("https://api.telegram.org/bot\$botToken/sendMessage?chat_id=\$chatId&text=New+login+from+\$routerIp") keep-result=no
""";

    try {
      await _api.execute('/system/script/add', queries: [
        'name=$scriptName',
        'source=$scriptBody',
      ]);

      await _api.execute('/system/scheduler/add', queries: [
        'name=run_$scriptName',
        'on-event=$scriptName',
        'interval=5m',
        'start-time=startup',
      ]);

      final telegram = TelegramService();
      await telegram.sendMessage(
        chatId: chatId,
        text: 'تم حقن سكربت التليجرام داخل الراوتر بنجاح.',
      );
    } catch (e) {
      print("❌ Error injecting Telegram script: $e");
    }
  }
}
