import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntryModel entry;
  final VoidCallback? onTap;

  const LeaderboardTile({
    super.key,
    required this.entry,
    this.onTap,
  });

  bool get _isTopThree => entry.rank >= 1 && entry.rank <= 3;

  Color _rankColor(BuildContext context) {
    return switch (entry.rank) {
      1 => const Color(0xFFFFD700), // Gold
      2 => const Color(0xFFC0C0C0), // Silver
      3 => const Color(0xFFCD7F32), // Bronze
      _ => context.colors.mutedForeground,
    };
  }

  IconData? get _rankIcon {
    return switch (entry.rank) {
      1 => Icons.emoji_events,
      2 => Icons.emoji_events,
      3 => Icons.emoji_events,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = _rankColor(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: _isTopThree
              ? rankColor.withValues(alpha: 0.05)
              : context.colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: _isTopThree
                ? rankColor.withValues(alpha: 0.3)
                : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            _buildRankBadge(context, rankColor),
            const SizedBox(width: AppSpacing.md),
            _buildAvatar(context, rankColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildInfo(context)),
            _buildPoints(context, rankColor),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(BuildContext context, Color rankColor) {
    if (_rankIcon != null) {
      return SizedBox(
        width: 32,
        child: Icon(
          _rankIcon,
          color: rankColor,
          size: 28,
        ),
      );
    }

    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          '#${entry.rank}',
          style: AppTextStyles.labelLarge.copyWith(
            color: context.colors.mutedForeground,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, Color rankColor) {
    final userName = entry.user?.fullName ?? 'User';
    final avatarUrl = entry.user?.avatar;

    return CircleAvatar(
      radius: _isTopThree ? 22 : 18,
      backgroundColor: _isTopThree
          ? rankColor.withValues(alpha: 0.2)
          : context.colors.muted,
      backgroundImage:
          avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null
          ? Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : '?',
              style: AppTextStyles.labelLarge.copyWith(
                color: _isTopThree ? rankColor : context.colors.mutedForeground,
                fontSize: _isTopThree ? 16 : 14,
              ),
            )
          : null,
    );
  }

  Widget _buildInfo(BuildContext context) {
    final userName = entry.user?.fullName ?? 'User';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userName,
          style: _isTopThree
              ? AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.labelLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            _buildStatChip(
              context,
              Icons.school_outlined,
              '${entry.sessionsCompleted} sessions',
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip(
              context,
              Icons.star_outline,
              entry.averageRating.toStringAsFixed(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: context.colors.mutedForeground),
        const SizedBox(width: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: context.colors.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildPoints(BuildContext context, Color rankColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _isTopThree
            ? rankColor.withValues(alpha: 0.15)
            : context.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        '${entry.points} pts',
        style: AppTextStyles.labelMedium.copyWith(
          color: _isTopThree ? rankColor : context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
