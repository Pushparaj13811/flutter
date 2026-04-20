import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';

// ── Filter & Sort State ───────────────────────────────────────────────────

final matchingFiltersProvider = StateProvider<MatchingFiltersModel>((ref) {
  return const MatchingFiltersModel();
});

final matchingSortProvider = StateProvider<String>((ref) => 'compatibility');

// ── Paginated Matches Notifier ────────────────────────────────────────────

class PaginatedMatchesNotifier
    extends StateNotifier<AsyncValue<List<MatchScoreModel>>> {
  final MatchingFirestoreService _service;
  final Ref _ref;

  bool _hasMore = true;

  PaginatedMatchesNotifier(this._service, this._ref)
      : super(const AsyncValue.loading());

  bool get hasMore => _hasMore;

  /// Resets state and loads matches.
  Future<void> fetchMatches() async {
    _hasMore = false; // Firebase service returns all at once
    state = const AsyncValue.loading();

    try {
      final data = await _service.getSuggestions();
      final matches = data.map((d) => MatchScoreModel.fromJson(d)).toList();
      state = AsyncValue.data(matches);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// No-op since we load all at once from Firestore.
  Future<void> loadMore() async {}
}

final paginatedMatchesProvider = StateNotifierProvider<
    PaginatedMatchesNotifier, AsyncValue<List<MatchScoreModel>>>((ref) {
  final service = ref.watch(matchingFirestoreServiceProvider);
  return PaginatedMatchesNotifier(service, ref);
});

// ── Top Matches (for Dashboard) ───────────────────────────────────────────

final topMatchesProvider =
    FutureProvider.family<List<MatchScoreModel>, int>((ref, limit) async {
  final service = ref.watch(matchingFirestoreServiceProvider);
  final data = await service.getSuggestions();
  final matches = data.map((d) => MatchScoreModel.fromJson(d)).toList();
  return matches.take(limit).toList();
});
