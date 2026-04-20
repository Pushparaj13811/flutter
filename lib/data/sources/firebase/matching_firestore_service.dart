import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchingFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getSuggestions() async {
    final myProfile = await _db.collection('profiles').doc(_uid).get();
    final myData = myProfile.data() ?? {};
    final mySkillsToLearn = (myData['skillsToLearn'] as List?) ?? [];
    final mySkillsToTeach = (myData['skillsToTeach'] as List?) ?? [];
    final wantedCategories =
        mySkillsToLearn.map((s) => (s as Map)['category'] as String).toSet();
    final teachingCategories =
        mySkillsToTeach.map((s) => (s as Map)['category'] as String).toSet();

    final snap = await _db.collection('matchPool').limit(50).get();

    final results = <Map<String, dynamic>>[];
    for (final doc in snap.docs) {
      if (doc.id == _uid) continue;
      final data = doc.data();

      final theirSkillsToTeach = (data['skillsToTeach'] as List?) ?? [];
      final theirSkillsToLearn = (data['skillsToLearn'] as List?) ?? [];
      final theirTeachCategories =
          theirSkillsToTeach.map((s) => (s as Map)['category'] as String).toSet();
      final theirLearnCategories =
          theirSkillsToLearn.map((s) => (s as Map)['category'] as String).toSet();

      // Compute overlap scores
      final theyTeachWhatIWant =
          wantedCategories.intersection(theirTeachCategories).length;
      final iTeachWhatTheyWant =
          teachingCategories.intersection(theirLearnCategories).length;
      final totalScore = theyTeachWhatIWant + iTeachWhatTheyWant;

      // Include ALL users, not just those with overlap
      results.add({
        'userId': doc.id,
        'username': data['username'] ?? '',
        'avatar': data['avatar'],
        'location': data['location'] ?? '',
        'skillsToTeach': theirSkillsToTeach,
        'skillsToLearn': theirSkillsToLearn,
        'averageRating': (data['averageRating'] ?? 0).toDouble(),
        'sessionsCompleted': data['sessionsCompleted'] ?? 0,
        'compatibilityScore': totalScore > 0
            ? (totalScore /
                    (wantedCategories.length + teachingCategories.length)
                        .clamp(1, 100))
                .clamp(0.0, 1.0)
            : 0.0,
        'score': totalScore,
      });
    }

    // Sort by score descending, then by rating
    results.sort((a, b) {
      final cmp = (b['score'] as int).compareTo(a['score'] as int);
      if (cmp != 0) return cmp;
      return (b['averageRating'] as double)
          .compareTo(a['averageRating'] as double);
    });

    return results;
  }
}

final matchingFirestoreServiceProvider =
    Provider<MatchingFirestoreService>((ref) {
  return MatchingFirestoreService();
});
