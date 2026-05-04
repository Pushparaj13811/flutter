import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationTriggerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<String> _getCurrentUserName() async {
    final doc = await _db.collection('profiles').doc(_uid).get();
    return doc.data()?['fullName'] as String? ?? 'Someone';
  }

  Future<void> onConnectionRequestSent(String toUserId) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'connectionRequest',
      'title': 'New Connection Request',
      'body': '$name wants to connect with you',
      'actionUrl': '/profile/$_uid',
    });
  }

  Future<void> onConnectionAccepted(String toUserId) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'connectionAccepted',
      'title': 'Connection Accepted',
      'body': '$name accepted your connection request',
      'actionUrl': '/profile/$_uid',
    });
  }

  Future<void> onSessionBooked(String toUserId, String sessionTitle) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'sessionReminder',
      'title': 'New Session Booked',
      'body': '$name booked a session: $sessionTitle',
      'actionUrl': '/bookings',
    });
  }

  Future<void> onSessionCompleted(String toUserId, String sessionTitle) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'sessionCompleted',
      'title': 'Session Completed',
      'body': 'Session "$sessionTitle" with $name is completed',
      'actionUrl': '/bookings',
    });
  }

  Future<void> onSessionCancelled(String toUserId, String sessionTitle) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'sessionCancelled',
      'title': 'Session Cancelled',
      'body': '$name cancelled the session: $sessionTitle',
      'actionUrl': '/bookings',
    });
  }

  Future<void> onNewMessage(String toUserId, String preview) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'newMessage',
      'title': name,
      'body': preview.length > 50 ? '${preview.substring(0, 50)}...' : preview,
      'actionUrl': '/messages/$_uid',
    });
  }

  Future<void> onReviewReceived(String toUserId, int rating) async {
    final name = await _getCurrentUserName();
    await _createNotification(toUserId, {
      'type': 'reviewReceived',
      'title': 'New Review',
      'body': '$name gave you a $rating-star review',
      'actionUrl': '/profile',
    });
  }

  Future<void> _createNotification(
      String forUid, Map<String, dynamic> data) async {
    if (forUid == _uid) return; // Don't notify yourself
    await _db
        .collection('notifications')
        .doc(forUid)
        .collection('items')
        .add({
      ...data,
      'senderId': _uid,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final notificationTriggerServiceProvider =
    Provider<NotificationTriggerService>((ref) {
  return NotificationTriggerService();
});
