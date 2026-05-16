import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/users_screen.dart';
import 'theme/app_theme.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  runApp(const STManagerApp());
}

class STManagerApp extends StatelessWidget {
  const STManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ST_Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.users: (_) => const UsersScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),
        AppRoutes.reports: (_) => const ReportsScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
