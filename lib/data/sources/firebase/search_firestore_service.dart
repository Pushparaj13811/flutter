import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<Map<String, dynamic>>> searchUsers({
    String? query,
    String? skillCategory,
    String? location,
    int limit = 20,
  }) async {
    // Firestore doesn't support full-text search, so we fetch and filter client-side
    Query<Map<String, dynamic>> q = _db.collection('matchPool').limit(100);

    final snap = await q.get();
    var results = snap.docs
        .where((d) => d.id != _uid)
        .map((d) => {'id': d.id, ...d.data()})
        .toList();

    // Client-side filtering
    if (query != null && query.isNotEmpty) {
      final lq = query.toLowerCase();
      results = results.where((r) {
        final username = (r['username'] as String? ?? '').toLowerCase();
        final skills = [
          ...((r['skillsToTeach'] as List?) ?? []),
          ...((r['skillsToLearn'] as List?) ?? []),
        ];
        final skillNames = skills.map((s) => ((s as Map)['name'] as String? ?? '').toLowerCase());
        return username.contains(lq) || skillNames.any((n) => n.contains(lq));
      }).toList();
    }

    if (skillCategory != null) {
      results = results.where((r) {
        final skills = [...((r['skillsToTeach'] as List?) ?? []), ...((r['skillsToLearn'] as List?) ?? [])];
        return skills.any((s) => (s as Map)['category'] == skillCategory);
      }).toList();
    }

    if (location != null && location.isNotEmpty) {
      final ll = location.toLowerCase();
      results = results.where((r) => ((r['location'] as String?) ?? '').toLowerCase().contains(ll)).toList();
    }

    return results.take(limit).toList();
  }
}

final searchFirestoreServiceProvider = Provider<SearchFirestoreService>((ref) {
  return SearchFirestoreService();
});
