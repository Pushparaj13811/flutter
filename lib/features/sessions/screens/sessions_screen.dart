import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/features/connections/providers/connections_provider.dart';
import 'package:skill_exchange/features/reviews/widgets/review_sheet.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';
import 'package:skill_exchange/features/sessions/widgets/reschedule_session_sheet.dart';
import 'package:skill_exchange/features/sessions/widgets/session_booking_sheet.dart';
import 'package:skill_exchange/features/sessions/widgets/session_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  // ── Actions ─────────────────────────────────────────────────────────────

  void _onNewBooking(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ConnectionPickerSheet(ref: ref),
    );
  }

  void _onJoinMeeting(BuildContext context, SessionModel session) {
    final link = session.meetingLink;
    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No meeting link available'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }

  void _onComplete(
    BuildContext context,
    WidgetRef ref,
    SessionModel session,
  ) {
    showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Complete Session'),
        content: Text(
          'Mark "${session.title}" as completed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Complete'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await ref
              .read(sessionsNotifierProvider.notifier)
              .completeSession(session.id);
          ref.invalidate(upcomingSessionsProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Session marked as completed'),
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Auto-prompt review
            final currentUid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';
            final otherUserId = session.hostId == currentUid
                ? session.participantId
                : session.hostId;
            final otherUserName = session.hostId == currentUid
                ? (session.participant?.fullName ?? session.participantId)
                : (session.host?.fullName ?? session.hostId);

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => ReviewSheet(
                toUserId: otherUserId,
                toUserName: otherUserName,
                sessionId: session.id,
                prePopulatedSkills: session.skillsToCover,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to complete session: $e'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: context.colors.destructive,
              ),
            );
          }
        }
      }
    });
  }

  void _onReschedule(BuildContext context, SessionModel session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => RescheduleSessionSheet(
        sessionId: session.id,
        currentScheduledAt: session.scheduledAt,
        currentDuration: session.duration,
      ),
    );
  }

  void _onCancel(
    BuildContext context,
    WidgetRef ref,
    SessionModel session,
  ) {
    showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cancel Session'),
        content: Text(
          'Are you sure you want to cancel "${session.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.destructive,
            ),
            child: const Text('Cancel Session'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await ref
              .read(sessionsNotifierProvider.notifier)
              .cancelSession(session.id);
          ref.invalidate(upcomingSessionsProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Session cancelled'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to cancel session: $e'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: context.colors.destructive,
              ),
            );
          }
        }
      }
    });
  }

  // ── Refresh ─────────────────────────────────────────────────────────────

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(upcomingSessionsProvider);
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(upcomingSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onNewBooking(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Booking'),
      ),
      body: sessionsAsync.when(
        loading: () => _buildLoadingSkeleton(),
        error: (error, _) => Center(
          child: ErrorMessage(
            message: error.toString(),
            onRetry: () => _refresh(ref),
          ),
        ),
        data: (sessions) {
          if (sessions.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView(
                children: const [
                  EmptyState(
                    icon: Icons.event_available,
                    title: 'No sessions yet',
                    description:
                        'Book a session with one of your connections to get started.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: sessions.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.listItemGap),
              itemBuilder: (context, index) {
                final session = sessions[index];
                return SessionCard(
                  session: session,
                  onJoinMeeting: () => _onJoinMeeting(context, session),
                  onComplete: () => _onComplete(context, ref, session),
                  onReschedule: () => _onReschedule(context, session),
                  onCancel: () => _onCancel(context, ref, session),
                  onLeaveReview: session.status == SessionStatus.completed && !session.isReviewed
                      ? () {
                          final currentUid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';
                          final otherUserId = session.hostId == currentUid
                              ? session.participantId
                              : session.hostId;
                          final otherUserName = session.hostId == currentUid
                              ? (session.participant?.fullName ?? session.participantId)
                              : (session.host?.fullName ?? session.hostId);

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (_) => ReviewSheet(
                              toUserId: otherUserId,
                              toUserName: otherUserName,
                              sessionId: session.id,
                              prePopulatedSkills: session.skillsToCover,
                            ),
                          );
                        }
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 4,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.session(),
    );
  }
}

// ── Connection Picker Sheet ──────────────────────────────────────────────────

class _ConnectionPickerSheet extends ConsumerWidget {
  const _ConnectionPickerSheet({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionsAsync = ref.watch(connectionsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Select a Connection',
            style: AppTextStyles.h4.copyWith(color: context.colors.foreground),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Choose who to book a session with',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          connectionsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Failed to load connections.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.destructive,
                ),
              ),
            ),
            data: (connections) {
              if (connections.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: EmptyState(
                    icon: Icons.people_outline,
                    title: 'No connections yet',
                    description: 'Connect with people first to book sessions.',
                  ),
                );
              }

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: connections.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final connection = connections[index];
                    final name = connection['otherUserName'] as String? ?? 'Unknown User';
                    final userId = connection['otherUserId'] as String? ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: context.colors.muted,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: context.colors.foreground,
                          ),
                        ),
                      ),
                      title: Text(name),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: context.colors.mutedForeground,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) => SessionBookingSheet(
                            participantId: userId,
                            participantName: name,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
