import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';
  String get currentUid => _uid;

  /// Create a call document (caller initiates)
  Future<String> createCall(String calleeUid, {String? callerName}) async {
    // Get caller name from profile if not provided
    String name = callerName ?? '';
    if (name.isEmpty) {
      final profile = await _db.collection('profiles').doc(_uid).get();
      name = profile.data()?['fullName'] as String? ?? 'Someone';
    }

    final doc = await _db.collection('calls').add({
      'caller': _uid,
      'callee': calleeUid,
      'callerName': name,
      'status': 'ringing',
      'offer': null,
      'answer': null,
      'callerCandidates': <Map<String, dynamic>>[],
      'calleeCandidates': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
      'endedAt': null,
    });

    // Send a notification so callee gets alerted even if app is closed
    await _db.collection('notifications').doc(calleeUid).collection('items').add({
      'type': 'incomingCall',
      'title': 'Incoming Video Call',
      'body': '$name is calling you',
      'senderId': _uid,
      'isRead': false,
      'actionUrl': '/call/${doc.id}',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  /// Listen for incoming calls
  Stream<QuerySnapshot<Map<String, dynamic>>> incomingCallsStream() {
    final uid = _uid;
    if (uid.isEmpty) return const Stream.empty();
    // Single field query — avoids composite index requirement
    return _db.collection('calls')
        .where('callee', isEqualTo: uid)
        .snapshots();
  }

  /// Listen for call document changes
  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream(String callId) {
    return _db.collection('calls').doc(callId).snapshots();
  }

  Future<void> setOffer(String callId, Map<String, dynamic> offer) async {
    await _db.collection('calls').doc(callId).update({'offer': offer});
  }

  Future<void> setAnswer(String callId, Map<String, dynamic> answer) async {
    await _db.collection('calls').doc(callId).update({
      'answer': answer,
      'status': 'active',
    });
  }

  Future<void> addCallerCandidate(String callId, Map<String, dynamic> candidate) async {
    await _db.collection('calls').doc(callId).update({
      'callerCandidates': FieldValue.arrayUnion([candidate]),
    });
  }

  Future<void> addCalleeCandidate(String callId, Map<String, dynamic> candidate) async {
    await _db.collection('calls').doc(callId).update({
      'calleeCandidates': FieldValue.arrayUnion([candidate]),
    });
  }

  Future<void> endCall(String callId) async {
    await _db.collection('calls').doc(callId).update({
      'status': 'ended',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> declineCall(String callId) async {
    await _db.collection('calls').doc(callId).update({
      'status': 'declined',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }
}

final callFirestoreServiceProvider = Provider<CallFirestoreService>((ref) {
  return CallFirestoreService();
});
