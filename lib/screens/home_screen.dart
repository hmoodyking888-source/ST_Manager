import 'dart:async';
import 'package:flutter/material.dart';
import '../models/router_status_model.dart';
import '../services/mikrotik_service.dart';
import '../services/trial_service.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_cards.dart';
import '../widgets/logs_list.dart';
import '../widgets/nav_bar.dart';
import '../widgets/speed_gauge.dart';
import '../widgets/top_users_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MikroTikService _mikroTikService = MikroTikService();
  final TrialService _trialService = TrialService();
  final _storage = const FlutterSecureStorage();

  StreamSubscription<RouterStatus>? _statusSub;
  RouterStatus _status = RouterStatus.initial();
  List<Map<String, dynamic>> _logs = [];
  List<Map<String, dynamic>> _topUsers = [];
  bool _canControl = false;
  String _routerName = '';
  String _routerIp = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final creds = await _mikroTikService.loadRouterCredentials();
    _routerName = creds['name'] ?? '';
    _routerIp = creds['ip'] ?? '';

    final phone = await _storage.read(key: 'phone_number');
    if (phone != null) {
      _canControl = await _trialService.canControl(phone);
    } else {
      _canControl = false;
    }

    _mikroTikService.startStatusStream();
    _statusSub = _mikroTikService.statusStream?.listen((s) {
      setState(() {
        _status = s;
      });
    });

    _refreshLogsAndUsers();
  }

  Future<void> _refreshLogsAndUsers() async {
    final logs = await _mikroTikService.getLogs();
    final users = await _mikroTikService.getTopUsers();
    setState(() {
      _logs = logs;
      _topUsers = users;
    });
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _mikroTikService.stopStatusStream();
    super.dispose();
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // شعار الأسد
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.gold, width: 2),
          ),
          child: const Center(
            child: Icon(Icons.shield, color: AppTheme.gold, size: 28),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'ST_Manager',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'ربطك بالعالم بسرعة وثقة',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              _routerName,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
        const Spacer(),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: AppTheme.gold),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const Icon(Icons.menu, color: AppTheme.gold),
        ),
      ],
    );
  }

  Widget _buildSystemInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _routerName.isEmpty ? 'اسم الراوتر' : _routerName,
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Online',
                        style: TextStyle(
                          color: AppTheme.greenOnline,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.circle, color: AppTheme.greenOnline, size: 10),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Uptime: --:--:--',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButtons() {
    final buttons = [
      _GridButtonData('الأكتف', Icons.wifi, onTap: _canControl ? () {} : null),
      _GridButtonData(
        'البرودباند',
        Icons.settings_input_component,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'هوتسبوت',
        Icons.wifi_tethering,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'يوزر مانجر',
        Icons.manage_accounts,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'نسخة/استعادة',
        Icons.backup,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'قطع النت',
        Icons.power_settings_new,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'الإشعارات',
        Icons.notifications,
        onTap: () {
          // فتح شاشة الإشعارات
        },
      ),
      _GridButtonData(
        'المبيعات',
        Icons.shopping_cart,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'الواجهات',
        Icons.router,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'قياس وضبط السرعة',
        Icons.speed,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'أكسس بوينت',
        Icons.wifi_find,
        onTap: _canControl ? () {} : null,
      ),
      _GridButtonData(
        'بطاقات هوتسبوت',
        Icons.confirmation_number,
        onTap: _canControl ? () {} : null,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final b = buttons[index];
        final disabled = b.onTap == null;
        return GestureDetector(
          onTap: disabled ? null : b.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: disabled ? Colors.grey : AppTheme.gold,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  b.icon,
                  color: disabled ? Colors.grey : AppTheme.gold,
                  size: 26,
                ),
                const SizedBox(height: 8),
                Text(
                  b.label,
                  style: TextStyle(
                    color: disabled ? Colors.grey : Colors.white,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'تنبيهات سريعة',
          style: TextStyle(
            color: AppTheme.gold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        LogsList(logs: _logs),
      ],
    );
  }

  Widget _buildTopUsers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'أعلى المستخدمين',
          style: TextStyle(
            color: AppTheme.gold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        TopUsersList(users: _topUsers),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.black,
        endDrawer: Drawer(
          child: Container(
            color: AppTheme.black,
            child: ListView(
              children: const [
                DrawerHeader(
                  child: Text(
                    'القائمة الجانبية',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshLogsAndUsers,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  DashboardCards(status: _status),
                  const SizedBox(height: 8),
                  SpeedGauge(speedMbps: _status.currentSpeedMbps),
                  const SizedBox(height: 8),
                  _buildSystemInfoCard(),
                  const SizedBox(height: 16),
                  _buildGridButtons(),
                  const SizedBox(height: 16),
                  _buildQuickAlerts(),
                  const SizedBox(height: 16),
                  _buildTopUsers(),
                  const SizedBox(height: 16),
                  if (!_canControl)
                    const Text(
                      'انتهت صلاحية التحكم، يمكنك فقط المشاهدة.\nقم بتفعيل الحساب من Firebase أو تواصل مع الإدارة.',
                      style: TextStyle(color: Colors.redAccent, fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }
}

class _GridButtonData {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  _GridButtonData(this.label, this.icon, {this.onTap});
}
