import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
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
import 'package:skill_exchange/features/profile/providers/profile_provider.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/features/community/widgets/discussion_card.dart';
import 'package:skill_exchange/features/community/screens/post_detail_screen.dart';

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
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: 'Sessions',
            onPressed: () => context.push(RouteNames.bookings),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Messages',
            onPressed: () => context.push(RouteNames.messages),
          ),
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
            // Email verification banner
            if (authState is AuthAuthenticated && !authState.user.isVerified) ...[
              _EmailVerificationBanner(
                onResend: () async {
                  await ref.read(firebaseAuthServiceProvider).sendEmailVerification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification email sent! Check your inbox.')),
                    );
                  }
                },
                onRefresh: () async {
                  await fb.FirebaseAuth.instance.currentUser?.reload();
                  final isNowVerified = fb.FirebaseAuth.instance.currentUser?.emailVerified ?? false;
                  if (isNowVerified && context.mounted) {
                    await FirebaseFirestore.instance.collection('users').doc(fb.FirebaseAuth.instance.currentUser!.uid).update({'isVerified': true});
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email verified!')),
                      );
                    }
                    ref.invalidate(currentProfileProvider);
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email not yet verified. Please check your inbox.')),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Admin panel (compact)
            if (isAdmin) ...[
              _CompactAdminCard(
                onTap: () => context.push(RouteNames.adminDashboard),
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
                onPressed: () => context.push(RouteNames.bookings),
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
  const _SectionHeader({required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(color: colors.foreground),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View All',
                style: AppTextStyles.labelMedium.copyWith(color: colors.primary),
              ),
            ),
        ],
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
      padding: const EdgeInsets.all(AppSpacing.md),
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
                onPressed: () => context.push(RouteNames.bookings),
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
          children: posts.map((post) {
            final likedBy = (post['likedBy'] as List?)?.cast<String>() ?? [];
            final currentUid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';
            final hasLiked = likedBy.contains(currentUid);
            final enrichedPost = {
              ...post,
              'isLikedByMe': hasLiked,
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: DiscussionCard(
                post: enrichedPost,
                isCompact: true,
                onLike: () async {
                  final postId = post['id'] as String?;
                  if (postId == null) return;
                  final service = ref.read(communityFirestoreServiceProvider);
                  await service.likePost(postId);
                  ref.invalidate(feedPostsProvider);
                },
                onDelete: () async {
                  final postId = post['id'] as String?;
                  if (postId == null) return;
                  final service = ref.read(communityFirestoreServiceProvider);
                  await service.deletePost(postId);
                  ref.invalidate(feedPostsProvider);
                },
                onReport: () {
                  final postId = post['id'] as String?;
                  if (postId == null) return;
                  _reportPost(context, postId);
                },
                onComment: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: enrichedPost),
                    ),
                  );
                },
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: enrichedPost),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
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
          height: 170,
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
      width: 120,
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
            radius: 24,
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

// ── Email Verification Banner ────────────────────────────────────────────────

class _EmailVerificationBanner extends StatelessWidget {
  const _EmailVerificationBanner({required this.onResend, required this.onRefresh});
  final VoidCallback onResend;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.highlight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.highlight.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.email_outlined, color: colors.highlight, size: 20),
              const SizedBox(width: 8),
              Text('Verify your email', style: AppTextStyles.labelLarge.copyWith(color: colors.foreground)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Check your inbox for a verification link. Verify to unlock all features.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(onPressed: onResend, child: const Text('Resend Email')),
              const SizedBox(width: 8),
              TextButton(onPressed: onRefresh, child: const Text('I\'ve Verified')),
            ],
          ),
        ],
      ),
    );
  }
}

void _reportPost(BuildContext context, String postId) {
  showDialog(
    context: context,
    builder: (ctx) {
      String reason = '';
      return AlertDialog(
        title: const Text('Report Post'),
        content: TextField(
          onChanged: (v) => reason = v,
          decoration: const InputDecoration(hintText: 'Why are you reporting this post?'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('reports').add({
                'reporter': fb.FirebaseAuth.instance.currentUser!.uid,
                'reportedPost': postId,
                'reason': 'inappropriate_content',
                'description': reason,
                'status': 'pending',
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post reported. Thank you.')),
                );
              }
            },
            child: const Text('Report'),
          ),
        ],
      );
    },
  );
}

