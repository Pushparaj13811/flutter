import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';

class BannedScreen extends StatelessWidget {
  const BannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: context.colors.destructive.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        size: 40,
                        color: context.colors.destructive,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Account Suspended',
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your account has been suspended by a platform administrator. You no longer have access to Skill Exchange.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Reason block
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: context.colors.destructive.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.colors.destructive.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  size: 16, color: context.colors.destructive),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Why did this happen?',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: context.colors.destructive,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Accounts are suspended for violations of our community guidelines, including spam, harassment, fraudulent activity, or repeated policy violations.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      'If you believe this is a mistake, you can appeal by contacting our support team.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton.primary(
                      label: 'Contact Support',
                      icon: Icons.email_outlined,
                      onPressed: () {
                        launchUrl(Uri.parse('mailto:support@skillexchange.com'));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
