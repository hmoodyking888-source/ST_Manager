import 'package:flutter/material.dart';
import '../models/router_status_model.dart';
import '../theme/app_theme.dart';

class DashboardCards extends StatelessWidget {
  final RouterStatus status;

  const DashboardCards({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            title: 'المعالج',
            value: '${status.cpu.toStringAsFixed(0)}%',
            icon: Icons.memory,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCard(
            title: 'الحرارة',
            value: '${status.temperature.toStringAsFixed(1)}°C',
            icon: Icons.thermostat,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCard(
            title: 'الفولت',
            value: '${status.voltage.toStringAsFixed(1)}V',
            icon: Icons.bolt,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, color: AppTheme.gold, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: AppTheme.gold, fontSize: 12),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
