import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class CompatibilityScore extends StatelessWidget {
  const CompatibilityScore({super.key, required this.score});

  final double score;

  Color _color(BuildContext context) {
    if (score >= 80) return context.colors.scoreExcellent;
    if (score >= 60) return context.colors.scoreGreat;
    if (score >= 40) return context.colors.scoreGood;
    return context.colors.scoreFair;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '${score.round()}',
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
