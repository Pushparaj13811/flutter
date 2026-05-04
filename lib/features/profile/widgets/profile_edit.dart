// Profile edit form — clean single-page layout with cover + avatar header

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_gradients.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/profile/providers/profile_provider.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  const ProfileEdit({
    super.key,
    required this.profile,
    required this.onCancel,
    required this.onSaved,
  });

  final UserProfileModel profile;
  final VoidCallback onCancel;
  final VoidCallback onSaved;

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _fullNameController = TextEditingController(text: p.fullName);
    _bioController = TextEditingController(text: p.bio ?? '');
    _locationController = TextEditingController(text: p.location ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final dto = UpdateProfileDto(
      fullName: _fullNameController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );

    final success = await ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(dto);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      widget.onSaved();
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> _pickAvatar() async {
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

  Future<void> _pickCover() async {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final notifierState = ref.watch(profileNotifierProvider);
    final isSaving = notifierState is AsyncLoading;
    final profile = widget.profile;

    return Column(
      children: [
        // App bar
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onCancel,
          ),
          title: Text(
            'Edit Profile',
            style: AppTextStyles.h4.copyWith(color: colors.primary),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover + Avatar
                _buildCoverWithAvatar(context, colors, profile),
                const SizedBox(height: AppSpacing.xl),

                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Full Name'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildFilledField(colors, _fullNameController),
                      const SizedBox(height: AppSpacing.lg),

                      _buildFieldLabel('Email Address'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildReadOnlyField(colors, profile.email),
                      const SizedBox(height: AppSpacing.lg),

                      _buildFieldLabel('Location'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildFilledField(colors, _locationController, hint: 'City, Country'),
                      const SizedBox(height: AppSpacing.lg),

                      _buildFieldLabel('Bio / Description'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildFilledField(
                        colors,
                        _bioController,
                        hint: 'Tell clients about your expertise and work ethic...',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Save button pinned at bottom
        Container(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            top: AppSpacing.md,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
          ),
          child: SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              label: 'Save',
              isLoading: isSaving,
              onPressed: isSaving ? null : _save,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverWithAvatar(
      BuildContext context, AppColorsExtension colors, UserProfileModel profile) {
    const double coverHeight = 160.0;
    const double avatarSize = 90.0;
    const double avatarOverlap = avatarSize / 2;

    return SizedBox(
      height: coverHeight + avatarOverlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover image
          GestureDetector(
            onTap: _pickCover,
            child: SizedBox(
              height: coverHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  if (profile.coverImage != null && profile.coverImage!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: profile.coverImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: coverHeight,
                      errorWidget: (_, _, _) => Container(
                        decoration: BoxDecoration(
                          gradient: AppGradients.heroFor(Theme.of(context).brightness),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppGradients.heroFor(Theme.of(context).brightness),
                      ),
                    ),
                  // Camera icon on cover
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Avatar overlapping bottom of cover
          Positioned(
            bottom: 0,
            left: AppSpacing.screenPadding,
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.card,
                    ),
                    child: UserAvatar(
                      imageUrl: profile.avatar,
                      name: profile.fullName,
                      size: avatarSize,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.labelMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFilledField(
    AppColorsExtension colors,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
        filled: true,
        fillColor: colors.muted.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(AppColorsExtension colors, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
      ),
    );
  }
}
