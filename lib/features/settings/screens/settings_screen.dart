// Settings screen with sections

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/settings/providers/settings_provider.dart';
import 'package:skill_exchange/features/settings/widgets/account_settings.dart';
import 'package:skill_exchange/features/settings/widgets/notification_settings.dart';
import 'package:skill_exchange/features/settings/widgets/privacy_settings.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: asyncSettings.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: const [
            SkeletonCard(height: 80),
            SizedBox(height: AppSpacing.md),
            SkeletonCard(height: 80),
            SizedBox(height: AppSpacing.md),
            SkeletonCard(height: 80),
          ],
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load settings',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: context.colors.destructive,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () =>
                    ref.read(settingsNotifierProvider.notifier).loadSettings(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (_) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              const NotificationSettings(),
              const Divider(height: AppSpacing.xl),
              const PrivacySettings(),
              const Divider(height: AppSpacing.xl),
              const AccountSettings(),
              const SizedBox(height: AppSpacing.xxl),
              _buildAppVersion(context),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    return Text(
      'Skill Exchange v1.0.0',
      style: AppTextStyles.caption.copyWith(
        color: context.colors.mutedForeground,
      ),
      textAlign: TextAlign.center,
    );
  }
}
