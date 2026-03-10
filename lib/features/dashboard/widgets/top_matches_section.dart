import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';

class TopMatchesSection extends StatelessWidget {
  const TopMatchesSection({
    super.key,
    required this.matches,
    this.onViewAll,
    this.onMatchTap,
  });

  final List<MatchScoreModel> matches;
  final VoidCallback? onViewAll;
  final ValueChanged<String>? onMatchTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: AppSpacing.sm),
        if (matches.isEmpty) _buildEmptyState() else _buildMatchesList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Top Matches',
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
        child: Text(
          'No matches found yet. Complete your profile to get better matches!',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMatchesList() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: matches.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final match = matches[index];
          return _MatchMiniCard(
            match: match,
            onTap: onMatchTap != null
                ? () => onMatchTap!(match.userId)
                : null,
          );
        },
      ),
    );
  }
}

class _MatchMiniCard extends StatelessWidget {
  const _MatchMiniCard({
    required this.match,
    this.onTap,
  });

  final MatchScoreModel match;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final profile = match.profile;
    final scorePercent =
        '${(match.compatibilityScore * 100).round()}%';

    return SizedBox(
      width: 140,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserAvatar(
              imageUrl: profile.avatar,
              name: profile.fullName,
              size: 48,
              heroTag: 'avatar_${match.userId}',
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              profile.fullName,
              style: AppTextStyles.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              scorePercent,
              style: AppTextStyles.labelLarge.copyWith(
                color: _scoreColor(context, match.compatibilityScore),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _scoreColor(BuildContext context, double score) {
    if (score >= 0.8) return context.colors.scoreExcellent;
    if (score >= 0.6) return context.colors.scoreGreat;
    if (score >= 0.4) return context.colors.scoreGood;
    return context.colors.scoreFair;
  }
}
