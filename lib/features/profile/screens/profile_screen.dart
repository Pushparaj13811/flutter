// Profile view/edit screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/features/connections/providers/connections_provider.dart';
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

  Future<void> _onCoverTap() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (image == null) return;

    final file = File(image.path);
    try {
      await ref.read(profileFirestoreServiceProvider).uploadCoverImage(file);
      if (mounted) {
        ref.invalidate(currentProfileProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cover image updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload cover: $e')),
        );
      }
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
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(_provider);

    return Scaffold(
      appBar: _isOwnProfile
          ? AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Settings',
                  onPressed: () => context.push(RouteNames.settings),
                ),
              ],
            )
          : null,
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
              onConnectionsTap: () => context.push(RouteNames.connections),
              onSessionsTap: () => context.push(RouteNames.bookings),
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
      onSettingsPressed: () => context.push(RouteNames.settings),
      onLogoutPressed: _showLogoutDialog,
      onAvatarTap: _onAvatarTap,
      onCoverTap: _onCoverTap,
      onConnectionsTap: () => context.push(RouteNames.connections),
      onSessionsTap: () => context.push(RouteNames.bookings),
    );
  }
}

// -- Other-user bottom action bar ---------------------------------------------

class _OtherUserActions extends ConsumerStatefulWidget {
  const _OtherUserActions({required this.userId});
  final String userId;

  @override
  ConsumerState<_OtherUserActions> createState() => _OtherUserActionsState();
}

class _OtherUserActionsState extends ConsumerState<_OtherUserActions> {
  String _status = 'loading';

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final status = await ref
          .read(connectionFirestoreServiceProvider)
          .getConnectionStatus(widget.userId);
      if (mounted) setState(() => _status = status);
    } catch (_) {
      if (mounted) setState(() => _status = 'none');
    }
  }

  Future<void> _sendRequest() async {
    try {
      await ref
          .read(connectionsNotifierProvider.notifier)
          .sendRequest(widget.userId, null);
      if (mounted) {
        setState(() => _status = 'pending_sent');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection request sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String buttonLabel;
    VoidCallback? onPressed;
    bool isPrimary = true;

    switch (_status) {
      case 'connected':
        buttonLabel = 'Connected';
        onPressed = null;
        isPrimary = false;
      case 'pending_sent':
        buttonLabel = 'Request Sent';
        onPressed = null;
        isPrimary = false;
      case 'pending_received':
        buttonLabel = 'Accept';
        onPressed = () async {
          final pending = await ref
              .read(connectionFirestoreServiceProvider)
              .getPendingRequests();
          final match = pending
              .where((c) => c['requester'] == widget.userId)
              .toList();
          if (match.isNotEmpty) {
            await ref
                .read(connectionFirestoreServiceProvider)
                .acceptRequest(match.first['id'] as String);
            if (mounted) setState(() => _status = 'connected');
          }
        };
      case 'loading':
        buttonLabel = '...';
        onPressed = null;
      default: // 'none'
        buttonLabel = 'Connect';
        onPressed = _sendRequest;
    }

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
              child: isPrimary
                  ? AppButton.primary(
                      label: buttonLabel, onPressed: onPressed)
                  : AppButton.outline(
                      label: buttonLabel, onPressed: onPressed),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton.outline(
                label: _status == 'connected' ? 'Message' : 'Book Session',
                onPressed: () {
                  if (_status == 'connected') {
                    context.push('${RouteNames.messages}/${widget.userId}');
                  } else {
                    context.push(RouteNames.bookings);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

