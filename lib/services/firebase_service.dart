import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AppFirebaseService {
  static final AppFirebaseService _instance = AppFirebaseService._internal();
  factory AppFirebaseService() => _instance;
  AppFirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get db => _db;

  Future<void> onUserLoggedIn(User user) async {
    await _messaging.requestPermission();
    final fcmToken = await _messaging.getToken();

    await _db.collection('users').doc(user.uid).set({
      'phone': user.phoneNumber,
      'uid': user.uid,
      'fcmToken': fcmToken,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _crashlytics.setUserIdentifier(user.uid);
    await _analytics.logLogin(loginMethod: 'phone');
  }
}
