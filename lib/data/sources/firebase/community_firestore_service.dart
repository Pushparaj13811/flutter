import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';

class CommunityFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  CommunityFirestoreService(this._cloudinary);

  // ── Posts ──
  Future<List<Map<String, dynamic>>> getPosts({String? category, int limit = 20}) async {
    Query<Map<String, dynamic>> query = _db.collection('posts')
        .where('moderationStatus', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (category != null) {
      query = _db.collection('posts')
          .where('moderationStatus', isEqualTo: 'active')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .limit(limit);
    }
    final snap = await query.get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<String> createPost(Map<String, dynamic> data) async {
    final doc = await _db.collection('posts').add({
      ...data,
      'author': _uid,
      'likesCount': 0,
      'repliesCount': 0,
      'likedBy': <String>[],
      'moderationStatus': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  Future<List<String>> uploadPostMedia(List<File> files) async {
    final urls = <String>[];
    for (final file in files) {
      final url = await _cloudinary.uploadImage(file, folder: 'posts');
      urls.add(url);
    }
    return urls;
  }

  Future<String> uploadPostVideo(File file) async {
    return _cloudinary.uploadVideo(file, folder: 'posts/videos');
  }

  // ── Likes (toggle) ──
  Future<void> likePost(String postId) async {
    final postDoc = await _db.collection('posts').doc(postId).get();
    final likedBy = (postDoc.data()?['likedBy'] as List?)?.cast<String>() ?? [];

    if (likedBy.contains(_uid)) {
      // Already liked — unlike
      await _db.collection('posts').doc(postId).update({
        'likedBy': FieldValue.arrayRemove([_uid]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      // Not liked — like
      await _db.collection('posts').doc(postId).update({
        'likedBy': FieldValue.arrayUnion([_uid]),
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  /// Kept for backward compatibility — calls [likePost] which toggles.
  Future<void> unlikePost(String postId) async {
    await likePost(postId);
  }

  bool hasUserLiked(Map<String, dynamic> postData) {
    final likedBy = (postData['likedBy'] as List?)?.cast<String>() ?? [];
    return likedBy.contains(_uid);
  }

  // ── Replies ──
  Future<List<Map<String, dynamic>>> getPostReplies(String postId) async {
    final snap = await _db.collection('posts').doc(postId).collection('replies')
        .orderBy('createdAt', descending: false)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> createReply(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).collection('replies').add({
      ...data,
      'author': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('posts').doc(postId).update({
      'repliesCount': FieldValue.increment(1),
    });
  }

  // ── Circle Posts ──
  Future<List<Map<String, dynamic>>> getCirclePosts(String circleId) async {
    final snap = await _db.collection('posts')
        .where('circle', isEqualTo: circleId)
        .where('moderationStatus', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  // ── Circle by ID ──
  Future<Map<String, dynamic>> getCircleById(String circleId) async {
    final doc = await _db.collection('circles').doc(circleId).get();
    if (!doc.exists) throw Exception('Circle not found');
    return {'id': doc.id, ...doc.data()!};
  }

  // ── Circles ──
  Future<List<Map<String, dynamic>>> getCircles() async {
    final snap = await _db.collection('circles').get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<String> createCircle(Map<String, dynamic> data) async {
    final doc = await _db.collection('circles').add({
      ...data,
      'createdBy': _uid,
      'members': [_uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> joinCircle(String circleId) async {
    await _db.collection('circles').doc(circleId).update({
      'members': FieldValue.arrayUnion([_uid]),
    });
  }

  Future<void> leaveCircle(String circleId) async {
    await _db.collection('circles').doc(circleId).update({
      'members': FieldValue.arrayRemove([_uid]),
    });
  }

  bool isMember(Map<String, dynamic> circleData) {
    final members = (circleData['members'] as List?)?.cast<String>() ?? [];
    return members.contains(_uid);
  }

  // ── Leaderboard ──
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    final snap = await _db.collection('matchPool')
        .orderBy('sessionsCompleted', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }
}

final communityFirestoreServiceProvider = Provider<CommunityFirestoreService>((ref) {
  return CommunityFirestoreService(ref.watch(cloudinaryServiceProvider));
});
