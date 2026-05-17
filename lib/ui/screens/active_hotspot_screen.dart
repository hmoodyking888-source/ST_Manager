import 'package:flutter/material.dart';

class ActiveHotspotScreen extends StatelessWidget {
  const ActiveHotspotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Hotspot")),
      body: const Center(
        child:
            Text("Active Hotspot Users", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
