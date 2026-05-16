import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class TrialService {
  static final TrialService _instance = TrialService._internal();
  factory TrialService() => _instance;
  TrialService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  Future<AppUser?> getUserTrial(String phoneNumber) async {
    final data = await _firebaseService.getUserData(phoneNumber);
    if (data == null) return null;
    return AppUser.fromMap(data);
  }

  Future<bool> canControl(String phoneNumber) async {
    final user = await getUserTrial(phoneNumber);
    if (user == null) return false;
    if (user.isPaid) return true;
    return !user.isTrialExpired;
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }
}
