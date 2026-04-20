import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/skill_tag.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.user,
    this.onTap,
    this.onConnect,
    this.connectLabel = 'Connect',
  });

  final UserProfileModel user;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;
  final String connectLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Header: avatar, name, location, rating badge --
          Row(
            children: [
              UserAvatar(
                imageUrl: user.avatar,
                name: user.fullName,
                size: 48,
                heroTag: 'avatar_${user.id}',
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.location != null &&
                        user.location!.isNotEmpty) ...[
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
                              user.location!,
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
              _RatingBadge(rating: user.stats.averageRating),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // -- Skills to teach --
          if (user.skillsToTeach.isNotEmpty) ...[
            Text(
              'Can teach',
              style: AppTextStyles.caption.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: user.skillsToTeach
                  .take(4)
                  .map(
                    (skill) => SkillTag(
                      name: skill.name,
                      level: skill.level.value,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // -- Skills to learn --
          if (user.skillsToLearn.isNotEmpty) ...[
            Text(
              'Wants to learn',
              style: AppTextStyles.caption.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: user.skillsToLearn
                  .take(4)
                  .map(
                    (skill) => SkillTag(
                      name: skill.name,
                      level: skill.level.value,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // -- Stats row --
          Row(
            children: [
              _StatChip(
                icon: Icons.people_outline,
                label: '${user.stats.connectionsCount}',
              ),
              const SizedBox(width: AppSpacing.md),
              _StatChip(
                icon: Icons.school_outlined,
                label: '${user.stats.sessionsCompleted} sessions',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // -- Connect button --
          SizedBox(
            width: double.infinity,
            child: AppButton.outline(
              label: connectLabel,
              onPressed: onConnect,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rating Badge ─────────────────────────────────────────────────────────

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    if (rating <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.starFilled.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 16,
            color: context.colors.starFilled,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.labelMedium.copyWith(
              color: context.colors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Chip ────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.colors.mutedForeground),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: context.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
