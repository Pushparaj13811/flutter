import 'dart:async';

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
import 'package:skill_exchange/features/search/providers/search_provider.dart';
import 'package:skill_exchange/features/search/widgets/search_filters_sheet.dart';
import 'package:skill_exchange/features/search/widgets/search_result_card.dart';
import 'package:skill_exchange/core/widgets/animated_list_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
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
      ref.read(searchNotifierProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        ref.read(searchNotifierProvider.notifier).clearSearch();
        return;
      }

      final filters = ref.read(searchFiltersProvider);
      ref.read(searchNotifierProvider.notifier).search(
            query.trim(),
            filters: filters,
          );
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchNotifierProvider.notifier).clearSearch();
  }

  void _openFilters() {
    final currentFilters = ref.read(searchFiltersProvider);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SearchFiltersSheet(
        currentFilters: currentFilters,
        onApply: (filters) {
          ref.read(searchFiltersProvider.notifier).state = filters;

          final query = _searchController.text.trim();
          if (query.isNotEmpty) {
            ref.read(searchNotifierProvider.notifier).search(
                  query,
                  filters: filters,
                );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchNotifierProvider);
    final currentQuery = ref.watch(searchQueryProvider);
    final hasActiveFilters = ref.watch(searchFiltersProvider) != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filters',
                onPressed: _openFilters,
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // -- Search bar --
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.foreground,
              ),
              decoration: InputDecoration(
                hintText: 'Search users, skills...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.mutedForeground,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.colors.mutedForeground,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: context.colors.mutedForeground,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  borderSide: BorderSide(color: context.colors.input),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  borderSide: BorderSide(color: context.colors.input),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  borderSide:
                      BorderSide(color: context.colors.ring, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),

          // -- Results area --
          Expanded(
            child: currentQuery.isEmpty
                ? _buildInitialState()
                : searchAsync.when(
                    loading: () => _buildLoadingSkeleton(),
                    error: (error, _) => Center(
                      child: ErrorMessage(
                        message: error.toString(),
                        onRetry: () {
                          final query = _searchController.text.trim();
                          if (query.isNotEmpty) {
                            ref
                                .read(searchNotifierProvider.notifier)
                                .search(query);
                          }
                        },
                      ),
                    ),
                    data: (users) {
                      if (users.isEmpty) {
                        return const Center(
                          child: EmptyState(
                            icon: Icons.search_off,
                            title: 'No results found',
                            description:
                                'Try adjusting your search terms or filters to find what you are looking for.',
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          final query = _searchController.text.trim();
                          if (query.isNotEmpty) {
                            await ref
                                .read(searchNotifierProvider.notifier)
                                .search(query);
                          }
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(
                            AppSpacing.screenPadding,
                          ),
                          itemCount: users.length + (_hasMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.listItemGap),
                          itemBuilder: (context, index) {
                            if (index >= users.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSpacing.lg,
                                ),
                                child: SkeletonCard.match(),
                              );
                            }

                            final user = users[index];
                            return AnimatedListItem(
                              index: index,
                              child: SearchResultCard(
                                user: user,
                                onTap: () => context.push(
                                  '${RouteNames.profile}/${user.id}',
                                ),
                                onConnect: () {
                                  // TODO: Wire to connection request
                                },
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
      ref.read(searchNotifierProvider.notifier).hasMore;

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: context.colors.mutedForeground.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Find skill partners',
            style: AppTextStyles.h3.copyWith(
              color: context.colors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Search by name, skill, or location to discover\npeople to exchange skills with.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

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
