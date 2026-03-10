import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/data/models/analytics_model.dart';

class SkillPopularityBar extends StatelessWidget {
  const SkillPopularityBar({
    super.key,
    required this.skill,
    required this.maxCount,
  });

  final SkillPopularity skill;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = skill.teachCount + skill.learnCount;
    final fraction = maxCount > 0 ? total / maxCount : 0.0;
    final teachFraction = total > 0 ? skill.teachCount / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              skill.name,
              style: AppTextStyles.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth * fraction;
                return Stack(
                  children: [
                    Container(
                      height: 20,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: colors.muted,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: barWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            colors.primary,
                            colors.secondary,
                            colors.secondary,
                          ],
                          stops: [
                            0,
                            teachFraction,
                            teachFraction,
                            1,
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 36,
            child: Text(
              '$total',
              style: AppTextStyles.caption.copyWith(
                color: colors.mutedForeground,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
