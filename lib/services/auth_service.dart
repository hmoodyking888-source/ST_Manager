import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'firebase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();
  final _firebaseService = AppFirebaseService();

  String? _verificationId;

  Future<void> sendCodeToPhone(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        final userCred = await _auth.signInWithCredential(credential);
        await _onLoginSuccess(userCred.user);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message ?? 'Phone verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifySmsCode(String smsCode) async {
    if (_verificationId == null) {
      throw Exception('No verificationId stored');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    final userCred = await _auth.signInWithCredential(credential);
    await _onLoginSuccess(userCred.user);
  }

  Future<void> _onLoginSuccess(User? user) async {
    if (user == null) return;

    await _storage.write(key: 'is_logged_in', value: 'true');
    await _storage.write(key: 'user_phone', value: user.phoneNumber ?? '');

    await _firebaseService.onUserLoggedIn(user);
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _storage.delete(key: 'is_logged_in');
    await _storage.delete(key: 'user_phone');
  }
}
