import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PresenceService with WidgetsBindingObserver {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  void startTracking() {
    WidgetsBinding.instance.addObserver(this);
    _setOnline();
  }

  void stopTracking() {
    WidgetsBinding.instance.removeObserver(this);
    _setOffline();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_uid.isEmpty) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _setOnline();
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _setOffline();
    }
  }

  Future<void> _setOnline() async {
    if (_uid.isEmpty) return;
    try {
      await _db.collection('presence').doc(_uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> _setOffline() async {
    if (_uid.isEmpty) return;
    try {
      await _db.collection('presence').doc(_uid).set({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  /// Stream the online status of another user
  Stream<Map<String, dynamic>> userPresenceStream(String userId) {
    return _db.collection('presence').doc(userId).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return {'isOnline': false, 'lastSeen': null};
      return data;
    });
  }

  /// Check if user is online (one-time)
  Future<bool> isUserOnline(String userId) async {
    final doc = await _db.collection('presence').doc(userId).get();
    return doc.data()?['isOnline'] == true;
  }
}

final presenceServiceProvider = Provider<PresenceService>((ref) {
  return PresenceService();
});
