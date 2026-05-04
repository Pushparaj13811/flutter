import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

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
    // Check if connection already exists (I sent to them)
    final existing = await _db.collection('connections')
        .where('requester', isEqualTo: _uid)
        .where('recipient', isEqualTo: toUserId)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Connection request already sent');
    }

    // Also check reverse direction (they sent to me)
    final reverse = await _db.collection('connections')
        .where('requester', isEqualTo: toUserId)
        .where('recipient', isEqualTo: _uid)
        .get();

    if (reverse.docs.isNotEmpty) {
      throw Exception('This user already sent you a request');
    }

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
    final doc = await _db.collection('connections').doc(connectionId).get();
    final data = doc.data()!;

    await _db.collection('connections').doc(connectionId).update({
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update both users' connection counts
    final requester = data['requester'] as String;
    final recipient = data['recipient'] as String;
    await _db.collection('profiles').doc(requester).update({
      'stats.connectionsCount': FieldValue.increment(1),
    });
    await _db.collection('profiles').doc(recipient).update({
      'stats.connectionsCount': FieldValue.increment(1),
    });
  }

  Future<void> rejectRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> withdrawRequest(String otherUserId) async {
    final snap = await _db.collection('connections')
        .where('requester', isEqualTo: _uid)
        .where('recipient', isEqualTo: otherUserId)
        .where('status', isEqualTo: 'pending')
        .get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeConnection(String connectionId) async {
    final doc = await _db.collection('connections').doc(connectionId).get();
    if (doc.exists) {
      final data = doc.data()!;
      final requester = data['requester'] as String? ?? '';
      final recipient = data['recipient'] as String? ?? '';

      await _db.collection('connections').doc(connectionId).delete();

      if (requester.isNotEmpty) {
        await _db.collection('profiles').doc(requester).update({
          'stats.connectionsCount': FieldValue.increment(-1),
        });
      }
      if (recipient.isNotEmpty) {
        await _db.collection('profiles').doc(recipient).update({
          'stats.connectionsCount': FieldValue.increment(-1),
        });
      }
    }
  }

  /// Returns the connection status between current user and another user.
  /// Returns: 'connected', 'pending_sent', 'pending_received', or 'none'
  Future<String> getConnectionStatus(String otherUserId) async {
    // Check if already connected
    final connected = await _db.collection('connections')
        .where('participants', arrayContains: _uid)
        .where('status', isEqualTo: 'accepted')
        .get();

    for (final doc in connected.docs) {
      final data = doc.data();
      final participants = (data['participants'] as List?)?.cast<String>() ?? [];
      if (participants.contains(otherUserId)) return 'connected';
    }

    // Check if I sent a pending request to them
    final sent = await _db.collection('connections')
        .where('requester', isEqualTo: _uid)
        .where('recipient', isEqualTo: otherUserId)
        .where('status', isEqualTo: 'pending')
        .get();
    if (sent.docs.isNotEmpty) return 'pending_sent';

    // Check if they sent a pending request to me
    final received = await _db.collection('connections')
        .where('requester', isEqualTo: otherUserId)
        .where('recipient', isEqualTo: _uid)
        .where('status', isEqualTo: 'pending')
        .get();
    if (received.docs.isNotEmpty) return 'pending_received';

    return 'none';
  }
}

final connectionFirestoreServiceProvider = Provider<ConnectionFirestoreService>((ref) {
  return ConnectionFirestoreService();
});
