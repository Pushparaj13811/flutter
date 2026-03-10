// Password strength indicator
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/utils/validators.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.password});

  final String password;

  static const int _barCount = 4;

  Color _colorForScore(BuildContext context, int score) {
    return switch (score) {
      0 => context.colors.starEmpty, // grey (empty / no password)
      1 => context.colors.destructive,   // red   -- weak
      2 => context.colors.warning,       // orange -- fair
      3 => context.colors.info,          // blue   -- good
      _ => context.colors.success,       // green  -- strong
    };
  }

  @override
  Widget build(BuildContext context) {
    final score = Validators.passwordStrength(password);
    final label = Validators.passwordStrengthLabel(score);
    final activeColor = _colorForScore(context, score);
    final emptyColor = context.colors.starEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.sm),
        // Segmented strength meter
        Row(
          children: List.generate(_barCount, (index) {
            // A bar is filled when its index is below the score.
            // Score 0 -> no bars filled; score 4 -> all bars filled.
            final isFilled = password.isNotEmpty && index < score;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < _barCount - 1 ? AppSpacing.xs : 0,
                ),
                decoration: BoxDecoration(
                  color: isFilled ? activeColor : emptyColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Strength label -- right-aligned, colour matches active bars
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            password.isEmpty ? '' : label,
            style: AppTextStyles.labelSmall.copyWith(
              color: password.isEmpty ? Colors.transparent : activeColor,
            ),
          ),
        ),
      ],
    );
  }
}
