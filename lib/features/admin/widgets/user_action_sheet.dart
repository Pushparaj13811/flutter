import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';

class UserActionSheet extends ConsumerStatefulWidget {
  const UserActionSheet({
    super.key,
    required this.user,
    this.isBanned = false,
  });

  final UserProfileModel user;
  final bool isBanned;

  @override
  ConsumerState<UserActionSheet> createState() => _UserActionSheetState();
}

class _UserActionSheetState extends ConsumerState<UserActionSheet> {
  bool _isProcessing = false;

  Future<void> _handleBanToggle() async {
    final isBan = !widget.isBanned;
    final confirmed = await _showConfirmation(
      title: isBan ? 'Ban User' : 'Unban User',
      message: isBan
          ? 'Are you sure you want to ban ${widget.user.fullName}? They will lose access to the platform.'
          : 'Are you sure you want to unban ${widget.user.fullName}? They will regain access to the platform.',
      confirmLabel: isBan ? 'Ban' : 'Unban',
      isDestructive: isBan,
    );

    if (!confirmed || !mounted) return;

    setState(() => _isProcessing = true);

    final notifier = ref.read(adminNotifierProvider.notifier);
    final success = isBan
        ? await notifier.banUser(widget.user.id)
        : await notifier.unbanUser(widget.user.id);

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isBan
                ? '${widget.user.fullName} has been banned.'
                : '${widget.user.fullName} has been unbanned.',
          ),
        ),
      );
    }
  }

  Future<void> _handleViewProfile() async {
    Navigator.of(context).pop();
    // Navigate to user profile - caller can handle navigation
  }

  Future<void> _handleSendWarning() async {
    Navigator.of(context).pop('warning');
  }

  Future<bool> _showConfirmation({
    required String title,
    required String message,
    required String confirmLabel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(
                    foregroundColor: this.context.colors.destructive,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // User info header
              _UserInfoHeader(user: widget.user, isBanned: widget.isBanned),
              const SizedBox(height: AppSpacing.xl),

              Divider(height: 1, color: context.colors.border),
              const SizedBox(height: AppSpacing.md),

              // Actions
              if (_isProcessing)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(),
                )
              else ...[
                _ActionTile(
                  icon: Icons.person_outline,
                  label: 'View Profile',
                  onTap: _handleViewProfile,
                ),
                _ActionTile(
                  icon: Icons.warning_amber_outlined,
                  label: 'Send Warning',
                  onTap: _handleSendWarning,
                  iconColor: context.colors.warning,
                ),
                _ActionTile(
                  icon: widget.isBanned
                      ? Icons.lock_open_outlined
                      : Icons.block_outlined,
                  label: widget.isBanned ? 'Unban User' : 'Ban User',
                  onTap: _handleBanToggle,
                  iconColor: widget.isBanned
                      ? context.colors.success
                      : context.colors.destructive,
                  textColor: widget.isBanned
                      ? context.colors.success
                      : context.colors.destructive,
                ),
              ],

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

// ── User Info Header ──────────────────────────────────────────────────────

class _UserInfoHeader extends StatelessWidget {
  const _UserInfoHeader({
    required this.user,
    required this.isBanned,
  });

  final UserProfileModel user;
  final bool isBanned;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage:
              user.avatar != null ? NetworkImage(user.avatar!) : null,
          backgroundColor: context.colors.muted,
          child: user.avatar == null
              ? Text(
                  user.fullName.isNotEmpty
                      ? user.fullName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.h4.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user.fullName,
                      style: AppTextStyles.h4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isBanned) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.destructive
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppRadius.chip),
                      ),
                      child: Text(
                        'Banned',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.destructive,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                user.email,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.mutedForeground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Action Tile ───────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? context.colors.foreground),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor ?? context.colors.foreground,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
      ),
    );
  }
}
