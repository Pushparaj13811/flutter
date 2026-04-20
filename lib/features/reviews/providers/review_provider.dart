import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/data/models/review_model.dart';
import 'package:skill_exchange/data/models/review_stats_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final reviewsProvider =
    FutureProvider.family<List<ReviewModel>, String>((ref, userId) async {
  final service = ref.watch(reviewFirestoreServiceProvider);
  final data = await service.getReviewsForUser(userId);
  return data.map((d) => ReviewModel.fromJson(d)).toList();
});

final reviewStatsProvider =
    FutureProvider.family<ReviewStatsModel, String>((ref, userId) async {
  final service = ref.watch(reviewFirestoreServiceProvider);
  final data = await service.getReviewsForUser(userId);
  // Compute stats from reviews
  if (data.isEmpty) {
    return ReviewStatsModel.fromJson({
      'averageRating': 0.0,
      'totalReviews': 0,
    });
  }
  final ratings = data.map((d) => (d['rating'] as num?)?.toDouble() ?? 0.0).toList();
  final avg = ratings.reduce((a, b) => a + b) / ratings.length;
  return ReviewStatsModel.fromJson({
    'averageRating': avg,
    'totalReviews': data.length,
  });
});

// ── Review Notifier ───────────────────────────────────────────────────────

class ReviewNotifier extends StateNotifier<AsyncValue<void>> {
  final ReviewFirestoreService _service;
  final Ref _ref;

  ReviewNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createReview(CreateReviewDto dto) async {
    state = const AsyncValue.loading();
    try {
      await _service.createReview(dto.toJson());
      state = const AsyncValue.data(null);
      _ref.invalidate(reviewsProvider(dto.toUserId));
      _ref.invalidate(reviewStatsProvider(dto.toUserId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final reviewNotifierProvider =
    StateNotifierProvider<ReviewNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(reviewFirestoreServiceProvider);
  return ReviewNotifier(service, ref);
});
