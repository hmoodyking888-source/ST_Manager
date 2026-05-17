import 'package:routeros_api/routeros_api.dart';

class MikroTikService {
  RouterOSClient? _client;

  Future<void> connect({
    required String host,
    required String username,
    required String password,
    int port = 8728,
  }) async {
    _client = await RouterOSClient.connect(
      host,
      port: port,
      username: username,
      password: password,
    );
  }

  Future<List<Map<String, dynamic>>> runCommand(String path) async {
    if (_client == null) throw Exception("Not connected to router");
    final cmd = _client!.command(path);
    final result = await cmd.execute();
    return result.map((e) => e.attributes).toList();
  }

  Future<void> disconnect() async {
    await _client?.close();
  }
}
