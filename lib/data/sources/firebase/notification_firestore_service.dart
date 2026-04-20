import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream() {
    return _db.collection('notifications').doc(_uid).collection('items')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<int> getUnreadCount() async {
    final snap = await _db.collection('notifications').doc(_uid).collection('items')
        .where('isRead', isEqualTo: false)
        .get();
    return snap.size;
  }

  Future<void> markAsRead(String notifId) async {
    await _db.collection('notifications').doc(_uid).collection('items').doc(notifId).update({
      'isRead': true,
    });
  }

  Future<void> markAllAsRead() async {
    final snap = await _db.collection('notifications').doc(_uid).collection('items')
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String notifId) async {
    await _db.collection('notifications').doc(_uid).collection('items').doc(notifId).delete();
  }

  /// Helper: create a notification for a user
  Future<void> createNotification(String forUid, Map<String, dynamic> data) async {
    await _db.collection('notifications').doc(forUid).collection('items').add({
      ...data,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final notificationFirestoreServiceProvider = Provider<NotificationFirestoreService>((ref) {
  return NotificationFirestoreService();
});
