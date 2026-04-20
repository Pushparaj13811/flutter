import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchingFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getSuggestions() async {
    // Get current user's skills to learn
    final myProfile = await _db.collection('profiles').doc(_uid).get();
    final mySkillsToLearn = (myProfile.data()?['skillsToLearn'] as List?) ?? [];
    final wantedCategories = mySkillsToLearn.map((s) => (s as Map)['category'] as String).toSet();

    // Query matchPool excluding self
    final snap = await _db.collection('matchPool')
        .limit(50)
        .get();

    final results = <Map<String, dynamic>>[];
    for (final doc in snap.docs) {
      if (doc.id == _uid) continue;
      final data = doc.data();
      final theirSkillsToTeach = (data['skillsToTeach'] as List?) ?? [];
      final theirCategories = theirSkillsToTeach.map((s) => (s as Map)['category'] as String).toSet();

      // Simple overlap score
      final overlap = wantedCategories.intersection(theirCategories).length;
      if (overlap > 0) {
        results.add({'id': doc.id, ...data, 'score': overlap});
      }
    }

    results.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return results.take(20).toList();
  }
}

final matchingFirestoreServiceProvider = Provider<MatchingFirestoreService>((ref) {
  return MatchingFirestoreService();
});
