import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';
import 'package:skill_exchange/data/models/learning_circle_model.dart';
import 'package:skill_exchange/data/repositories/community_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/community_remote_source.dart';
import 'package:skill_exchange/domain/repositories/community_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final communityRemoteSourceProvider = Provider<CommunityRemoteSource>((ref) {
  return CommunityRemoteSource(ref.watch(dioProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(ref.watch(communityRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final discussionPostsProvider =
    FutureProvider<List<DiscussionPostModel>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  final result = await repo.getPosts();
  return result.fold(
    (failure) => throw failure,
    (posts) => posts,
  );
});

final learningCirclesProvider =
    FutureProvider<List<LearningCircleModel>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  final result = await repo.getCircles();
  return result.fold(
    (failure) => throw failure,
    (circles) => circles,
  );
});

final leaderboardProvider =
    FutureProvider<List<LeaderboardEntryModel>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  final result = await repo.getLeaderboard();
  return result.fold(
    (failure) => throw failure,
    (entries) => entries,
  );
});

// ── Community Notifier ────────────────────────────────────────────────────

class CommunityNotifier extends StateNotifier<AsyncValue<void>> {
  final CommunityRepository _repository;
  final Ref _ref;

  CommunityNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createPost(
    String title,
    String content,
    List<String> tags,
  ) async {
    state = const AsyncValue.loading();
    final dto = CreatePostDto(title: title, content: content, tags: tags);
    final result = await _repository.createPost(dto);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(discussionPostsProvider);
        return true;
      },
    );
  }

  Future<bool> likePost(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.likePost(id);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(discussionPostsProvider);
        return true;
      },
    );
  }

  Future<bool> createCircle(
    String name,
    String description,
    List<String> skillFocus,
    int maxMembers,
  ) async {
    state = const AsyncValue.loading();
    final dto = CreateCircleDto(
      name: name,
      description: description,
      skillFocus: skillFocus,
      maxMembers: maxMembers,
    );
    final result = await _repository.createCircle(dto);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(learningCirclesProvider);
        return true;
      },
    );
  }

  Future<bool> joinCircle(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.joinCircle(id);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(learningCirclesProvider);
        return true;
      },
    );
  }
}

final communityNotifierProvider =
    StateNotifierProvider<CommunityNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return CommunityNotifier(repo, ref);
});
