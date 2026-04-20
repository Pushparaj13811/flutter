import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';

class ProfileFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary;

  ProfileFirestoreService(this._cloudinary);

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> getMyProfile() async {
    final doc = await _db.collection('profiles').doc(_uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final doc = await _db.collection('profiles').doc(uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> getProfileByUsername(String username) async {
    final usernameDoc = await _db.collection('usernames').doc(username.toLowerCase()).get();
    if (!usernameDoc.exists) return null;
    final uid = usernameDoc.data()!['uid'] as String;
    return getProfile(uid);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('profiles').doc(_uid).update(data);

    // Also update matchPool
    final matchData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (data.containsKey('skillsToTeach')) matchData['skillsToTeach'] = data['skillsToTeach'];
    if (data.containsKey('skillsToLearn')) matchData['skillsToLearn'] = data['skillsToLearn'];
    if (data.containsKey('availability')) matchData['availability'] = data['availability'];
    if (data.containsKey('location')) matchData['location'] = data['location'];
    if (data.containsKey('username')) matchData['username'] = data['username'];
    if (data.containsKey('avatar')) matchData['avatar'] = data['avatar'];

    if (matchData.length > 1) {
      await _db.collection('matchPool').doc(_uid).update(matchData);
    }
  }

  Future<String> uploadAvatar(File file) async {
    final url = await _cloudinary.uploadImage(file, folder: 'avatars');
    await _db.collection('profiles').doc(_uid).update({'avatar': url, 'updatedAt': FieldValue.serverTimestamp()});
    await _db.collection('matchPool').doc(_uid).update({'avatar': url});
    await _db.collection('users').doc(_uid).update({'avatar': url});
    return url;
  }

  Future<String> uploadCoverImage(File file) async {
    final url = await _cloudinary.uploadImage(file, folder: 'covers');
    await _db.collection('profiles').doc(_uid).update({'coverImage': url, 'updatedAt': FieldValue.serverTimestamp()});
    return url;
  }

  Future<void> removeCoverImage() async {
    await _db.collection('profiles').doc(_uid).update({'coverImage': null, 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    final doc = await _db.collection('profiles').doc(_uid).get();
    final data = doc.data();
    if (data == null) return null;
    return {
      'privacyPreferences': data['privacyPreferences'],
      'notificationPreferences': data['notificationPreferences'],
    };
  }

  Future<void> updatePreferences(Map<String, dynamic> prefs) async {
    await _db.collection('profiles').doc(_uid).update({
      ...prefs,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

final profileFirestoreServiceProvider = Provider<ProfileFirestoreService>((ref) {
  return ProfileFirestoreService(ref.watch(cloudinaryServiceProvider));
});
