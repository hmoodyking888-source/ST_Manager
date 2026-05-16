import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramService {
  static final TelegramService _instance = TelegramService._internal();
  factory TelegramService() => _instance;
  TelegramService._internal();

  // توكن البوت الذي أعطيتني إياه
  static const String _botToken =
      '8661374323:AAHQefglt5JZCdBAy3yXgMwHtw3Pom0PwI8';

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final url = Uri.parse('https://api.telegram.org/bot$_botToken/sendMessage');
    await http.post(
      url,
      body: {'chat_id': chatId, 'text': text, 'parse_mode': 'HTML'},
    );
  }

  /// يمكن استخدامه لاحقاً للحصول على التحديثات واستخراج chat_id
  Future<List<dynamic>> getUpdates() async {
    final url = Uri.parse('https://api.telegram.org/bot$_botToken/getUpdates');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['result'] as List<dynamic>;
    }
    return [];
  }
}
