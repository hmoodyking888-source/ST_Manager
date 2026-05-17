import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/screens/login_screen.dart'; // أو الشاشة الأولى عندك

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SultanNetApp());
}

class SultanNetApp extends StatelessWidget {
  const SultanNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sultan Net",
      theme: ThemeData(
        fontFamily: "Cairo",
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.amber),
          titleTextStyle: TextStyle(
            color: Colors.amber,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.amber),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: const LoginScreen(), // أو ExtrasScreen حسب ترتيبك
    );
  }
}
