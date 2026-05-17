import 'package:flutter/material.dart';

class InterfacesScreen extends StatelessWidget {
  const InterfacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interfaces")),
      body: const Center(
        child: Text("Interfaces List", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
