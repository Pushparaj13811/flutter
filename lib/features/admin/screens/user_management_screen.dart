import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/user_action_sheet.dart';

// ── Filter State ──────────────────────────────────────────────────────────

enum UserStatusFilter { all, active, banned }

final userSearchQueryProvider = StateProvider<String>((_) => '');
final userStatusFilterProvider =
    StateProvider<UserStatusFilter>((_) => UserStatusFilter.all);

// ── Screen ────────────────────────────────────────────────────────────────

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(userSearchQueryProvider);
    final statusFilter = ref.watch(userStatusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(reportedContentProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar and filter
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (value) {
                    ref.read(userSearchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              ref
                                  .read(userSearchQueryProvider.notifier)
                                  .state = '';
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.input),
                      borderSide: BorderSide(color: context.colors.input),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.input),
                      borderSide: BorderSide(color: context.colors.input),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.input),
                      borderSide: BorderSide(color: context.colors.ring),
                    ),
                    filled: true,
                    fillColor: context.colors.card,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Status filter chips
                Row(
                  children: UserStatusFilter.values.map((filter) {
                    final isSelected = statusFilter == filter;
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(_filterLabel(filter)),
                        selected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(userStatusFilterProvider.notifier)
                              .state = filter;
                        },
                        selectedColor:
                            context.colors.primary.withValues(alpha: 0.1),
                        checkmarkColor: context.colors.primary,
                        labelStyle: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.mutedForeground,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.border,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Users list
          Expanded(
            child: _UsersList(
              searchQuery: searchQuery,
              statusFilter: statusFilter,
            ),
          ),
        ],
      ),
    );
  }

  String _filterLabel(UserStatusFilter filter) {
    return switch (filter) {
      UserStatusFilter.all => 'All',
      UserStatusFilter.active => 'Active',
      UserStatusFilter.banned => 'Banned',
    };
  }
}

// ── Users List ────────────────────────────────────────────────────────────

class _UsersList extends ConsumerWidget {
  const _UsersList({
    required this.searchQuery,
    required this.statusFilter,
  });

  final String searchQuery;
  final UserStatusFilter statusFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use reported content to derive a list of reported user IDs for admin context.
    // In a full implementation, this would use a dedicated admin users endpoint.
    final reportsAsync = ref.watch(reportedContentProvider);

    return reportsAsync.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppSpacing.listItemGap),
        itemBuilder: (_, _) => const SkeletonCard.profile(),
      ),
      error: (e, _) => Center(
        child: ErrorMessage(
          message: 'Could not load users.',
          onRetry: () => ref.invalidate(reportedContentProvider),
        ),
      ),
      data: (reports) {
        // Build a deduplicated list of reported user entries
        final uniqueUserIds = <String>{};
        final userReports = <_UserEntry>[];

        for (final report in reports) {
          if (!uniqueUserIds.contains(report.reportedUserId)) {
            uniqueUserIds.add(report.reportedUserId);
            final pendingCount = reports
                .where((r) =>
                    r.reportedUserId == report.reportedUserId &&
                    r.status == 'pending')
                .length;
            userReports.add(_UserEntry(
              userId: report.reportedUserId,
              reporterName: report.reporterName,
              pendingReports: pendingCount,
              totalReports: reports
                  .where(
                      (r) => r.reportedUserId == report.reportedUserId)
                  .length,
            ));
          }
        }

        // Apply search filter
        var filteredUsers = userReports.where((entry) {
          if (searchQuery.isEmpty) return true;
          final query = searchQuery.toLowerCase();
          return entry.userId.toLowerCase().contains(query) ||
              (entry.reporterName?.toLowerCase().contains(query) ??
                  false);
        }).toList();

        // Apply status filter
        if (statusFilter == UserStatusFilter.active) {
          filteredUsers = filteredUsers
              .where((entry) => entry.pendingReports == 0)
              .toList();
        } else if (statusFilter == UserStatusFilter.banned) {
          filteredUsers = filteredUsers
              .where((entry) => entry.pendingReports > 0)
              .toList();
        }

        if (filteredUsers.isEmpty) {
          return Center(
            child: EmptyState(
              icon: Icons.people_outline,
              title: searchQuery.isNotEmpty
                  ? 'No users found matching "$searchQuery"'
                  : 'No users found',
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          itemCount: filteredUsers.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppSpacing.listItemGap),
          itemBuilder: (context, index) {
            final entry = filteredUsers[index];
            return _UserListTile(
              entry: entry,
              onTap: () => _showUserActionSheet(context, ref, entry),
            );
          },
        );
      },
    );
  }

  void _showUserActionSheet(
    BuildContext context,
    WidgetRef ref,
    _UserEntry entry,
  ) {
    // Create a minimal UserProfileModel for the action sheet
    final user = UserProfileModel(
      id: entry.userId,
      username: entry.userId,
      email: '${entry.userId}@platform.com',
      fullName: entry.reporterName ?? entry.userId,
      availability: const AvailabilityModel(),
      joinedAt: '',
      lastActive: '',
      stats: const UserStatsModel(),
    );

    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserActionSheet(
        user: user,
        isBanned: entry.pendingReports > 0,
      ),
    );
  }
}

// ── User Entry ────────────────────────────────────────────────────────────

class _UserEntry {
  const _UserEntry({
    required this.userId,
    this.reporterName,
    required this.pendingReports,
    required this.totalReports,
  });

  final String userId;
  final String? reporterName;
  final int pendingReports;
  final int totalReports;
}

// ── User List Tile ────────────────────────────────────────────────────────

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.entry,
    required this.onTap,
  });

  final _UserEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          // Avatar placeholder
          CircleAvatar(
            radius: 20,
            backgroundColor: context.colors.muted,
            child: Text(
              entry.userId.isNotEmpty
                  ? entry.userId[0].toUpperCase()
                  : '?',
              style: AppTextStyles.labelLarge.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.reporterName ?? entry.userId,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: context.colors.foreground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'ID: ${entry.userId}',
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Report count badge
          if (entry.pendingReports > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.colors.destructive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag,
                    size: 14,
                    color: context.colors.destructive,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${entry.pendingReports}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: context.colors.destructive,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                'Clear',
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.colors.success,
                ),
              ),
            ),

          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.chevron_right,
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}
