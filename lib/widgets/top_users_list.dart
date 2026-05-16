import 'package:flutter/material.dart';

class TopUsersList extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const TopUsersList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final u = users[index];
            final name = u['user']?.toString() ?? 'مستخدم';
            final address = u['address']?.toString() ?? '';
            final rate = u['rate-limit']?.toString() ?? '';
            return ListTile(
              dense: true,
              title: Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                '$address  |  $rate',
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
