import 'package:flutter/material.dart';

class AddonsScreen extends StatelessWidget {
  const AddonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Addons")),
      body: const Center(
        child:
            Text("Addons Coming Soon", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
