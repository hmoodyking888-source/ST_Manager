import 'package:http/http.dart' as http;
import 'dart:convert';

class TelegramService {
  final String botToken;

  TelegramService(this.botToken);

  Future<void> sendMessage(String chatId, String text) async {
    final url = Uri.parse("https://api.telegram.org/bot$botToken/sendMessage");

    await http.post(url, body: {
      "chat_id": chatId,
      "text": text,
    });
  }

  Future<Map<String, dynamic>> getUpdates() async {
    final url = Uri.parse("https://api.telegram.org/bot$botToken/getUpdates");

    final res = await http.get(url);
    return jsonDecode(res.body);
  }
}
