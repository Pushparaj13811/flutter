import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getReviewsForUser(String userId) async {
    final snap = await _db.collection('reviews')
        .where('toUser', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getReviewsByUser(String userId) async {
    final snap = await _db.collection('reviews')
        .where('fromUser', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<String> createReview(Map<String, dynamic> data) async {
    final doc = await _db.collection('reviews').add({
      ...data,
      'fromUser': _uid,
      'status': 'approved',
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }
}

final reviewFirestoreServiceProvider = Provider<ReviewFirestoreService>((ref) {
  return ReviewFirestoreService();
});
