import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/search_result_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/data/repositories/search_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/search_remote_source.dart';
import 'package:skill_exchange/domain/repositories/search_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final searchRemoteSourceProvider = Provider<SearchRemoteSource>((ref) {
  return SearchRemoteSource(ref.watch(dioProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.watch(searchRemoteSourceProvider));
});

// ── Query & Filter State ─────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchFiltersProvider = StateProvider<SearchFiltersModel?>((ref) => null);

// ── Paginated Search Notifier ────────────────────────────────────────────

class SearchNotifier
    extends StateNotifier<AsyncValue<List<UserProfileModel>>> {
  final SearchRepository _repository;
  final Ref _ref;

  int _currentPage = 0;
  bool _hasMore = true;
  static const int _pageSize = 20;

  SearchNotifier(this._repository, this._ref)
      : super(const AsyncValue.data([]));

  bool get hasMore => _hasMore;

  /// Resets pagination and performs a fresh search.
  Future<void> search(String query, {SearchFiltersModel? filters}) async {
    _currentPage = 0;
    _hasMore = true;

    // Update shared state so other providers stay in sync.
    _ref.read(searchQueryProvider.notifier).state = query;
    if (filters != null) {
      _ref.read(searchFiltersProvider.notifier).state = filters;
    }

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

  /// Clears all results and resets to the initial empty state.
  void clearSearch() {
    _currentPage = 0;
    _hasMore = true;
    _ref.read(searchQueryProvider.notifier).state = '';
    _ref.read(searchFiltersProvider.notifier).state = null;
    state = const AsyncValue.data([]);
  }

  Future<void> _loadPage(int page, {bool append = false}) async {
    final query = _ref.read(searchQueryProvider);
    final filters = _ref.read(searchFiltersProvider);

    // Build the combined filters model, injecting the query.
    final searchFilters = (filters ?? const SearchFiltersModel()).copyWith(
      query: query.isEmpty ? null : query,
    );

    final result = await _repository.searchUsers(
      searchFilters,
      page: page,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (searchResult) {
        _currentPage = page;
        _hasMore = searchResult.users.length >= _pageSize &&
            searchResult.page * searchResult.pageSize < searchResult.total;

        final newItems = searchResult.users;
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

final searchNotifierProvider = StateNotifierProvider<SearchNotifier,
    AsyncValue<List<UserProfileModel>>>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository, ref);
});
