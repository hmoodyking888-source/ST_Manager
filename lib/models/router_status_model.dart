class RouterStatus {
  final double cpu;
  final double temperature;
  final double voltage;
  final double currentSpeedMbps;
  final int activeUsers;
  final int sleepingUsers;

  RouterStatus({
    required this.cpu,
    required this.temperature,
    required this.voltage,
    required this.currentSpeedMbps,
    required this.activeUsers,
    required this.sleepingUsers,
  });

  RouterStatus copyWith({
    double? cpu,
    double? temperature,
    double? voltage,
    double? currentSpeedMbps,
    int? activeUsers,
    int? sleepingUsers,
  }) {
    return RouterStatus(
      cpu: cpu ?? this.cpu,
      temperature: temperature ?? this.temperature,
      voltage: voltage ?? this.voltage,
      currentSpeedMbps: currentSpeedMbps ?? this.currentSpeedMbps,
      activeUsers: activeUsers ?? this.activeUsers,
      sleepingUsers: sleepingUsers ?? this.sleepingUsers,
    );
  }

  static RouterStatus initial() {
    return RouterStatus(
      cpu: 0,
      temperature: 0,
      voltage: 0,
      currentSpeedMbps: 0,
      activeUsers: 0,
      sleepingUsers: 0,
    );
  }
}
