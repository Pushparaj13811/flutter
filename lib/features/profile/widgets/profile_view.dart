// Profile display widget — modern mobile layout with SliverAppBar
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_gradients.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/utils/formatters.dart';
import 'package:skill_exchange/core/widgets/star_rating.dart';
import 'package:skill_exchange/core/widgets/skill_tag.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/profile/widgets/availability_grid.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.profile,
    this.isOwnProfile = false,
    this.onEditPressed,
    this.onSettingsPressed,
    this.onLogoutPressed,
    this.onBlockPressed,
    this.onReportPressed,
    this.onAvatarTap,
    this.onConnectionsTap,
    this.onSessionsTap,
  });

  final UserProfileModel profile;
  final bool isOwnProfile;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onBlockPressed;
  final VoidCallback? onReportPressed;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onConnectionsTap;
  final VoidCallback? onSessionsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        children: [
          // -- Cover image with avatar overlapping --
          _buildCoverWithAvatar(context, colors),

          // -- Name, username, location --
          const SizedBox(height: AppSpacing.sm),
          _buildIdentity(colors),
          const SizedBox(height: AppSpacing.lg),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: _buildStatsRow(colors),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Sections
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              children: [
                // About / Bio
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  _buildSectionCard(
                    colors,
                    icon: Icons.person_outline,
                    title: 'Bio',
                    child: Text(
                      profile.bio!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.foreground,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Skills to Teach
                if (profile.skillsToTeach.isNotEmpty) ...[
                  _buildSkillsSection(
                    colors,
                    title: 'Skills to Teach',
                    icon: Icons.school_outlined,
                    iconColor: colors.success,
                    skills: profile.skillsToTeach,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Skills to Learn
                if (profile.skillsToLearn.isNotEmpty) ...[
                  _buildSkillsSection(
                    colors,
                    title: 'Skills to Learn',
                    icon: Icons.auto_stories_outlined,
                    iconColor: colors.primary,
                    skills: profile.skillsToLearn,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Availability
                _buildSectionCard(
                  colors,
                  icon: Icons.calendar_today_outlined,
                  title: 'Availability',
                  child: AvailabilityGrid(
                    availability: profile.availability,
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Details (languages, interests)
                if (profile.languages.isNotEmpty ||
                    profile.interests.isNotEmpty) ...[
                  _buildDetailsSection(colors),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Footer — Learning style + Member since
                _buildFooterCard(colors),
                const SizedBox(height: AppSpacing.lg),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -- Cover image with avatar overlapping using Stack -----------------------

  Widget _buildCoverWithAvatar(BuildContext context, AppColorsExtension colors) {
    const double coverHeight = 180.0;
    const double avatarSize = 88.0;
    const double borderWidth = 4.0;
    const double avatarTotal = avatarSize + borderWidth * 2;
    const double avatarOverlap = avatarTotal / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Cover image / gradient
        Column(
          children: [
            SizedBox(
              height: coverHeight + avatarOverlap, // extra space for avatar bottom half
              child: Stack(
                children: [
                  // Cover
                  SizedBox(
                    height: coverHeight,
                    width: double.infinity,
                    child: _buildCoverImage(context, colors),
                  ),
                  // Transparent area below cover for avatar overlap
                ],
              ),
            ),
          ],
        ),

        // Avatar positioned at cover bottom boundary
        Positioned(
          top: coverHeight - avatarOverlap,
          child: _buildAvatar(colors),
        ),

        // Top action bar (overlays the cover)
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isOwnProfile) ...[
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  tooltip: 'Settings',
                  onPressed: onSettingsPressed,
                ),
                PopupMenuButton<_OwnProfileAction>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (action) {
                    switch (action) {
                      case _OwnProfileAction.edit:
                        onEditPressed?.call();
                      case _OwnProfileAction.logout:
                        onLogoutPressed?.call();
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: _OwnProfileAction.edit,
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit Profile'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _OwnProfileAction.logout,
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18, color: ctx.colors.destructive),
                          const SizedBox(width: 8),
                          Text('Log Out', style: TextStyle(color: ctx.colors.destructive)),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                PopupMenuButton<_OtherProfileAction>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (action) {
                    switch (action) {
                      case _OtherProfileAction.block:
                        onBlockPressed?.call();
                      case _OtherProfileAction.report:
                        onReportPressed?.call();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _OtherProfileAction.block,
                      child: Row(
                        children: [
                          Icon(Icons.block, size: 18),
                          SizedBox(width: 8),
                          Text('Block'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _OtherProfileAction.report,
                      child: Row(
                        children: [
                          Icon(Icons.flag_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Report'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImage(BuildContext context, AppColorsExtension colors) {
    if (profile.coverImage != null && profile.coverImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profile.coverImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorWidget: (_, _, _) => _buildGradientCover(context),
      );
    }
    return _buildGradientCover(context);
  }

  Widget _buildGradientCover(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.heroFor(Theme.of(context).brightness),
      ),
    );
  }

  // -- Avatar -----------------------------------------------------------------

  Widget _buildAvatar(AppColorsExtension colors) {
    const double avatarSize = 88;
    const double borderWidth = 4;

    Widget avatar = Container(
      padding: const EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.card,
      ),
      child: UserAvatar(
        imageUrl: profile.avatar,
        name: profile.fullName,
        size: avatarSize,
        heroTag: 'avatar_${profile.id}',
      ),
    );

    if (isOwnProfile && onAvatarTap != null) {
      avatar = GestureDetector(
        onTap: onAvatarTap,
        child: Stack(
          children: [
            avatar,
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.card, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: colors.primaryForeground,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return avatar;
  }

  // -- Identity (name, username, location) ------------------------------------

  Widget _buildIdentity(AppColorsExtension colors) {
    return Column(
      children: [
        Text(
          profile.fullName,
          style: AppTextStyles.h2.copyWith(color: colors.foreground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '@${profile.username}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.mutedForeground,
          ),
        ),
        if (profile.location != null && profile.location!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: colors.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                profile.location!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // -- Stats row --------------------------------------------------------------

  Widget _buildStatsRow(AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          _buildStatItem(
            colors,
            value: Formatters.number(profile.stats.connectionsCount),
            label: 'Connections',
            onTap: onConnectionsTap,
          ),
          _verticalDivider(colors),
          _buildStatItem(
            colors,
            value: Formatters.number(profile.stats.sessionsCompleted),
            label: 'Sessions',
            onTap: onSessionsTap,
          ),
          _verticalDivider(colors),
          _buildStatItem(
            colors,
            value: profile.stats.averageRating.toStringAsFixed(1),
            label: 'Rating',
            trailing: StarRating(
              rating: profile.stats.averageRating,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    AppColorsExtension colors, {
    required String value,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    Widget content = Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: colors.foreground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: onTap != null ? colors.primary : colors.mutedForeground,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(height: 4),
          trailing,
        ],
      ],
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return Expanded(child: content);
  }

  Widget _verticalDivider(AppColorsExtension colors) {
    return Container(
      width: 1,
      height: 40,
      color: colors.border.withValues(alpha: 0.5),
    );
  }

  // -- Skills section ---------------------------------------------------------

  Widget _buildSkillsSection(
    AppColorsExtension colors, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<SkillModel> skills,
  }) {
    return _buildSectionCard(
      colors,
      icon: icon,
      iconColor: iconColor,
      title: title,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: skills
            .map((skill) => SkillTag(
                  name: skill.name,
                  level: skill.level.value,
                ))
            .toList(),
      ),
    );
  }

  // -- Details section (languages + interests) --------------------------------

  Widget _buildDetailsSection(AppColorsExtension colors) {
    return _buildSectionCard(
      colors,
      icon: Icons.interests_outlined,
      title: 'Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile.languages.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.translate, size: 16, color: colors.mutedForeground),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Languages',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: profile.languages
                  .map((lang) => _chip(colors, lang))
                  .toList(),
            ),
          ],
          if (profile.languages.isNotEmpty && profile.interests.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(
                color: colors.border.withValues(alpha: 0.5),
                height: 1,
              ),
            ),
          if (profile.interests.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.favorite_outline,
                    size: 16, color: colors.mutedForeground),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Interests',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: profile.interests
                  .map((interest) => _chip(colors, interest))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(AppColorsExtension colors, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: colors.foreground,
        ),
      ),
    );
  }

  // -- Footer card (learning style + joined date) -----------------------------

  Widget _buildFooterCard(AppColorsExtension colors) {
    final joined = profile.joinedAt.toDateTimeOrNull;
    final joinedText = joined != null ? joined.fullDate : profile.joinedAt;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          _infoRow(
            colors,
            icon: Icons.lightbulb_outline,
            label: 'Learning Style',
            value: _formatLearningStyle(profile.preferredLearningStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(
              color: colors.border.withValues(alpha: 0.3),
              height: 1,
            ),
          ),
          _infoRow(
            colors,
            icon: Icons.calendar_month_outlined,
            label: 'Member Since',
            value: joinedText,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    AppColorsExtension colors, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.mutedForeground),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.mutedForeground,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: colors.foreground,
          ),
        ),
      ],
    );
  }

  // -- Helpers ----------------------------------------------------------------

  String _formatLearningStyle(String style) {
    return style.isEmpty
        ? 'Not set'
        : '${style[0].toUpperCase()}${style.substring(1)}';
  }

  Widget _buildSectionCard(
    AppColorsExtension colors, {
    required IconData icon,
    required String title,
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor ?? colors.primary,
              ),
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
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

// -- Own profile popup menu actions -------------------------------------------

enum _OwnProfileAction { edit, logout }

enum _OtherProfileAction { block, report }
