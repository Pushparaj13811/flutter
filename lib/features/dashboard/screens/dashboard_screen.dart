import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/dashboard/widgets/stats_grid.dart';
import 'package:skill_exchange/features/matching/providers/matching_provider.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';
import 'package:skill_exchange/features/dashboard/widgets/top_matches_section.dart';
import 'package:skill_exchange/features/dashboard/widgets/upcoming_sessions_section.dart';
import 'package:skill_exchange/features/profile/providers/profile_provider.dart';
import 'package:skill_exchange/config/di/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          _NotificationBell(ref: ref),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentProfileProvider);
          ref.invalidate(topMatchesProvider(5));
          ref.invalidate(upcomingSessionsProvider);
        },
        child: profileAsync.when(
          loading: () => _buildLoading(),
          error: (e, _) => Center(
            child: ErrorMessage(
              message: e.toString(),
              onRetry: () => ref.invalidate(currentProfileProvider),
            ),
          ),
          data: (profile) {
            final firstName = profile.fullName.split(' ').first;
            final authState = ref.watch(authProvider);
            final isAdmin =
                authState is AuthAuthenticated && authState.user.isAdmin;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                // Welcome message with avatar
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: profile.avatar != null && profile.avatar!.isNotEmpty
                          ? NetworkImage(profile.avatar!)
                          : null,
                      backgroundColor: context.colors.muted,
                      child: profile.avatar == null || profile.avatar!.isEmpty
                          ? Text(
                              firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                              style: AppTextStyles.h3.copyWith(
                                color: context.colors.foreground,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Welcome back, $firstName!',
                        style: AppTextStyles.h2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // Admin panel card
                if (isAdmin) ...[
                  _AdminPanelCard(
                    onDashboard: () =>
                        context.go(RouteNames.adminDashboard),
                    onUsers: () => context.go(RouteNames.adminUsers),
                    onModeration: () =>
                        context.go(RouteNames.adminModeration),
                    onCommunity: () =>
                        context.go(RouteNames.adminCommunity),
                    onAnalytics: () =>
                        context.go(RouteNames.adminAnalytics),
                    onSkills: () =>
                        context.go(RouteNames.adminSkills),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                ],

                // Stats grid
                StatsGrid(stats: profile.stats),
                const SizedBox(height: AppSpacing.sectionGap),

                // Top matches
                _TopMatchesConsumer(ref: ref),
                const SizedBox(height: AppSpacing.sectionGap),

                // Upcoming sessions
                _UpcomingSessionsConsumer(ref: ref),
                const SizedBox(height: AppSpacing.sectionGap),

                // Quick actions
                _QuickActions(
                  onFindMatches: () => context.go(RouteNames.matching),
                  onBrowseSkills: () => context.go(RouteNames.search),
                  onCommunity: () => context.go(RouteNames.community),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: const [
        SkeletonCard.profile(),
        SizedBox(height: AppSpacing.md),
        SkeletonCard.match(),
        SizedBox(height: AppSpacing.md),
        SkeletonCard.session(),
      ],
    );
  }
}

// ── Notification bell with unread badge ──────────────────────────────────────

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(notificationFirestoreServiceProvider);

    return StreamBuilder(
      stream: service.notificationsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () {},
          );
        }

        int unreadCount = 0;
        if (snapshot.hasData) {
          unreadCount = snapshot.data!.docs
              .where((doc) => doc.data()['isRead'] == false)
              .length;
        }

        return IconButton(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(
              unreadCount > 9 ? '9+' : '$unreadCount',
              style: const TextStyle(fontSize: 10),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
          tooltip: 'Notifications',
          onPressed: () => _showNotificationsSheet(context, service),
        );
      },
    );
  }

  void _showNotificationsSheet(BuildContext context, NotificationFirestoreService service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications', style: AppTextStyles.h4),
                    TextButton(
                      onPressed: () => service.markAllAsRead(),
                      child: const Text('Mark all read'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: StreamBuilder(
                  stream: service.notificationsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: Text('No notifications yet'),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        final isRead = data['isRead'] ?? false;
                        return ListTile(
                          leading: Icon(
                            Icons.circle,
                            size: 10,
                            color: isRead ? Colors.transparent : Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(data['title'] ?? 'Notification'),
                          subtitle: Text(data['body'] ?? ''),
                          dense: true,
                          onTap: () {
                            service.markAsRead(docs[index].id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Top matches section with its own async state ─────────────────────────────

class _TopMatchesConsumer extends StatelessWidget {
  const _TopMatchesConsumer({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(topMatchesProvider(5));

    return matchesAsync.when(
      loading: () => const SkeletonCard.match(),
      error: (e, _) => ErrorMessage(
        message: 'Could not load matches.',
        onRetry: () => ref.invalidate(topMatchesProvider(5)),
      ),
      data: (matches) => TopMatchesSection(
        matches: matches,
        onViewAll: () => context.go(RouteNames.matching),
        onMatchTap: (userId) => context.push('${RouteNames.profile}/$userId'),
      ),
    );
  }
}

// ── Upcoming sessions section with its own async state ───────────────────────

class _UpcomingSessionsConsumer extends StatelessWidget {
  const _UpcomingSessionsConsumer({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(upcomingSessionsProvider);

    return sessionsAsync.when(
      loading: () => const SkeletonCard.session(),
      error: (e, _) => ErrorMessage(
        message: 'Could not load sessions.',
        onRetry: () => ref.invalidate(upcomingSessionsProvider),
      ),
      data: (sessions) => UpcomingSessionsSection(
        sessions: sessions,
        onViewAll: () => context.go(RouteNames.bookings),
        onSessionTap: (sessionId) => context.go(RouteNames.bookings),
      ),
    );
  }
}

// ── Quick action buttons ─────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onFindMatches,
    required this.onBrowseSkills,
    required this.onCommunity,
  });

  final VoidCallback onFindMatches;
  final VoidCallback onBrowseSkills;
  final VoidCallback onCommunity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.h4),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _ActionChip(
                icon: Icons.search,
                label: 'Find Matches',
                onTap: onFindMatches,
                iconColor: const Color(0xFF10B981),
                iconBackgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionChip(
                icon: Icons.school_outlined,
                label: 'Browse Skills',
                onTap: onBrowseSkills,
                iconColor: const Color(0xFF6366F1),
                iconBackgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionChip(
                icon: Icons.groups_outlined,
                label: 'Community',
                onTap: onCommunity,
                iconColor: const Color(0xFFF59E0B),
                iconBackgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Admin panel card ──────────────────────────────────────────────────────────

class _AdminPanelCard extends StatelessWidget {
  const _AdminPanelCard({
    required this.onDashboard,
    required this.onUsers,
    required this.onModeration,
    required this.onCommunity,
    required this.onAnalytics,
    required this.onSkills,
  });

  final VoidCallback onDashboard;
  final VoidCallback onUsers;
  final VoidCallback onModeration;
  final VoidCallback onCommunity;
  final VoidCallback onAnalytics;
  final VoidCallback onSkills;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.secondary.withValues(alpha: 0.1),
            colors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: colors.secondary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Admin Panel',
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _AdminAction(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  onTap: onDashboard,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _AdminAction(
                  icon: Icons.people_outline,
                  label: 'Users',
                  onTap: onUsers,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _AdminAction(
                  icon: Icons.shield_outlined,
                  label: 'Moderation',
                  onTap: onModeration,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _AdminAction(
                  icon: Icons.groups_outlined,
                  label: 'Community',
                  onTap: onCommunity,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _AdminAction(
                  icon: Icons.bar_chart,
                  label: 'Analytics',
                  onTap: onAnalytics,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _AdminAction(
                  icon: Icons.category_outlined,
                  label: 'Skills',
                  onTap: onSkills,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminAction extends StatelessWidget {
  const _AdminAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.card,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: colors.secondary),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: colors.foreground,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveIconColor = iconColor ?? colors.primary;
    final effectiveBgColor =
        iconBackgroundColor ?? colors.primary.withValues(alpha: 0.1);

    return Material(
      color: colors.card,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: effectiveBgColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: effectiveIconColor),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.foreground,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
