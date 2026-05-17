import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BackupService {
  Future<String> getBackupDirectory() async {
    final dir = Directory('/storage/emulated/0/Download/ST-Backups');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir.path;
  }

  Future<File> saveBackup(String filename, String content) async {
    final path = await getBackupDirectory();
    final file = File('$path/$filename');
    return file.writeAsString(content);
  }
}
