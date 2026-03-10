// Notification preferences toggles

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/settings/providers/settings_provider.dart';

class NotificationSettings extends ConsumerWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsNotifierProvider);

    return asyncSettings.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (settings) => _buildContent(context, ref, settings),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
  ) {
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            'Notification Preferences',
            style: AppTextStyles.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive push notifications on your device'),
          value: settings.pushNotifications,
          activeThumbColor: context.colors.primary,
          onChanged: (value) => notifier.updatePushNotifications(value),
        ),
        SwitchListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Receive updates via email'),
          value: settings.emailNotifications,
          activeThumbColor: context.colors.primary,
          onChanged: (value) => notifier.updateEmailNotifications(value),
        ),
        SwitchListTile(
          title: const Text('Session Reminders'),
          subtitle: const Text('Get reminded before scheduled sessions'),
          value: settings.sessionReminders,
          activeThumbColor: context.colors.primary,
          onChanged: (value) => notifier.updateSessionReminders(value),
        ),
      ],
    );
  }
}
