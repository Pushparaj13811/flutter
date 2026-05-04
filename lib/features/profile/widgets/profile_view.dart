// Profile display widget — own profile has gradient header; other profiles keep
// cover+sections layout.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
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
    this.onCoverTap,
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
  final VoidCallback? onCoverTap;
  final VoidCallback? onConnectionsTap;
  final VoidCallback? onSessionsTap;

  @override
  Widget build(BuildContext context) {
    if (isOwnProfile) {
      return _OwnProfileLayout(
        profile: profile,
        onEditPressed: onEditPressed,
        onLogoutPressed: onLogoutPressed,
        onAvatarTap: onAvatarTap,
        onConnectionsTap: onConnectionsTap,
        onSessionsTap: onSessionsTap,
      );
    }

    return _OtherProfileLayout(
      profile: profile,
      onBlockPressed: onBlockPressed,
      onReportPressed: onReportPressed,
      onConnectionsTap: onConnectionsTap,
      onSessionsTap: onSessionsTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Own Profile — gradient header + activity stats + nav list
// ---------------------------------------------------------------------------

class _OwnProfileLayout extends StatelessWidget {
  const _OwnProfileLayout({
    required this.profile,
    this.onEditPressed,
    this.onLogoutPressed,
    this.onAvatarTap,
    this.onConnectionsTap,
    this.onSessionsTap,
  });

  final UserProfileModel profile;
  final VoidCallback? onEditPressed;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onConnectionsTap;
  final VoidCallback? onSessionsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topPad = MediaQuery.of(context).padding.top;

    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gradient header — tall, fades smoothly into background ──────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.55, 0.85, 1.0],
                colors: [
                  colors.primary,
                  colors.primary,
                  colors.primary.withValues(alpha: 0.4),
                  scaffoldBg,
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPad + AppSpacing.xxl,
                bottom: AppSpacing.xxl,
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
              ),
              child: Column(
                children: [
                  // Avatar with camera badge
                  _buildAvatar(colors),
                  const SizedBox(height: AppSpacing.md),

                  // Name
                  Text(
                    profile.fullName,
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // @username
                  Text(
                    '@${profile.username}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Location
                  if (profile.location != null && profile.location!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        Text(
                          profile.location!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xl),

                  // Manage Profile button
                  OutlinedButton.icon(
                    onPressed: onEditPressed,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: Text(
                      'Manage Profile',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70, width: 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Activity stats card ──────────────────────────────────────────
          _buildActivityCard(context, colors),

          const SizedBox(height: AppSpacing.lg),

          // ── User details sections ──────────────────────────────────────
          _buildUserDetails(context, colors),

          // ── Nav list items ───────────────────────────────────────────────
          _buildNavList(context, colors),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildAvatar(AppColorsExtension colors) {
    const double size = 80;

    Widget avatar = Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: UserAvatar(
        imageUrl: profile.avatar,
        name: profile.fullName,
        size: size,
        heroTag: 'avatar_${profile.id}',
      ),
    );

    if (onAvatarTap != null) {
      avatar = GestureDetector(
        onTap: onAvatarTap,
        child: Stack(
          children: [
            avatar,
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
                child: const Icon(
                  Icons.camera_alt,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return avatar;
  }

  Widget _buildActivityCard(BuildContext context, AppColorsExtension colors) {
    final skillsCount =
        profile.skillsToTeach.length + profile.skillsToLearn.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Your Activity',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Row 1: Sessions | Connections
          Row(
            children: [
              _StatBox(
                value: Formatters.number(profile.stats.sessionsCompleted),
                label: 'Sessions',
                onTap: onSessionsTap,
              ),
              const SizedBox(width: AppSpacing.md),
              _StatBox(
                value: Formatters.number(profile.stats.connectionsCount),
                label: 'Connections',
                onTap: onConnectionsTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Row 2: Reviews | Skills
          Row(
            children: [
              _StatBox(
                value: Formatters.number(profile.stats.reviewsReceived),
                label: 'Reviews',
              ),
              const SizedBox(width: AppSpacing.md),
              _StatBox(
                value: skillsCount.toString(),
                label: 'Skills',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            _detailSection(colors, Icons.person_outline, 'Bio',
              child: Text(
                profile.bio!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.foreground,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Skills to Teach
          if (profile.skillsToTeach.isNotEmpty) ...[
            _detailSection(colors, Icons.school_outlined, 'Skills to Teach',
              iconColor: colors.success,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: profile.skillsToTeach
                    .map((s) => SkillTag(name: s.name, level: s.level.value))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Skills to Learn
          if (profile.skillsToLearn.isNotEmpty) ...[
            _detailSection(colors, Icons.auto_stories_outlined, 'Skills to Learn',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: profile.skillsToLearn
                    .map((s) => SkillTag(name: s.name, level: s.level.value))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Languages
          if (profile.languages.isNotEmpty) ...[
            _detailSection(colors, Icons.translate, 'Languages',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: profile.languages
                    .map((l) => _detailChip(colors, l))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Interests
          if (profile.interests.isNotEmpty) ...[
            _detailSection(colors, Icons.favorite_outline, 'Interests',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: profile.interests
                    .map((i) => _detailChip(colors, i))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Availability
          _detailSection(colors, Icons.calendar_today_outlined, 'Availability',
            child: AvailabilityGrid(
              availability: profile.availability,
              readOnly: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Rating + Learning Style + Member Since
          _detailSection(colors, Icons.info_outline, 'About',
            child: Column(
              children: [
                _infoRow(colors, 'Rating',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.stats.averageRating.toStringAsFixed(1),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      StarRating(rating: profile.stats.averageRating, size: 14),
                    ],
                  ),
                ),
                Divider(height: AppSpacing.lg, color: colors.border.withValues(alpha: 0.3)),
                _infoRow(colors, 'Learning Style',
                  value: profile.preferredLearningStyle.isEmpty
                      ? 'Not set'
                      : '${profile.preferredLearningStyle[0].toUpperCase()}${profile.preferredLearningStyle.substring(1)}',
                ),
                Divider(height: AppSpacing.lg, color: colors.border.withValues(alpha: 0.3)),
                _infoRow(colors, 'Member Since',
                  value: profile.joinedAt.toDateTimeOrNull?.fullDate ?? profile.joinedAt,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _detailSection(AppColorsExtension colors, IconData icon, String title, {
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor ?? colors.primary),
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

  Widget _detailChip(AppColorsExtension colors, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: colors.primary),
      ),
    );
  }

  Widget _infoRow(AppColorsExtension colors, String label, {String? value, Widget? trailing}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: colors.mutedForeground),
          ),
        ),
        if (trailing != null)
          trailing
        else
          Text(
            value ?? '',
            style: AppTextStyles.labelMedium.copyWith(
              color: colors.foreground,
            ),
          ),
      ],
    );
  }

  Widget _buildNavList(BuildContext context, AppColorsExtension colors) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          _NavItem(
            icon: Icons.calendar_today_outlined,
            label: 'My Sessions',
            colors: colors,
            onTap: () => context.push(RouteNames.bookings),
          ),
          Divider(height: 1, color: colors.border.withValues(alpha: 0.5)),
          _NavItem(
            icon: Icons.group_outlined,
            label: 'Community',
            colors: colors,
            onTap: () => context.push(RouteNames.community),
          ),
          Divider(height: 1, color: colors.border.withValues(alpha: 0.5)),
          _NavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            colors: colors,
            onTap: () => context.push(RouteNames.settings),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Version footer
          Text(
            'Skill Exchange v1.0.0',
            style: AppTextStyles.caption.copyWith(
              color: colors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Other user profile — cover + sections (existing layout, cleaned up)
// ---------------------------------------------------------------------------

class _OtherProfileLayout extends StatelessWidget {
  const _OtherProfileLayout({
    required this.profile,
    this.onBlockPressed,
    this.onReportPressed,
    this.onConnectionsTap,
    this.onSessionsTap,
  });

  final UserProfileModel profile;
  final VoidCallback? onBlockPressed;
  final VoidCallback? onReportPressed;
  final VoidCallback? onConnectionsTap;
  final VoidCallback? onSessionsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Cover + avatar
          _buildCoverWithAvatar(context, colors),
          const SizedBox(height: AppSpacing.sm),

          // Identity
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
                if (profile.languages.isNotEmpty ||
                    profile.interests.isNotEmpty) ...[
                  _buildDetailsSection(colors),
                  const SizedBox(height: AppSpacing.lg),
                ],
                _buildFooterCard(colors),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -- Cover with avatar (other user — no settings icon, only 3-dot menu) -----

  Widget _buildCoverWithAvatar(
      BuildContext context, AppColorsExtension colors) {
    const double coverHeight = 180.0;
    const double avatarSize = 88.0;
    const double borderWidth = 4.0;
    const double avatarTotal = avatarSize + borderWidth * 2;
    const double avatarOverlap = avatarTotal / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            SizedBox(
              height: coverHeight + avatarOverlap,
              child: Stack(
                children: [
                  SizedBox(
                    height: coverHeight,
                    width: double.infinity,
                    child: _buildCoverImage(context),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Avatar
        Positioned(
          top: coverHeight - avatarOverlap,
          child: _buildAvatar(colors),
        ),

        // 3-dot menu only (no settings icon for other users)
        Positioned(
          top: MediaQuery.of(context).padding.top,
          right: 0,
          child: PopupMenuButton<_OtherProfileAction>(
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
        ),
      ],
    );
  }

  Widget _buildCoverImage(BuildContext context) {
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

  Widget _buildAvatar(AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.card,
      ),
      child: UserAvatar(
        imageUrl: profile.avatar,
        name: profile.fullName,
        size: 88,
        heroTag: 'avatar_${profile.id}',
      ),
    );
  }

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
              children:
                  profile.languages.map((lang) => _chip(colors, lang)).toList(),
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

// ---------------------------------------------------------------------------
// Shared sub-widgets
// ---------------------------------------------------------------------------

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    this.onTap,
  });

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
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
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.colors,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final AppColorsExtension colors;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final itemColor = destructive ? colors.destructive : colors.foreground;
    final iconBgColor = destructive
        ? colors.destructive.withValues(alpha: 0.1)
        : colors.muted;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                size: 20,
                color: destructive ? colors.destructive : colors.mutedForeground,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: itemColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: destructive
                  ? colors.destructive.withValues(alpha: 0.6)
                  : colors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Popup menu action enum (other user profiles only)
// ---------------------------------------------------------------------------

enum _OtherProfileAction { block, report }
