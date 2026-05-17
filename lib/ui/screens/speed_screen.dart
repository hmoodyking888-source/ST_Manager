import 'package:flutter/material.dart';

class SpeedScreen extends StatelessWidget {
  const SpeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Speed Test")),
      body: const Center(
        child: Text("Speed Test Coming Soon",
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
