// Profile view/edit screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/profile/providers/profile_provider.dart';
import 'package:skill_exchange/features/profile/widgets/block_user_sheet.dart';
import 'package:skill_exchange/features/profile/widgets/profile_edit.dart';
import 'package:skill_exchange/features/profile/widgets/profile_view.dart';
import 'package:skill_exchange/features/profile/widgets/report_user_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.userId});

  final String? userId;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;

  bool get _isOwnProfile => widget.userId == null;

  ProviderListenable<AsyncValue<UserProfileModel>> get _provider =>
      _isOwnProfile
          ? currentProfileProvider
          : profileProvider(widget.userId!);

  void _invalidate() {
    if (_isOwnProfile) {
      ref.invalidate(currentProfileProvider);
    } else {
      ref.invalidate(profileProvider(widget.userId!));
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _onAvatarTap() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512);
    if (image == null) return;

    final file = File(image.path);
    final url = await ref.read(profileNotifierProvider.notifier).uploadAvatar(file);
    if (url != null && mounted) {
      ref.invalidate(currentProfileProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated!')),
      );
    }
  }

  Future<void> _showLogoutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(_provider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _invalidate(),
        child: asyncValue.when(
          loading: _buildLoading,
          error: (e, _) => _buildError(e),
          data: (profile) => _buildData(profile),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, _) => const SkeletonCard.profile(),
    );
  }

  Widget _buildError(Object e) {
    return Center(
      child: ErrorMessage(
        message: e.toString(),
        onRetry: _invalidate,
      ),
    );
  }

  Widget _buildData(UserProfileModel profile) {
    if (_isOwnProfile && _isEditing) {
      return ProfileEdit(
        profile: profile,
        onCancel: () => setState(() => _isEditing = false),
        onSaved: () => setState(() => _isEditing = false),
      );
    }

    if (!_isOwnProfile) {
      return Column(
        children: [
          Expanded(
            child: ProfileView(
              profile: profile,
              isOwnProfile: false,
              onBlockPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlockUserSheet(userId: widget.userId!),
              ),
              onReportPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => ReportUserSheet(userId: widget.userId!),
              ),
            ),
          ),
          _OtherUserActions(userId: widget.userId!),
        ],
      );
    }

    return ProfileView(
      profile: profile,
      isOwnProfile: true,
      onEditPressed: _toggleEdit,
      onSettingsPressed: () => context.go(RouteNames.settings),
      onLogoutPressed: _showLogoutDialog,
      onAvatarTap: _onAvatarTap,
    );
  }
}

// -- Other-user bottom action bar ---------------------------------------------

class _OtherUserActions extends ConsumerWidget {
  const _OtherUserActions({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton.primary(
                label: 'Connect',
                onPressed: () => _sendConnectionRequest(context, ref),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton.outline(
                label: 'Book Session',
                onPressed: () => context.go(RouteNames.bookings),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendConnectionRequest(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(connectionFirestoreServiceProvider).sendRequest(userId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection request sent!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: $e')),
        );
      }
    }
  }
}

