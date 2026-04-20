// Settings screen — modern mobile settings pattern

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/settings/providers/settings_provider.dart';
import 'package:skill_exchange/features/settings/providers/theme_provider.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsNotifierProvider);
    final colors = context.colors;

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
                  color: colors.destructive,
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
        data: (settings) => _buildSettings(context, ref, settings, colors),
      ),
    );
  }

  Widget _buildSettings(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppColorsExtension colors,
  ) {
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Account Section ────────────────────────────────────────────
          _SectionCard(
            colors: colors,
            icon: Icons.person_outline,
            title: 'Account',
            children: [
              _SettingsTile(
                colors: colors,
                icon: Icons.lock_outline,
                title: 'Change Password',
                trailing: Icon(Icons.chevron_right, color: colors.mutedForeground, size: 20),
                onTap: () => _showChangePasswordDialog(context),
              ),
              _divider(colors),
              _SettingsTile(
                colors: colors,
                icon: Icons.email_outlined,
                title: 'Change Email',
                trailing: Icon(Icons.chevron_right, color: colors.mutedForeground, size: 20),
                onTap: () => _showChangeEmailDialog(context),
              ),
              _divider(colors),
              _SettingsTile(
                colors: colors,
                icon: Icons.delete_outline,
                title: 'Delete Account',
                titleColor: colors.destructive,
                trailing: Icon(Icons.chevron_right, color: colors.mutedForeground, size: 20),
                onTap: () => _showDeleteAccountDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Notifications Section ─────────────────────────────────────
          _SectionCard(
            colors: colors,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            children: [
              _SettingsToggle(
                colors: colors,
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                value: settings.pushNotifications,
                onChanged: (v) => notifier.updatePushNotifications(v),
              ),
              _divider(colors),
              _SettingsToggle(
                colors: colors,
                icon: Icons.mark_email_read_outlined,
                title: 'Email Notifications',
                value: settings.emailNotifications,
                onChanged: (v) => notifier.updateEmailNotifications(v),
              ),
              _divider(colors),
              _SettingsToggle(
                colors: colors,
                icon: Icons.alarm_outlined,
                title: 'Session Reminders',
                value: settings.sessionReminders,
                onChanged: (v) => notifier.updateSessionReminders(v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Privacy Section ────────────────────────────────────────────
          _SectionCard(
            colors: colors,
            icon: Icons.lock_outlined,
            title: 'Privacy',
            children: [
              _SettingsTile(
                colors: colors,
                icon: Icons.visibility_outlined,
                title: 'Profile Visibility',
                trailing: _VisibilityDropdown(
                  colors: colors,
                  value: settings.profileVisibility,
                  onChanged: (v) => notifier.updateProfileVisibility(v),
                ),
                onTap: null,
              ),
              _divider(colors),
              _SettingsToggle(
                colors: colors,
                icon: Icons.alternate_email,
                title: 'Show Email',
                value: settings.showEmail,
                onChanged: (v) => notifier.updateShowEmail(v),
              ),
              _divider(colors),
              _SettingsToggle(
                colors: colors,
                icon: Icons.schedule_outlined,
                title: 'Show Availability',
                value: settings.showAvailability,
                onChanged: (v) => notifier.updateShowAvailability(v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Appearance Section ─────────────────────────────────────────
          _SectionCard(
            colors: colors,
            icon: Icons.palette_outlined,
            title: 'Appearance',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(Icons.brightness_6_outlined, size: 20, color: colors.mutedForeground),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Theme',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.foreground,
                        ),
                      ),
                    ),
                    _ThemeSegmentedControl(
                      colors: colors,
                      value: themeMode,
                      onChanged: (mode) =>
                          ref.read(themeModeProvider.notifier).setThemeMode(mode),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Log Out Button ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _handleLogout(context, ref),
              icon: Icon(Icons.logout, color: colors.destructive),
              label: Text(
                'Log Out',
                style: TextStyle(color: colors.destructive),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.destructive.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Version ────────────────────────────────────────────────────
          Center(
            child: Text(
              'Skill Exchange v1.0.0',
              style: AppTextStyles.caption.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _divider(AppColorsExtension colors) {
    return Divider(
      height: 1,
      indent: AppSpacing.md + 20 + AppSpacing.md,
      color: colors.border.withValues(alpha: 0.5),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showChangePasswordDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppSpacing.inputGap),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppSpacing.inputGap),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Email'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppSpacing.inputGap),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'New Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'This action cannot be undone and all your data will be '
          'permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.destructive,
              foregroundColor: colors.destructiveForeground,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.colors,
    required this.icon,
    required this.title,
    required this.children,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: colors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

// ── Settings Tile (navigation) ────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.colors,
    required this.icon,
    required this.title,
    this.titleColor,
    this.trailing,
    required this.onTap,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.mutedForeground),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: titleColor ?? colors.foreground,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

// ── Settings Toggle (switch) ──────────────────────────────────────────────────

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.colors,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.mutedForeground),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.foreground,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: colors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ── Visibility Dropdown ───────────────────────────────────────────────────────

class _VisibilityDropdown extends StatelessWidget {
  const _VisibilityDropdown({
    required this.colors,
    required this.value,
    required this.onChanged,
  });

  final AppColorsExtension colors;
  final String value;
  final ValueChanged<String> onChanged;

  String get _label {
    switch (value) {
      case 'public':
        return 'Public';
      case 'connections':
        return 'Connections';
      case 'private':
        return 'Private';
      default:
        return 'Public';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _label,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.foreground,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: colors.mutedForeground),
          ],
        ),
      ),
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'public', child: Text('Public')),
        const PopupMenuItem(value: 'connections', child: Text('Connections')),
        const PopupMenuItem(value: 'private', child: Text('Private')),
      ],
    );
  }
}

// ── Theme Segmented Control ──────────────────────────────────────────────────

class _ThemeSegmentedControl extends StatelessWidget {
  const _ThemeSegmentedControl({
    required this.colors,
    required this.value,
    required this.onChanged,
  });

  final AppColorsExtension colors;
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode, size: 16),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode, size: 16),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.settings_suggest, size: 16),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selected) => onChanged(selected.first),
      showSelectedIcon: false,
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
