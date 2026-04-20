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

    // Update reviewed user's stats
    final toUser = data['toUser'] as String;
    final rating = (data['rating'] as num).toDouble();

    // Get current stats to calculate new average
    final profileDoc = await _db.collection('profiles').doc(toUser).get();
    final stats = (profileDoc.data()?['stats'] as Map<String, dynamic>?) ?? {};
    final currentCount = (stats['reviewsReceived'] as num?)?.toInt() ?? 0;
    final currentAvg = (stats['averageRating'] as num?)?.toDouble() ?? 0.0;
    final newCount = currentCount + 1;
    final newAvg = ((currentAvg * currentCount) + rating) / newCount;

    await _db.collection('profiles').doc(toUser).update({
      'stats.reviewsReceived': newCount,
      'stats.averageRating': double.parse(newAvg.toStringAsFixed(1)),
    });

    // Also update matchPool
    await _db.collection('matchPool').doc(toUser).update({
      'averageRating': double.parse(newAvg.toStringAsFixed(1)),
    });

    return doc.id;
  }
}

final reviewFirestoreServiceProvider = Provider<ReviewFirestoreService>((ref) {
  return ReviewFirestoreService();
});
