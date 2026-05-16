class HotspotVoucher {
  final String username;
  final String password;
  final String profile;
  final String note;
  final int validityDays;

  HotspotVoucher({
    required this.username,
    required this.password,
    required this.profile,
    required this.note,
    required this.validityDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'profile': profile,
      'note': note,
      'validityDays': validityDays,
    };
  }
}
