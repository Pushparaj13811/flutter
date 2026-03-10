import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/skill_tag.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/features/matching/widgets/compatibility_score.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
    this.onConnect,
    this.onBookSession,
  });

  final MatchScoreModel match;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;
  final VoidCallback? onBookSession;

  @override
  Widget build(BuildContext context) {
    final profile = match.profile;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar, name/location, score badge ──
          Row(
            children: [
              UserAvatar(
                imageUrl: profile.avatar,
                name: profile.fullName,
                size: 48,
                heroTag: 'avatar_${match.userId}',
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (profile.location != null &&
                        profile.location!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: context.colors.mutedForeground,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              profile.location!,
                              style: AppTextStyles.caption.copyWith(
                                color: context.colors.mutedForeground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              CompatibilityScore(score: match.compatibilityScore),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Matched skills: they teach ──
          if (match.matchedSkills.theyTeach.isNotEmpty) ...[
            Text(
              'They can teach you',
              style: AppTextStyles.caption.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: match.matchedSkills.theyTeach
                  .map((skill) => SkillTag(name: skill, level: 'intermediate'))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // ── Matched skills: you teach ──
          if (match.matchedSkills.youTeach.isNotEmpty) ...[
            Text(
              'You can teach them',
              style: AppTextStyles.caption.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: match.matchedSkills.youTeach
                  .map((skill) => SkillTag(name: skill, level: 'beginner'))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          const SizedBox(height: AppSpacing.sm),

          // ── Action buttons ──
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Connect',
                  onPressed: onConnect,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Book Session',
                  onPressed: onBookSession,
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
