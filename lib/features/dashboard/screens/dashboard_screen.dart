import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/matching/providers/matching_provider.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/config/di/providers.dart';

// ── Feed Posts Provider ──────────────────────────────────────────────────────

final feedPostsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  return service.getPosts(limit: 10);
});

// ── Dashboard Screen ─────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          _NotificationBell(ref: ref),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedPostsProvider);
          ref.invalidate(upcomingSessionsProvider);
          ref.invalidate(topMatchesProvider(5));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            // Admin panel (compact)
            if (isAdmin) ...[
              _CompactAdminCard(
                onTap: () => context.go(RouteNames.adminDashboard),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Session reminder
            _SessionReminderSection(ref: ref),

            // Community feed
            _SectionHeader(title: 'Community Feed'),
            const SizedBox(height: AppSpacing.sm),
            _FeedSection(ref: ref),

            const SizedBox(height: AppSpacing.sectionGap),

            // Suggested users
            _SectionHeader(title: 'Suggested for You'),
            const SizedBox(height: AppSpacing.sm),
            _SuggestedUsersSection(ref: ref),

            const SizedBox(height: AppSpacing.sectionGap),

            // Quick navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: OutlinedButton.icon(
                onPressed: () => context.go(RouteNames.community),
                icon: const Icon(Icons.groups_outlined),
                label: const Text('Go to Community'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: OutlinedButton.icon(
                onPressed: () => context.go(RouteNames.bookings),
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('My Sessions'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Text(
        title,
        style: AppTextStyles.h4.copyWith(color: colors.foreground),
      ),
    );
  }
}

// ── Compact Admin Card ───────────────────────────────────────────────────────

class _CompactAdminCard extends StatelessWidget {
  const _CompactAdminCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.card,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: colors.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: colors.secondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Admin Panel',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Session Reminder ─────────────────────────────────────────────────────────

class _SessionReminderSection extends StatelessWidget {
  const _SessionReminderSection({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(upcomingSessionsProvider);

    return sessionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sessions) {
        // Find the next session within 24 hours
        final now = DateTime.now();
        final upcoming = sessions.where((s) {
          if (s.status != SessionStatus.scheduled) return false;
          final scheduled = DateTime.tryParse(s.scheduledAt);
          if (scheduled == null) return false;
          final diff = scheduled.difference(now);
          return diff.inHours < 24 && !diff.isNegative;
        }).toList();

        if (upcoming.isEmpty) return const SizedBox.shrink();

        final next = upcoming.first;
        return _SessionReminderCard(session: next);
      },
    );
  }
}

class _SessionReminderCard extends StatelessWidget {
  const _SessionReminderCard({required this.session});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scheduled = DateTime.tryParse(session.scheduledAt);
    final timeUntil = scheduled != null
        ? timeago.format(scheduled, allowFromNow: true)
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, size: 20, color: colors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  session.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            timeUntil,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (session.meetingLink != null &&
                  session.meetingLink!.isNotEmpty) ...[
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam, size: 16),
                  label: const Text('Join'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              TextButton(
                onPressed: () => context.go(RouteNames.bookings),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Feed Section ─────────────────────────────────────────────────────────────

class _FeedSection extends StatelessWidget {
  const _FeedSection({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(feedPostsProvider);

    return postsAsync.when(
      loading: () => Column(
        children: const [
          SkeletonCard.match(),
          SizedBox(height: AppSpacing.md),
          SkeletonCard.match(),
        ],
      ),
      error: (e, _) => ErrorMessage(
        message: 'Could not load feed.',
        onRetry: () => ref.invalidate(feedPostsProvider),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                'No posts yet. Be the first to share!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
            ),
          );
        }
        return Column(
          children: posts.map((post) => _PostCard(post: post, ref: ref)).toList(),
        );
      },
    );
  }
}

// ── Post Card ────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.ref});

  final Map<String, dynamic> post;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authorName = post['authorName'] as String? ?? 'Unknown';
    final authorAvatar = post['authorAvatar'] as String?;
    final title = post['title'] as String? ?? '';
    final content = post['content'] as String? ?? '';
    final likesCount = post['likesCount'] as int? ?? 0;
    final repliesCount = post['repliesCount'] as int? ?? 0;
    final createdAt = post['createdAt'];
    final timeAgoStr = _formatTimeAgo(createdAt);

    return GestureDetector(
      onTap: () => context.go(RouteNames.community),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: authorAvatar != null && authorAvatar.isNotEmpty
                      ? NetworkImage(authorAvatar)
                      : null,
                  backgroundColor: colors.muted,
                  child: authorAvatar == null || authorAvatar.isEmpty
                      ? Text(
                          authorName.isNotEmpty
                              ? authorName[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: colors.foreground,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.foreground,
                        ),
                      ),
                      if (timeAgoStr.isNotEmpty)
                        Text(
                          timeAgoStr,
                          style: AppTextStyles.caption.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.foreground,
                ),
              ),
            ],
            if (content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.foreground,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Actions row
            Row(
              children: [
                Icon(Icons.favorite_border, size: 18, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  '$likesCount',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, size: 18, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  '$repliesCount',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Suggested Users Section ──────────────────────────────────────────────────

class _SuggestedUsersSection extends StatelessWidget {
  const _SuggestedUsersSection({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(topMatchesProvider(5));

    return matchesAsync.when(
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (matches) {
        if (matches.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return _SuggestedUserCard(
                match: matches[index],
              );
            },
          ),
        );
      },
    );
  }
}

class _SuggestedUserCard extends StatelessWidget {
  const _SuggestedUserCard({required this.match});

  final MatchScoreModel match;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final profile = match.profile;
    final avatar = profile.avatar;
    final topSkill = profile.skillsToTeach.isNotEmpty
        ? profile.skillsToTeach.first.name
        : null;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: avatar != null && avatar.isNotEmpty
                ? NetworkImage(avatar)
                : null,
            backgroundColor: colors.muted,
            child: avatar == null || avatar.isEmpty
                ? Text(
                    profile.fullName.isNotEmpty
                        ? profile.fullName[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.h4.copyWith(color: colors.foreground),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            profile.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelMedium.copyWith(
              color: colors.foreground,
            ),
            textAlign: TextAlign.center,
          ),
          if (topSkill != null) ...[
            const SizedBox(height: 2),
            Text(
              topSkill,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () =>
                  context.push('${RouteNames.profile}/${match.userId}'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 4),
                textStyle: AppTextStyles.caption,
              ),
              child: const Text('Connect'),
            ),
          ),
        ],
      ),
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

  void _showNotificationsSheet(
      BuildContext context, NotificationFirestoreService service) {
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
                            color: isRead
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.primary,
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

// ── Time Ago Helper ──────────────────────────────────────────────────────────

String _formatTimeAgo(dynamic timestamp) {
  if (timestamp == null) return '';
  DateTime date;
  if (timestamp is String) {
    date = DateTime.tryParse(timestamp) ?? DateTime.now();
  } else {
    // Firestore Timestamp
    try {
      date = (timestamp as dynamic).toDate();
    } catch (_) {
      date = DateTime.now();
    }
  }
  return timeago.format(date);
}
