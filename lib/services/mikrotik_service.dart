import 'package:routeros_api/routeros_api.dart';

class MikroTikService {
  // تعريف المتغير العام الصحيح من المكتبة
  RouterOSClient? _api;

  // دالة الاتصال بالراوتر
  Future<void> connect({
    required String host,
    required String username,
    required String password,
    int port = 8728,
  }) async {
    try {
      _api = RouterOSClient(
        host: host,
        user: username, // استخدام user بناءً على توثيق المكتبة
        password: password,
      );

      await _api!.connect();
      print("تم الاتصال بالراوتر بنجاح");
    } catch (e) {
      print("خطأ أثناء الاتصال بالراوتر: $e");
      rethrow;
    }
  }

  // دالة تشغيل الأوامر (مع الحفاظ على نوع النتيجة المتوافق مع باقي الملفات dynamic)
  Future<List<Map<String, dynamic>>> runCommand(String command) async {
    if (_api == null) {
      throw Exception("Not connected to router");
    }

    try {
      final result = await _api!.execute(command);
      // تحويل النتيجة لضمان التوافق التام مع الـ UI في تطبيقك
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print("خطأ أثناء تنفيذ الأمر $command: $e");
      rethrow;
    }
  }

  // دالة قطع الاتصال (تم إصلاح خطأ السطر 51 بإزالة await)
  Future<void> disconnect() async {
    try {
      // إزالة await لأن دالة close ترجع void عادي وليس Future
      _api?.close();
      _api = null; // إعادة تعيين المتغير للحماية
      print("تم قطع الاتصال بالراوتر");
    } catch (e) {
      print("خطأ أثناء إغلاق الاتصال: $e");
    }
  }
}
