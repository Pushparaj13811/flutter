// Profile view/edit screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isOwnProfile ? 'My Profile' : 'Profile'),
        actions: [
          if (_isOwnProfile && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit profile',
              onPressed: _toggleEdit,
            ),
          if (_isOwnProfile && !_isEditing)
            const SizedBox.shrink()
          else if (!_isOwnProfile)
            _OtherUserMenu(userId: widget.userId!),
        ],
      ),
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
            ),
          ),
          _OtherUserActions(userId: widget.userId!),
        ],
      );
    }

    return ProfileView(
      profile: profile,
      isOwnProfile: true,
    );
  }
}

// ── Other-user app-bar popup menu ────────────────────────────────────────────

class _OtherUserMenu extends StatelessWidget {
  const _OtherUserMenu({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_UserAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => _onSelected(context, action),
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: _UserAction.block,
          child: Row(
            children: [
              Icon(Icons.block, size: 18),
              SizedBox(width: 8),
              Text('Block'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _UserAction.report,
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18),
              SizedBox(width: 8),
              Text('Report'),
            ],
          ),
        ),
      ],
    );
  }

  void _onSelected(BuildContext context, _UserAction action) {
    switch (action) {
      case _UserAction.block:
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlockUserSheet(userId: userId),
        );
      case _UserAction.report:
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => ReportUserSheet(userId: userId),
        );
    }
  }
}

// ── Other-user bottom action bar ─────────────────────────────────────────────

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

// ── Helpers ───────────────────────────────────────────────────────────────────

enum _UserAction { block, report }
