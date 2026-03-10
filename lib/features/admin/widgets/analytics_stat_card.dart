import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';

class AnalyticsStatCard extends StatelessWidget {
  const AnalyticsStatCard({
    super.key,
    required this.label,
    required this.value,
    this.changeValue,
    this.icon,
  });

  final String label;
  final String value;
  final String? changeValue;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive =
        changeValue != null && !changeValue!.startsWith('-');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: colors.mutedForeground),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: colors.foreground),
          ),
          if (changeValue != null) ...[
            const SizedBox(height: 2),
            Text(
              changeValue!,
              style: AppTextStyles.caption.copyWith(
                color: isPositive ? colors.success : colors.destructive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
