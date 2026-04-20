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
            onPressed: () => ref.invalidate(allUsersProvider),
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
    final usersAsync = ref.watch(allUsersProvider);

    return usersAsync.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: 5,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.listItemGap),
        itemBuilder: (_, __) => const SkeletonCard.profile(),
      ),
      error: (e, _) => Center(
        child: ErrorMessage(
          message: 'Could not load users.',
          onRetry: () => ref.invalidate(allUsersProvider),
        ),
      ),
      data: (users) {
        // Apply search filter
        var filteredUsers = users.where((user) {
          if (searchQuery.isEmpty) return true;
          final query = searchQuery.toLowerCase();
          final name = (user['name'] as String? ?? '').toLowerCase();
          final email = (user['email'] as String? ?? '').toLowerCase();
          final id = (user['id'] as String? ?? '').toLowerCase();
          return name.contains(query) || email.contains(query) || id.contains(query);
        }).toList();

        // Apply status filter
        if (statusFilter == UserStatusFilter.active) {
          filteredUsers = filteredUsers
              .where((user) => user['isActive'] == true)
              .toList();
        } else if (statusFilter == UserStatusFilter.banned) {
          filteredUsers = filteredUsers
              .where((user) => user['isActive'] == false)
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

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(allUsersProvider),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            itemCount: filteredUsers.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.listItemGap),
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return _UserListTile(
                user: user,
                onTap: () => _showUserActionSheet(context, ref, user),
              );
            },
          ),
        );
      },
    );
  }

  void _showUserActionSheet(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> userData,
  ) {
    final isBanned = userData['isActive'] == false;
    final user = UserProfileModel(
      id: userData['id'] as String? ?? '',
      username: (userData['email'] as String? ?? '').split('@').first,
      email: userData['email'] as String? ?? '',
      fullName: userData['name'] as String? ?? '',
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
        isBanned: isBanned,
      ),
    );
  }
}

// ── User List Tile ────────────────────────────────────────────────────────

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.user,
    required this.onTap,
  });

  final Map<String, dynamic> user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = user['name'] as String? ?? '';
    final email = user['email'] as String? ?? '';
    final role = user['role'] as String? ?? 'user';
    final isActive = user['isActive'] as bool? ?? true;

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
              name.isNotEmpty ? name[0].toUpperCase() : '?',
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: context.colors.foreground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (role == 'admin') ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Text(
                          'Admin',
                          style: AppTextStyles.caption.copyWith(
                            color: context.colors.primary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  email,
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Status badge
          if (!isActive)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.colors.destructive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                'Banned',
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.colors.destructive,
                ),
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
                'Active',
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
