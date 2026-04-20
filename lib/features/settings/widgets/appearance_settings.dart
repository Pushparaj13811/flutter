import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/settings/providers/theme_provider.dart';

class AppearanceSettings extends ConsumerWidget {
  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            'Appearance',
            style: AppTextStyles.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('System'),
          subtitle: const Text('Follow device settings'),
          value: ThemeMode.system,
          groupValue: themeMode,
          onChanged: (value) =>
              ref.read(themeModeProvider.notifier).setThemeMode(value!),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light'),
          subtitle: const Text('Always use light theme'),
          value: ThemeMode.light,
          groupValue: themeMode,
          onChanged: (value) =>
              ref.read(themeModeProvider.notifier).setThemeMode(value!),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark'),
          subtitle: const Text('Always use dark theme'),
          value: ThemeMode.dark,
          groupValue: themeMode,
          onChanged: (value) =>
              ref.read(themeModeProvider.notifier).setThemeMode(value!),
        ),
      ],
    );
  }
}
