import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createCloud(String uid, Map<String, dynamic> data) async {
    await _db.collection('clouds').doc(uid).set(data);
  }

  Future<void> updateCloud(String uid, Map<String, dynamic> data) async {
    await _db.collection('clouds').doc(uid).update(data);
  }

  Future<void> deleteCloud(String uid) async {
    await _db.collection('clouds').doc(uid).delete();
  }

  Stream<DocumentSnapshot> getCloud(String uid) {
    return _db.collection('clouds').doc(uid).snapshots();
  }
}
