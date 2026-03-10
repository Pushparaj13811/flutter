import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/session_model.dart';

class UpcomingSessionsSection extends StatelessWidget {
  const UpcomingSessionsSection({
    super.key,
    required this.sessions,
    this.onViewAll,
    this.onSessionTap,
  });

  final List<SessionModel> sessions;
  final VoidCallback? onViewAll;
  final ValueChanged<String>? onSessionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: AppSpacing.sm),
        if (sessions.isEmpty) _buildEmptyState() else _buildSessionsList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Upcoming Sessions',
          style: AppTextStyles.h4,
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'View All',
            style: AppTextStyles.labelMedium.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No upcoming sessions.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Book a session with one of your connections!',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsList() {
    final displaySessions = sessions.take(3).toList();
    return Column(
      children: [
        for (int i = 0; i < displaySessions.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.listItemGap),
          _SessionCard(
            session: displaySessions[i],
            onTap: onSessionTap != null
                ? () => onSessionTap!(displaySessions[i].id)
                : null,
          ),
        ],
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    this.onTap,
  });

  final SessionModel session;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isOnline = session.sessionMode == 'online';

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.videocam : Icons.location_on,
            color: isOnline ? context.colors.primary : context.colors.secondary,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: context.colors.mutedForeground
                          .withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _formatScheduledAt(session.scheduledAt),
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      '${session.duration} min',
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }

  String _formatScheduledAt(String scheduledAt) {
    final dateTime = DateTime.tryParse(scheduledAt);
    if (dateTime == null) return scheduledAt;

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$month $day, $displayHour:$minute $period';
  }
}
