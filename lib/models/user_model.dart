class AppUser {
  final String phoneNumber;
  final DateTime startDate;
  final DateTime expiryDate;
  final bool isPaid;

  AppUser({
    required this.phoneNumber,
    required this.startDate,
    required this.expiryDate,
    required this.isPaid,
  });

  bool get isTrialExpired => DateTime.now().isAfter(expiryDate);

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'startDate': startDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'isPaid': isPaid,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      phoneNumber: map['phoneNumber'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      expiryDate: DateTime.parse(map['expiryDate']),
      isPaid: map['isPaid'] ?? false,
    );
  }
}
