import 'package:flutter/material.dart';

class HotspotUsersScreen extends StatelessWidget {
  const HotspotUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hotspot Users")),
      body: const Center(
        child:
            Text("Hotspot Users List", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
