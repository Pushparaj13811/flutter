import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            ExcludeSemantics(
              child: Icon(icon, size: 48, color: colors.mutedForeground),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.h3),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              description!,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: colors.mutedForeground),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
