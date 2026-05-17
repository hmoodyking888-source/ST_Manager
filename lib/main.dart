import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'theme/theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();

  // هل المستخدم سجّل دخوله من قبل؟
  final isLoggedIn = await storage.read(key: 'is_logged_in') == 'true';

  // طلب أذونات التخزين مرة واحدة
  await _requestStoragePermissions();

  // تهيئة Firebase
  await Firebase.initializeApp();

  runApp(STManagerApp(isLoggedIn: isLoggedIn));
}

Future<void> _requestStoragePermissions() async {
  final status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

class STManagerApp extends StatelessWidget {
  final bool isLoggedIn;
  const STManagerApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ST Manager',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
