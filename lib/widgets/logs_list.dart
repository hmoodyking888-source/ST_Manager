import 'package:flutter/material.dart';

class LogsList extends StatelessWidget {
  final List<Map<String, dynamic>> logs;

  const LogsList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          reverse: true,
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final message = log['message']?.toString() ?? '';
            final time = log['time']?.toString() ?? '';
            return ListTile(
              dense: true,
              title: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
    );
  }
}
