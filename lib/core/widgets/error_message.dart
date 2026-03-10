import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessage({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Icon(Icons.error_outline, size: 48, color: colors.destructive),
          ),
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            label: 'Error: $message',
            child: Text(
              message,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: colors.destructive),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
