// Settings screen — modern mobile settings pattern

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // ── Bottom Sheets ─────────────────────────────────────────────────────────

  void _showChangePasswordDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _ChangePasswordSheet(),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _ChangeEmailSheet(),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _DeleteAccountSheet(ref: ref),
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

// ── Change Password Bottom Sheet ─────────────────────────────────────────────

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    if (newPassword.length < 6) {
      _showError('New password must be at least 6 characters.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showError('New passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      _showError(e.message ?? 'Failed to change password.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to change password: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.colors.destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          const SizedBox(height: 20),
          Text('Change Password', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          TextField(
            controller: _currentPasswordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Current Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.inputGap),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'New Password',
              prefixIcon: const Icon(Icons.lock_reset),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.inputGap),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: const Icon(Icons.lock_reset),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _changePassword,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Update Password'),
          ),
        ],
      ),
    );
  }
}

// ── Change Email Bottom Sheet ────────────────────────────────────────────────

class _ChangeEmailSheet extends StatefulWidget {
  const _ChangeEmailSheet();

  @override
  State<_ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends State<_ChangeEmailSheet> {
  final _passwordController = TextEditingController();
  final _newEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _changeEmail() async {
    final password = _passwordController.text;
    final newEmail = _newEmailController.text.trim();

    if (password.isEmpty || newEmail.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    if (!newEmail.contains('@')) {
      _showError('Please enter a valid email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent to new address. Please verify to complete the change.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      _showError(e.message ?? 'Failed to change email.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to change email: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.colors.destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          const SizedBox(height: 20),
          Text('Change Email', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Current Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.inputGap),
          TextField(
            controller: _newEmailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'New Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _changeEmail,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Update Email'),
          ),
        ],
      ),
    );
  }
}

// ── Delete Account Bottom Sheet ──────────────────────────────────────────────

class _DeleteAccountSheet extends StatefulWidget {
  const _DeleteAccountSheet({required this.ref});

  final WidgetRef ref;

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      _showError('Please enter your password to confirm.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Mark as inactive in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'isActive': false});

      await user.delete();

      if (mounted) {
        Navigator.of(context).pop();
        widget.ref.read(authProvider.notifier).logout();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      _showError(e.message ?? 'Failed to delete account.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to delete account: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.colors.destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Delete Account', style: AppTextStyles.h3.copyWith(color: colors.destructive)),
          const SizedBox(height: 12),
          Text(
            'This action cannot be undone. All your data will be permanently removed.',
            style: AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Enter password to confirm',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _deleteAccount,
            style: FilledButton.styleFrom(
              backgroundColor: colors.destructive,
              foregroundColor: colors.destructiveForeground,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Delete My Account'),
          ),
        ],
      ),
    );
  }
}
