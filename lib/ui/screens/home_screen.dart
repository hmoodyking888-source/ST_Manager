import 'package:flutter/material.dart';

import 'cloud_screen.dart';
import 'backup_screen.dart';
import 'active_hotspot_screen.dart';
import 'hotspot_users_screen.dart';
import 'interfaces_screen.dart';
import 'speed_screen.dart';
import 'addons_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _tile(BuildContext ctx, String title, Widget screen) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () {
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ST Manager")),
      body: ListView(
        children: [
          _tile(context, "Cloud", const CloudScreen()),
          _tile(context, "Backup", const BackupScreen()),
          _tile(context, "Active Hotspot", const ActiveHotspotScreen()),
          _tile(context, "Hotspot Users", const HotspotUsersScreen()),
          _tile(context, "Interfaces", const InterfacesScreen()),
          _tile(context, "Speed Test", const SpeedScreen()),
          _tile(context, "Addons", const AddonsScreen()),
          _tile(context, "Notifications", const NotificationsScreen()),
          _tile(context, "Settings", const SettingsScreen()),
        ],
      ),
    );
  }
}
