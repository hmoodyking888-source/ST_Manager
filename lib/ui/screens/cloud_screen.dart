import 'package:flutter/material.dart';
import '../../services/cloud_service.dart';

class CloudScreen extends StatefulWidget {
  const CloudScreen({super.key});

  @override
  State<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  final _cloudService = CloudService();
  final _domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cloud Manager")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(labelText: "Domain"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _cloudService.createCloud("user1", {
                  "domain": _domainController.text.trim(),
                  "createdAt": DateTime.now().toString(),
                });
              },
              child: const Text("Create Cloud"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _cloudService.updateCloud("user1", {
                  "domain": _domainController.text.trim(),
                });
              },
              child: const Text("Update Cloud"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _cloudService.deleteCloud("user1");
              },
              child: const Text("Delete Cloud"),
            ),
          ],
        ),
      ),
    );
  }
}
