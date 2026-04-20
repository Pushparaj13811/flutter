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

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
                // Welcome message
                Text(
                  'Welcome back, $firstName!',
                  style: AppTextStyles.h2,
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
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionChip(
                icon: Icons.school_outlined,
                label: 'Browse Skills',
                onTap: onBrowseSkills,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionChip(
                icon: Icons.groups_outlined,
                label: 'Community',
                onTap: onCommunity,
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
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer,
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
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: theme.colorScheme.primary,
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
