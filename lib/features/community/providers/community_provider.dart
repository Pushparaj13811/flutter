import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/utils/firestore_helpers.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';
import 'package:skill_exchange/data/models/learning_circle_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final discussionPostsProvider =
    FutureProvider<List<DiscussionPostModel>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final data = await service.getPosts();
  return data.map((d) => parseDiscussionPost(d)).toList();
});

final learningCirclesProvider =
    FutureProvider<List<LearningCircleModel>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final data = await service.getCircles();
  return data.map((d) => parseCircle(d)).toList();
});

final leaderboardProvider =
    FutureProvider<List<LeaderboardEntryModel>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final data = await service.getLeaderboard();
  return parseLeaderboard(data);
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
}

final communityNotifierProvider =
    StateNotifierProvider<CommunityNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(communityFirestoreServiceProvider);
  return CommunityNotifier(service, ref);
});
