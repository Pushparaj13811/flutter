import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/skill_tag.dart';
import 'package:skill_exchange/data/models/session_model.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    this.onJoinMeeting,
    this.onComplete,
    this.onReschedule,
    this.onCancel,
  });

  final SessionModel session;
  final VoidCallback? onJoinMeeting;
  final VoidCallback? onComplete;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  // ── Status helpers ──────────────────────────────────────────────────────

  Color _statusColor(BuildContext context) {
    return switch (session.status) {
      SessionStatus.scheduled => context.colors.info,
      SessionStatus.completed => context.colors.success,
      SessionStatus.cancelled => context.colors.destructive,
    };
  }

  String _statusLabel() {
    return switch (session.status) {
      SessionStatus.scheduled => 'Scheduled',
      SessionStatus.completed => 'Completed',
      SessionStatus.cancelled => 'Cancelled',
    };
  }

  IconData _modeIcon() {
    return session.sessionMode == 'online'
        ? Icons.videocam_outlined
        : Icons.location_on_outlined;
  }

  String _modeLabel() {
    return session.sessionMode == 'online' ? 'Online' : 'In-person';
  }

  // ── Date formatting ─────────────────────────────────────────────────────

  String _formattedDate() {
    try {
      final date = DateTime.parse(session.scheduledAt);
      return DateFormat.yMMMd().add_jm().format(date);
    } catch (_) {
      return session.scheduledAt;
    }
  }

  // ── Participant display ─────────────────────────────────────────────────

  String _hostName() {
    return session.host?.fullName ?? session.hostId;
  }

  String _participantName() {
    return session.participant?.fullName ?? session.participantId;
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.md),
          _buildParticipants(context),
          const SizedBox(height: AppSpacing.md),
          _buildScheduleInfo(context),
          if (session.skillsToCover.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildSkillChips(),
          ],
          if (session.sessionMode == 'online' &&
              session.meetingLink != null &&
              session.meetingLink!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildMeetingLinkButton(),
          ],
          if (session.status == SessionStatus.scheduled) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildActions(),
          ],
        ],
      ),
    );
  }

  // ── Section builders ────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final statusColor = _statusColor(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            session.title,
            style: AppTextStyles.h4.copyWith(color: context.colors.foreground),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(
            _statusLabel(),
            style: AppTextStyles.labelSmall.copyWith(color: statusColor),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipants(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person_outline, size: 16, color: context.colors.mutedForeground),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'Host: ${_hostName()}  •  Participant: ${_participantName()}',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.mutedForeground,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfo(BuildContext context) {
    return Row(
      children: [
        // Date & time
        Icon(Icons.calendar_today, size: 14, color: context.colors.mutedForeground),
        const SizedBox(width: AppSpacing.xs),
        Text(
          _formattedDate(),
          style: AppTextStyles.caption.copyWith(
            color: context.colors.foreground,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        // Duration
        Icon(Icons.timer_outlined, size: 14, color: context.colors.mutedForeground),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${session.duration} min',
          style: AppTextStyles.caption.copyWith(
            color: context.colors.foreground,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        // Mode
        Icon(_modeIcon(), size: 14, color: context.colors.mutedForeground),
        const SizedBox(width: AppSpacing.xs),
        Text(
          _modeLabel(),
          style: AppTextStyles.caption.copyWith(
            color: context.colors.foreground,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChips() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: session.skillsToCover
          .map((skill) => SkillTag(name: skill, level: 'beginner'))
          .toList(),
    );
  }

  Widget _buildMeetingLinkButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton.outline(
        label: 'Join Meeting',
        onPressed: onJoinMeeting,
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (session.meetingLink != null && session.meetingLink!.isNotEmpty)
          AppButton.primary(
            label: 'Join',
            icon: Icons.videocam,
            onPressed: onJoinMeeting,
          ),
        AppButton.secondary(
          label: 'Complete',
          onPressed: onComplete,
        ),
        AppButton.outline(
          label: 'Reschedule',
          onPressed: onReschedule,
        ),
        AppButton.destructive(
          label: 'Cancel',
          onPressed: onCancel,
        ),
      ],
    );
  }
}
