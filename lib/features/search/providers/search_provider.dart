import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/utils/firestore_helpers.dart';
import 'package:skill_exchange/data/models/search_result_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

// ── Query & Filter State ─────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchFiltersProvider = StateProvider<SearchFiltersModel?>((ref) => null);

// ── Paginated Search Notifier ────────────────────────────────────────────

class SearchNotifier
    extends StateNotifier<AsyncValue<List<UserProfileModel>>> {
  final SearchFirestoreService _service;
  final Ref _ref;

  bool _hasMore = false;

  SearchNotifier(this._service, this._ref)
      : super(const AsyncValue.data([]));

  bool get hasMore => _hasMore;

  /// Resets pagination and performs a fresh search.
  Future<void> search(String query, {SearchFiltersModel? filters}) async {
    // Update shared state so other providers stay in sync.
    _ref.read(searchQueryProvider.notifier).state = query;
    if (filters != null) {
      _ref.read(searchFiltersProvider.notifier).state = filters;
    }

    state = const AsyncValue.loading();

    try {
      final data = await _service.searchUsers(
        query: query.isEmpty ? null : query,
        skillCategory: filters?.skillCategory,
        location: filters?.location,
      );
      final results = data.map((d) => parseSearchResult(d)).toList();
      _hasMore = false; // Firebase returns all at once
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// No-op since Firebase search returns all results at once.
  Future<void> loadMore() async {}

  /// Clears all results and resets to the initial empty state.
  void clearSearch() {
    _hasMore = false;
    _ref.read(searchQueryProvider.notifier).state = '';
    _ref.read(searchFiltersProvider.notifier).state = null;
    state = const AsyncValue.data([]);
  }
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier,
    AsyncValue<List<UserProfileModel>>>((ref) {
  final service = ref.watch(searchFirestoreServiceProvider);
  return SearchNotifier(service, ref);
});
