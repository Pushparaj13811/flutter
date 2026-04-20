import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: context.colors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Check Your Email',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'If an account exists with that email, we\'ve sent a password reset link. Follow the link to set your new password.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton.primary(
                label: 'Back to Login',
                onPressed: () => context.go('/'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/forgot-password'),
                child: Text(
                  'Didn\'t receive it? Try again',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
