import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final discussionPostsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final data = await service.getPosts();
  final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  // Enrich with computed fields
  return data.map((d) {
    final likedBy = (d['likedBy'] as List?)?.cast<String>() ?? [];
    return {
      ...d,
      'isLikedByMe': likedBy.contains(currentUid),
      'likesCount': (d['likesCount'] as num?)?.toInt() ?? 0,
      'commentsCount': (d['repliesCount'] as num?)?.toInt() ??
          (d['commentsCount'] as num?)?.toInt() ?? 0,
    };
  }).toList();
});

final learningCirclesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final data = await service.getCircles();
  final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  return data.map((d) {
    final members = (d['members'] as List?)?.cast<String>() ?? [];
    return {
      ...d,
      'membersCount': members.length,
      'maxMembers': (d['maxMembers'] as num?)?.toInt() ?? 50,
      'isJoinedByMe': members.contains(currentUid),
      'skillFocus': (d['skillFocus'] as List?)?.cast<String>() ??
          (d['category'] != null ? [d['category'] as String] : <String>[]),
    };
  }).toList();
});

final leaderboardProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final data = await service.getLeaderboard();
  final entries = <Map<String, dynamic>>[];
  for (int i = 0; i < data.length; i++) {
    final d = data[i];
    entries.add({
      ...d,
      'rank': i + 1,
      'points': ((d['sessionsCompleted'] as num? ?? 0) * 10 +
              (d['averageRating'] as num? ?? 0) * 20)
          .toInt(),
      'sessionsCompleted': (d['sessionsCompleted'] as num?)?.toInt() ?? 0,
      'averageRating': (d['averageRating'] as num?)?.toDouble() ?? 0.0,
    });
  }
  return entries;
});

// ── Community Notifier ────────────────────────────────────────────────────

class CommunityNotifier extends StateNotifier<AsyncValue<void>> {
  final CommunityFirestoreService _service;
  final Ref _ref;

  CommunityNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createPost(
    String title,
    String content,
    List<String> tags,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _service.createPost({
        'title': title,
        'content': content,
        'tags': tags,
      });
      state = const AsyncValue.data(null);
      _ref.invalidate(discussionPostsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> likePost(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.likePost(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(discussionPostsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> createCircle(
    String name,
    String description,
    List<String> skillFocus,
    int maxMembers,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _service.createCircle({
        'name': name,
        'description': description,
        'skillFocus': skillFocus,
        'maxMembers': maxMembers,
      });
      state = const AsyncValue.data(null);
      _ref.invalidate(learningCirclesProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> joinCircle(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.joinCircle(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(learningCirclesProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> leaveCircle(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.leaveCircle(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(learningCirclesProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final communityNotifierProvider =
    StateNotifierProvider<CommunityNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(communityFirestoreServiceProvider);
  return CommunityNotifier(service, ref);
});
