import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class LearningCircleCard extends StatelessWidget {
  final Map<String, dynamic> circle;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  const LearningCircleCard({
    super.key,
    required this.circle,
    this.onJoin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = circle['name'] as String? ?? '';
    final description = circle['description'] as String? ?? '';
    final skillFocus = (circle['skillFocus'] as List?)?.cast<String>() ?? [];
    final membersCount = (circle['membersCount'] as num?)?.toInt() ?? 0;
    final maxMembers = (circle['maxMembers'] as num?)?.toInt() ?? 50;
    final isJoinedByMe = circle['isJoinedByMe'] as bool? ?? false;
    final isFull = membersCount >= maxMembers;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.colors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    Icons.groups_outlined,
                    color: context.colors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.h4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.mutedForeground,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (skillFocus.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildSkillFocusTags(context, skillFocus),
            ],
            const SizedBox(height: AppSpacing.md),
            _buildFooter(context, membersCount, maxMembers, isJoinedByMe, isFull),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillFocusTags(BuildContext context, List<String> skillFocus) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: skillFocus.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: context.colors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(
            skill,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.secondary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context, int membersCount, int maxMembers, bool isJoinedByMe, bool isFull) {
    return Row(
      children: [
        Icon(
          Icons.people_outline,
          size: 16,
          color: context.colors.mutedForeground,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$membersCount/$maxMembers members',
          style: AppTextStyles.caption.copyWith(
            color: context.colors.mutedForeground,
          ),
        ),
        const Spacer(),
        if (isJoinedByMe)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Text(
              'Joined',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.success,
              ),
            ),
          )
        else
          FilledButton.tonal(
            onPressed: isFull ? null : onJoin,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(isFull ? 'Full' : 'Join'),
          ),
      ],
    );
  }
}
