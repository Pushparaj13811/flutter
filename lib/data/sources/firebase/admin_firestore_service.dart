import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getStats() async {
    final users = await _db.collection('users').count().get();
    final sessions = await _db.collection('sessions').where('status', isEqualTo: 'completed').count().get();
    final connections = await _db.collection('connections').where('status', isEqualTo: 'accepted').count().get();
    return {
      'totalUsers': users.count ?? 0,
      'totalSessions': sessions.count ?? 0,
      'totalConnections': connections.count ?? 0,
    };
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snap = await _db.collection('users').get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> banUser(String uid) async {
    await _db.collection('users').doc(uid).update({'isActive': false});
  }

  Future<void> unbanUser(String uid) async {
    await _db.collection('users').doc(uid).update({'isActive': true});
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _db.collection('users').doc(uid).update({'role': role});
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
    await _db.collection('profiles').doc(uid).delete();
    await _db.collection('matchPool').doc(uid).delete();
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final snap = await _db.collection('reports').orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    await _db.collection('reports').doc(id).update(data);
  }

  Future<void> moderatePost(String postId, String status, {String? reason}) async {
    await _db.collection('posts').doc(postId).update({
      'moderationStatus': status,
      if (reason != null) 'moderationReason': reason,
    });
  }

  Future<void> deleteReview(String reviewId) async {
    await _db.collection('reviews').doc(reviewId).delete();
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final snap = await _db.collection('posts').orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> deleteCircle(String circleId) async {
    await _db.collection('circles').doc(circleId).delete();
  }
}

final adminFirestoreServiceProvider = Provider<AdminFirestoreService>((ref) {
  return AdminFirestoreService();
});
