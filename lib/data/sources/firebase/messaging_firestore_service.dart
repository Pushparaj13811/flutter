import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  static String getThreadId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Real-time stream of threads for current user
  Stream<QuerySnapshot<Map<String, dynamic>>> threadsStream() {
    return _db.collection('messages')
        .where('participants', arrayContains: _uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  /// Real-time stream of messages in a thread
  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(String threadId) {
    return _db.collection('messages').doc(threadId)
        .collection('msgs')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(String receiverId, String content) async {
    final threadId = getThreadId(_uid, receiverId);
    final threadRef = _db.collection('messages').doc(threadId);

    // Ensure thread exists
    final threadDoc = await threadRef.get();
    if (!threadDoc.exists) {
      await threadRef.set({
        'participants': [_uid, receiverId],
        'lastMessage': content,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount_$_uid': 0,
        'unreadCount_$receiverId': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await threadRef.update({
        'lastMessage': content,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount_$receiverId': FieldValue.increment(1),
      });
    }

    // Add message
    await threadRef.collection('msgs').add({
      'sender': _uid,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  Future<void> markThreadRead(String threadId) async {
    await _db.collection('messages').doc(threadId).update({
      'unreadCount_$_uid': 0,
    });
  }

  /// Typing indicator: set/clear
  Future<void> setTyping(String threadId, bool isTyping) async {
    final ref = _db.collection('typing').doc(threadId);
    if (isTyping) {
      await ref.set({_uid: FieldValue.serverTimestamp()}, SetOptions(merge: true));
    } else {
      await ref.update({_uid: FieldValue.delete()});
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> typingStream(String threadId) {
    return _db.collection('typing').doc(threadId).snapshots();
  }

  Future<void> deleteConversation(String threadId) async {
    // Delete all messages in the thread
    final msgs = await _db.collection('messages').doc(threadId)
        .collection('msgs').get();
    final batch = _db.batch();
    for (final doc in msgs.docs) {
      batch.delete(doc.reference);
    }
    // Delete the thread document itself
    batch.delete(_db.collection('messages').doc(threadId));
    // Delete typing indicator
    batch.delete(_db.collection('typing').doc(threadId));
    await batch.commit();
  }

  Future<int> getUnreadCount() async {
    final snap = await _db.collection('messages')
        .where('participants', arrayContains: _uid)
        .get();
    int count = 0;
    for (final doc in snap.docs) {
      count += (doc.data()['unreadCount_$_uid'] as int?) ?? 0;
    }
    return count;
  }
}

final messagingFirestoreServiceProvider = Provider<MessagingFirestoreService>((ref) {
  return MessagingFirestoreService();
});
