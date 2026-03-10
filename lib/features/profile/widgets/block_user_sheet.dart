// Block user bottom sheet

import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';

class BlockUserSheet extends StatelessWidget {
  const BlockUserSheet({
    super.key,
    required this.userId,
    this.userName = 'this user',
  });

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Block icon
          Center(
            child: Icon(
              Icons.block,
              color: context.colors.destructive,
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            'Block $userName?',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          // Description
          Text(
            'Blocking $userName will prevent them from viewing your profile, '
            'sending you messages, or requesting sessions. '
            'They will not be notified that you blocked them.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton.destructive(
                  label: 'Block',
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
