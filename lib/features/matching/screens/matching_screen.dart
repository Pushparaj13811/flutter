import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/matching/providers/matching_provider.dart';
import 'package:skill_exchange/features/matching/widgets/match_card.dart';
import 'package:skill_exchange/features/matching/widgets/matching_filters.dart';
import 'package:skill_exchange/core/widgets/animated_list_item.dart';
import 'package:skill_exchange/config/di/providers.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  final ScrollController _scrollController = ScrollController();

  static const _sortOptions = <String, String>{
    'compatibility': 'Best Match',
    'rating': 'Highest Rated',
    'sessions': 'Most Sessions',
    'activity': 'Recently Active',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Fetch initial matches after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paginatedMatchesProvider.notifier).fetchMatches();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (maxScroll - currentScroll <= threshold) {
      ref.read(paginatedMatchesProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(paginatedMatchesProvider.notifier).fetchMatches();
  }

  void _openFilters() {
    final currentFilters = ref.read(matchingFiltersProvider);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => MatchingFiltersSheet(
        currentFilters: currentFilters,
        onApply: (filters) {
          ref.read(matchingFiltersProvider.notifier).state = filters;
          ref.read(paginatedMatchesProvider.notifier).fetchMatches();
        },
      ),
    );
  }

  void _onSortChanged(String? value) {
    if (value == null) return;
    ref.read(matchingSortProvider.notifier).state = value;
    ref.read(paginatedMatchesProvider.notifier).fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(paginatedMatchesProvider);
    final currentSort = ref.watch(matchingSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Matching'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => context.push(RouteNames.search),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
            onPressed: _openFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Sort dropdown ──
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  'Sort by',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: currentSort,
                  underline: const SizedBox.shrink(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.foreground,
                  ),
                  items: _sortOptions.entries
                      .map(
                        (entry) => DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: _onSortChanged,
                ),
              ],
            ),
          ),

          // ── List ──
          Expanded(
            child: matchesAsync.when(
              loading: () => _buildLoadingSkeleton(),
              error: (error, _) => Center(
                child: ErrorMessage(
                  message: error.toString(),
                  onRetry: () => ref
                      .read(paginatedMatchesProvider.notifier)
                      .fetchMatches(),
                ),
              ),
              data: (matches) {
                if (matches.isEmpty) {
                  return const Center(
                    child: EmptyState(
                      icon: Icons.people_outline,
                      title: 'No matches found',
                      description:
                          'Try adjusting your filters or check back later for new matches.',
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    itemCount: matches.length + (_hasMore ? 1 : 0),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.listItemGap),
                    itemBuilder: (context, index) {
                      if (index >= matches.length) {
                        return const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppSpacing.lg),
                          child: SkeletonCard.match(),
                        );
                      }

                      final match = matches[index];
                      return AnimatedListItem(
                        index: index,
                        child: MatchCard(
                        match: match,
                        onTap: () => context.push(
                          '${RouteNames.profile}/${match.userId}',
                        ),
                        onConnect: () async {
                          try {
                            await ref.read(connectionFirestoreServiceProvider).sendRequest(match.userId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Connection request sent!')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed: $e')),
                              );
                            }
                          }
                        },
                        onBookSession: () => context.go(RouteNames.bookings),
                      ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasMore =>
      ref.read(paginatedMatchesProvider.notifier).hasMore;

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 5,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.match(),
    );
  }
}
