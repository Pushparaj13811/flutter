import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';
import 'package:skill_exchange/data/repositories/matching_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/matching_remote_source.dart';
import 'package:skill_exchange/domain/repositories/matching_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final matchingRemoteSourceProvider = Provider<MatchingRemoteSource>((ref) {
  return MatchingRemoteSource(ref.watch(dioProvider));
});

final matchingRepositoryProvider = Provider<MatchingRepository>((ref) {
  return MatchingRepositoryImpl(ref.watch(matchingRemoteSourceProvider));
});

// ── Filter & Sort State ───────────────────────────────────────────────────

final matchingFiltersProvider = StateProvider<MatchingFiltersModel>((ref) {
  return const MatchingFiltersModel();
});

final matchingSortProvider = StateProvider<String>((ref) => 'compatibility');

// ── Paginated Matches Notifier ────────────────────────────────────────────

class PaginatedMatchesNotifier
    extends StateNotifier<AsyncValue<List<MatchScoreModel>>> {
  final MatchingRepository _repository;
  final Ref _ref;

  int _currentPage = 0;
  bool _hasMore = true;
  static const int _pageSize = 20;

  PaginatedMatchesNotifier(this._repository, this._ref)
      : super(const AsyncValue.loading());

  bool get hasMore => _hasMore;

  /// Resets state and loads page 1.
  Future<void> fetchMatches() async {
    _currentPage = 0;
    _hasMore = true;
    state = const AsyncValue.loading();

    await _loadPage(1);
  }

  /// Appends the next page to the existing list.
  Future<void> loadMore() async {
    if (!_hasMore) return;
    // Don't load more if already loading.
    if (state is AsyncLoading) return;

    await _loadPage(_currentPage + 1, append: true);
  }

  Future<void> _loadPage(int page, {bool append = false}) async {
    final filters = _ref.read(matchingFiltersProvider);
    final sortBy = _ref.read(matchingSortProvider);

    final result = await _repository.getMatches(
      filters: filters,
      sortBy: sortBy,
      page: page,
      pageSize: _pageSize,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (paginatedResponse) {
        _currentPage = page;
        _hasMore = paginatedResponse.pagination.hasNextPage;

        final newItems = paginatedResponse.data;
        if (append) {
          final existing = state.valueOrNull ?? [];
          state = AsyncValue.data([...existing, ...newItems]);
        } else {
          state = AsyncValue.data(newItems);
        }
      },
    );
  }
}

final paginatedMatchesProvider = StateNotifierProvider<
    PaginatedMatchesNotifier, AsyncValue<List<MatchScoreModel>>>((ref) {
  final repository = ref.watch(matchingRepositoryProvider);
  return PaginatedMatchesNotifier(repository, ref);
});

// ── Top Matches (for Dashboard) ───────────────────────────────────────────

final topMatchesProvider =
    FutureProvider.family<List<MatchScoreModel>, int>((ref, limit) async {
  final repo = ref.watch(matchingRepositoryProvider);
  final result = await repo.getTopMatches(limit);
  return result.fold(
    (failure) => throw failure,
    (matches) => matches,
  );
});
