import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/features/sessions/widgets/session_card.dart';

class UpcomingSessions extends StatelessWidget {
  const UpcomingSessions({
    super.key,
    required this.sessions,
    this.onJoinMeeting,
    this.onComplete,
    this.onReschedule,
    this.onCancel,
  });

  final List<SessionModel> sessions;
  final ValueChanged<SessionModel>? onJoinMeeting;
  final ValueChanged<SessionModel>? onComplete;
  final ValueChanged<SessionModel>? onReschedule;
  final ValueChanged<SessionModel>? onCancel;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: EmptyState(
          icon: Icons.event_available,
          title: 'No upcoming sessions',
          description:
              'Book a session with one of your connections to get started.',
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < sessions.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.listItemGap),
          SessionCard(
            session: sessions[i],
            onJoinMeeting: onJoinMeeting != null
                ? () => onJoinMeeting!(sessions[i])
                : null,
            onComplete: onComplete != null
                ? () => onComplete!(sessions[i])
                : null,
            onReschedule: onReschedule != null
                ? () => onReschedule!(sessions[i])
                : null,
            onCancel:
                onCancel != null ? () => onCancel!(sessions[i]) : null,
          ),
        ],
      ],
    );
  }
}
