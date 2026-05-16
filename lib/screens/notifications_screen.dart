import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.black,
        appBar: AppBar(title: const Text('الإشعارات')),
        body: const Center(
          child: Text(
            'سجل الإشعارات من الراوتر والتطبيق',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      ),
    );
  }
}
