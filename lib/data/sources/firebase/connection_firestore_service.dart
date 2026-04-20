import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getMyConnections() async {
    final snap = await _db.collection('connections')
        .where('participants', arrayContains: _uid)
        .where('status', isEqualTo: 'accepted')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final snap = await _db.collection('connections')
        .where('recipient', isEqualTo: _uid)
        .where('status', isEqualTo: 'pending')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getSentRequests() async {
    final snap = await _db.collection('connections')
        .where('requester', isEqualTo: _uid)
        .where('status', isEqualTo: 'pending')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> sendRequest(String toUserId, {String? message}) async {
    await _db.collection('connections').add({
      'requester': _uid,
      'recipient': toUserId,
      'participants': [_uid, toUserId],
      'status': 'pending',
      'message': message ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeConnection(String connectionId) async {
    await _db.collection('connections').doc(connectionId).delete();
  }
}

final connectionFirestoreServiceProvider = Provider<ConnectionFirestoreService>((ref) {
  return ConnectionFirestoreService();
});
