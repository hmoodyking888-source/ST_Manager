import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  static Future<void> init() async {
    // إذا كنت تستخدم FlutterFire CLI سيكفي:
    // await Firebase.initializeApp();
    //
    // أو إن أردت التهيئة اليدوية ضع خيارات مشروعك هنا:
    await Firebase.initializeApp();
  }

  Future<void> createOrUpdateUser({required String phoneNumber}) async {
    final doc = _db.collection('users').doc(phoneNumber);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      final now = DateTime.now();
      final expiry = now.add(const Duration(days: 3));
      await doc.set({
        'phoneNumber': phoneNumber,
        'startDate': now.toIso8601String(),
        'expiryDate': expiry.toIso8601String(),
        'isPaid': false,
      });
    }
  }

  Future<Map<String, dynamic>?> getUserData(String phoneNumber) async {
    final doc = await _db.collection('users').doc(phoneNumber).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<void> setPaid(String phoneNumber, bool isPaid) async {
    await _db.collection('users').doc(phoneNumber).update({'isPaid': isPaid});
  }
}
