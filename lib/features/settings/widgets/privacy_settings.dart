// Privacy settings controls

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/settings/providers/settings_provider.dart';

class PrivacySettings extends ConsumerWidget {
  const PrivacySettings({super.key});

  static const _visibilityOptions = [
    ('public', 'Public', 'Anyone can view your profile'),
    ('connections', 'Connections', 'Only your connections can view'),
    ('private', 'Private', 'No one can view your profile'),
  ];

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
            'Privacy',
            style: AppTextStyles.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Profile Visibility',
              border: OutlineInputBorder(),
            ),
            initialValue: settings.profileVisibility,
            items: _visibilityOptions
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option.$1,
                    child: Text(option.$2),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                notifier.updateProfileVisibility(value);
              }
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile(
          title: const Text('Show Email'),
          subtitle: const Text('Display your email on your profile'),
          value: settings.showEmail,
          activeThumbColor: context.colors.primary,
          onChanged: (value) => notifier.updateShowEmail(value),
        ),
        SwitchListTile(
          title: const Text('Show Availability'),
          subtitle: const Text('Let others see when you are available'),
          value: settings.showAvailability,
          activeThumbColor: context.colors.primary,
          onChanged: (value) => notifier.updateShowAvailability(value),
        ),
      ],
    );
  }
}
