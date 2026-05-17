import 'package:flutter/material.dart';
import '../../services/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _backupService = BackupService();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Backup Manager")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: "Backup Content"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _backupService.saveBackup(
                  "backup-${DateTime.now().millisecondsSinceEpoch}.txt",
                  _contentController.text,
                );
              },
              child: const Text("Save Backup"),
            ),
          ],
        ),
      ),
    );
  }
}
