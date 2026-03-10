import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/data/models/review_model.dart';
import 'package:skill_exchange/data/models/review_stats_model.dart';
import 'package:skill_exchange/data/repositories/review_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/review_remote_source.dart';
import 'package:skill_exchange/domain/repositories/review_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final reviewRemoteSourceProvider = Provider<ReviewRemoteSource>((ref) {
  return ReviewRemoteSource(ref.watch(dioProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final reviewsProvider =
    FutureProvider.family<List<ReviewModel>, String>((ref, userId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getReviews(userId);
  return result.fold(
    (failure) => throw failure,
    (reviews) => reviews,
  );
});

final reviewStatsProvider =
    FutureProvider.family<ReviewStatsModel, String>((ref, userId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getReviewStats(userId);
  return result.fold(
    (failure) => throw failure,
    (stats) => stats,
  );
});

// ── Review Notifier ───────────────────────────────────────────────────────

class ReviewNotifier extends StateNotifier<AsyncValue<void>> {
  final ReviewRepository _repository;
  final Ref _ref;

  ReviewNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createReview(CreateReviewDto dto) async {
    state = const AsyncValue.loading();
    final result = await _repository.createReview(dto);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(reviewsProvider(dto.toUserId));
        _ref.invalidate(reviewStatsProvider(dto.toUserId));
        return true;
      },
    );
  }
}

final reviewNotifierProvider =
    StateNotifierProvider<ReviewNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(reviewRepositoryProvider);
  return ReviewNotifier(repo, ref);
});
