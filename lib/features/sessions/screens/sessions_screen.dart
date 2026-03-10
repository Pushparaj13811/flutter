import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';
import 'package:skill_exchange/features/sessions/widgets/reschedule_session_sheet.dart';
import 'package:skill_exchange/features/sessions/widgets/session_card.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  // ── Actions ─────────────────────────────────────────────────────────────

  void _onNewBooking(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Select a connection first'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onJoinMeeting(BuildContext context, SessionModel session) {
    final link = session.meetingLink;
    if (link != null && link.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening meeting link: $link'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onComplete(
    BuildContext context,
    WidgetRef ref,
    SessionModel session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Complete Session'),
        content: Text(
          'Mark "${session.title}" as completed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(sessionsNotifierProvider.notifier)
            .completeSession(session.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session marked as completed'),
              behavior: SnackBarBehavior.floating,
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

  Future<void> _onCancel(
    BuildContext context,
    WidgetRef ref,
    SessionModel session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Session'),
        content: Text(
          'Are you sure you want to cancel "${session.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.destructive,
            ),
            child: const Text('Cancel Session'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(sessionsNotifierProvider.notifier)
            .cancelSession(session.id);

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
        onPressed: () => _onNewBooking(context),
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
