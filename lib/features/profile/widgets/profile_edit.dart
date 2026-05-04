// Profile edit form — clean single-page layout with cover + avatar header
// All profile fields: name, bio, location, timezone, learning style,
// skills to teach/learn, interests, languages, availability

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_gradients.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/profile/providers/profile_provider.dart';
import 'package:skill_exchange/features/profile/widgets/availability_grid.dart';
import 'package:skill_exchange/features/profile/widgets/skills_section.dart';

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
  late final TextEditingController _timezoneController;
  late final TextEditingController _interestInputController;
  late final TextEditingController _languageInputController;

  late String _preferredLearningStyle;
  late List<SkillModel> _skillsToTeach;
  late List<SkillModel> _skillsToLearn;
  late List<String> _interests;
  late List<String> _languages;
  late AvailabilityModel _availability;

  static const List<String> _learningStyles = [
    'visual',
    'auditory',
    'kinesthetic',
    'reading',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _fullNameController = TextEditingController(text: p.fullName);
    _bioController = TextEditingController(text: p.bio ?? '');
    _locationController = TextEditingController(text: p.location ?? '');
    _timezoneController = TextEditingController(text: p.timezone ?? '');
    _interestInputController = TextEditingController();
    _languageInputController = TextEditingController();
    _preferredLearningStyle = _learningStyles.contains(p.preferredLearningStyle)
        ? p.preferredLearningStyle
        : 'visual';
    _skillsToTeach = List<SkillModel>.from(p.skillsToTeach);
    _skillsToLearn = List<SkillModel>.from(p.skillsToLearn);
    _interests = List<String>.from(p.interests);
    _languages = List<String>.from(p.languages);
    _availability = p.availability;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _timezoneController.dispose();
    _interestInputController.dispose();
    _languageInputController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final dto = UpdateProfileDto(
      fullName: _fullNameController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
      timezone: _timezoneController.text.trim(),
      preferredLearningStyle: _preferredLearningStyle,
      skillsToTeach: _skillsToTeach,
      skillsToLearn: _skillsToLearn,
      interests: _interests,
      languages: _languages,
      availability: _availability,
    );

    final success =
        await ref.read(profileNotifierProvider.notifier).updateProfile(dto);

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
    final image =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 512);
    if (image == null) return;
    final url = await ref
        .read(profileNotifierProvider.notifier)
        .uploadAvatar(File(image.path));
    if (url != null && mounted) {
      ref.invalidate(currentProfileProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated!')),
      );
    }
  }

  Future<void> _pickCover() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (image == null) return;
    try {
      await ref
          .read(profileFirestoreServiceProvider)
          .uploadCoverImage(File(image.path));
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

  void _addChip(List<String> list, TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty || list.contains(text)) return;
    setState(() {
      list.add(text);
      controller.clear();
    });
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
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover + Avatar
                _buildCoverWithAvatar(context, colors, profile),
                const SizedBox(height: AppSpacing.xl),

                // ── Basic Info ─────────────────────────────────────────────
                _sectionPadding(
                  children: [
                    _fieldLabel('Full Name'),
                    _filledField(colors, _fullNameController),
                    const SizedBox(height: AppSpacing.lg),

                    _fieldLabel('Email Address'),
                    _readOnlyField(colors, profile.email),
                    const SizedBox(height: AppSpacing.lg),

                    _fieldLabel('Location'),
                    _filledField(colors, _locationController,
                        hint: 'City, Country'),
                    const SizedBox(height: AppSpacing.lg),

                    _fieldLabel('Timezone'),
                    _filledField(colors, _timezoneController,
                        hint: 'e.g. UTC+5:30'),
                    const SizedBox(height: AppSpacing.lg),

                    _fieldLabel('Bio / Description'),
                    _filledField(colors, _bioController,
                        hint:
                            'Tell others about your expertise and work ethic...',
                        maxLines: 3),
                    const SizedBox(height: AppSpacing.lg),

                    _fieldLabel('Preferred Learning Style'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildLearningStyleSelector(colors),
                  ],
                ),

                _sectionDivider(colors),

                // ── Skills ─────────────────────────────────────────────────
                _sectionPadding(
                  children: [
                    SkillsSection(
                      title: 'Skills to Teach',
                      skills: _skillsToTeach,
                      onChanged: (v) => setState(() => _skillsToTeach = v),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    SkillsSection(
                      title: 'Skills to Learn',
                      skills: _skillsToLearn,
                      onChanged: (v) => setState(() => _skillsToLearn = v),
                    ),
                  ],
                ),

                _sectionDivider(colors),

                // ── Languages ──────────────────────────────────────────────
                _sectionPadding(
                  children: [
                    _fieldLabel('Languages'),
                    const SizedBox(height: AppSpacing.sm),
                    if (_languages.isNotEmpty)
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _languages
                            .map((lang) => Chip(
                                  label: Text(lang,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: colors.primary,
                                      )),
                                  deleteIcon: Icon(Icons.close, size: 14, color: colors.primary),
                                  onDeleted: () => setState(
                                      () => _languages.remove(lang)),
                                  backgroundColor: colors.primary.withValues(alpha: 0.1),
                                  side: BorderSide(color: colors.primary.withValues(alpha: 0.2)),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    _chipInput(colors, _languageInputController, 'Add language',
                        () => _addChip(_languages, _languageInputController)),
                  ],
                ),

                _sectionDivider(colors),

                // ── Interests ──────────────────────────────────────────────
                _sectionPadding(
                  children: [
                    _fieldLabel('Interests'),
                    const SizedBox(height: AppSpacing.sm),
                    if (_interests.isNotEmpty)
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _interests
                            .map((interest) => Chip(
                                  label: Text(interest,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: colors.primary,
                                      )),
                                  deleteIcon: Icon(Icons.close, size: 14, color: colors.primary),
                                  onDeleted: () => setState(
                                      () => _interests.remove(interest)),
                                  backgroundColor: colors.primary.withValues(alpha: 0.1),
                                  side: BorderSide(color: colors.primary.withValues(alpha: 0.2)),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    _chipInput(
                        colors,
                        _interestInputController,
                        'Add interest',
                        () =>
                            _addChip(_interests, _interestInputController)),
                  ],
                ),

                _sectionDivider(colors),

                // ── Availability ───────────────────────────────────────────
                _sectionPadding(
                  children: [
                    _fieldLabel('Availability'),
                    const SizedBox(height: AppSpacing.sm),
                    AvailabilityGrid(
                      availability: _availability,
                      readOnly: false,
                      onChanged: (v) => setState(() => _availability = v),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),
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
          decoration: BoxDecoration(
            color: colors.card,
            border: Border(
              top: BorderSide(color: colors.border.withValues(alpha: 0.3)),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              label: 'Save Changes',
              isLoading: isSaving,
              onPressed: isSaving ? null : _save,
            ),
          ),
        ),
      ],
    );
  }

  // ── Cover + Avatar header ───────────────────────────────────────────────────

  Widget _buildCoverWithAvatar(
      BuildContext context, AppColorsExtension colors, UserProfileModel profile) {
    const double coverHeight = 150.0;
    const double avatarSize = 86.0;
    const double avatarOverlap = avatarSize / 2;

    return SizedBox(
      height: coverHeight + avatarOverlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover
          GestureDetector(
            onTap: _pickCover,
            child: SizedBox(
              height: coverHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  if (profile.coverImage != null &&
                      profile.coverImage!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: profile.coverImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: coverHeight,
                      errorWidget: (_, _, _) => Container(
                        decoration: BoxDecoration(
                          gradient: AppGradients.heroFor(
                              Theme.of(context).brightness),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient:
                            AppGradients.heroFor(Theme.of(context).brightness),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _cameraBadge(colors, 34),
                  ),
                ],
              ),
            ),
          ),

          // Avatar
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
                    child: _cameraBadge(colors, 26),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraBadge(AppColorsExtension colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.camera_alt, size: size * 0.45, color: Colors.white),
    );
  }

  // ── Field builders ──────────────────────────────────────────────────────────

  Widget _sectionPadding({required List<Widget> children}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _sectionDivider(AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Divider(
        color: colors.border.withValues(alpha: 0.3),
        height: 1,
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  AppColorsExtension get colors => context.colors;

  Widget _filledField(
    AppColorsExtension colors,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
  }) {
    // Use a concrete light gray that works in both light and dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFF2F2F7);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.mutedForeground.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _readOnlyField(AppColorsExtension colors, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFF2F2F7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        value,
        style:
            AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
      ),
    );
  }

  Widget _chipInput(AppColorsExtension colors, TextEditingController controller,
      String hint, VoidCallback onAdd) {
    return Row(
      children: [
        Expanded(
          child: _filledField(colors, controller, hint: hint),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppButton.icon(
          icon: Icons.add_rounded,
          onPressed: onAdd,
          tooltip: 'Add',
        ),
      ],
    );
  }

  Widget _buildLearningStyleSelector(AppColorsExtension colors) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _learningStyles.map((style) {
        final isSelected = _preferredLearningStyle == style;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ChoiceChip(
          label: Text(
            '${style[0].toUpperCase()}${style.substring(1)}',
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? Colors.white : colors.foreground,
            ),
          ),
          selected: isSelected,
          selectedColor: colors.primary,
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFE8E8ED),
          side: BorderSide.none,
          onSelected: (_) =>
              setState(() => _preferredLearningStyle = style),
        );
      }).toList(),
    );
  }
}
