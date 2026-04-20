import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getMySessions() async {
    final snap = await _db.collection('sessions')
        .where('participants', arrayContains: _uid)
        .orderBy('scheduledAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<Map<String, dynamic>?> getSession(String id) async {
    final doc = await _db.collection('sessions').doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  Future<String> bookSession(Map<String, dynamic> data) async {
    final doc = await _db.collection('sessions').add({
      ...data,
      'host': _uid,
      'participants': [_uid, data['participant']],
      'status': 'scheduled',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> cancelSession(String id) async {
    await _db.collection('sessions').doc(id).update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeSession(String id, {String? notes}) async {
    final doc = await _db.collection('sessions').doc(id).get();
    final data = doc.data()!;

    await _db.collection('sessions').doc(id).update({
      'status': 'completed',
      if (notes != null) 'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update both users' session counts
    final host = data['host'] as String;
    final participant = data['participant'] as String;
    await _db.collection('profiles').doc(host).update({
      'stats.sessionsCompleted': FieldValue.increment(1),
    });
    await _db.collection('profiles').doc(participant).update({
      'stats.sessionsCompleted': FieldValue.increment(1),
    });
  }

  Future<void> rescheduleSession(String id, DateTime newTime, int newDuration, {String? reason}) async {
    await _db.collection('sessions').doc(id).update({
      'scheduledAt': Timestamp.fromDate(newTime),
      'duration': newDuration,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

final sessionFirestoreServiceProvider = Provider<SessionFirestoreService>((ref) {
  return SessionFirestoreService();
});
