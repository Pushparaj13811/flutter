import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';

class SkillTag extends StatelessWidget {
  const SkillTag({
    super.key,
    required this.name,
    required this.level,
  });

  final String name;
  final String level;

  Color _backgroundColor(AppColorsExtension colors) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return colors.beginnerBg;
      case 'intermediate':
        return colors.intermediateBg;
      case 'advanced':
        return colors.advancedBg;
      case 'expert':
        return colors.expertBg;
      default:
        return colors.muted;
    }
  }

  Color _textColor(AppColorsExtension colors) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return colors.beginnerText;
      case 'intermediate':
        return colors.intermediateText;
      case 'advanced':
        return colors.advancedText;
      case 'expert':
        return colors.expertText;
      default:
        return colors.mutedForeground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: '$name, $level',
      excludeSemantics: true,
      child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(colors),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        name,
        style: AppTextStyles.labelMedium.copyWith(color: _textColor(colors)),
      ),
      ),
    );
  }
}
