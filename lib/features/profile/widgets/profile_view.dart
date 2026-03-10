// Profile display widget — modern card-based layout
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
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
  });

  final UserProfileModel profile;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Hero header ────────────────────────────────────────────
          _buildHeroHeader(context, colors),

          // ── Content sections ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),

                // Stats
                _buildStatsCard(context, colors),
                const SizedBox(height: AppSpacing.lg),

                // About
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  _buildAboutCard(context, colors),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Skills to Teach
                if (profile.skillsToTeach.isNotEmpty) ...[
                  _buildSkillsCard(
                    context,
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
                  _buildSkillsCard(
                    context,
                    colors,
                    title: 'Skills to Learn',
                    icon: Icons.auto_stories_outlined,
                    iconColor: colors.primary,
                    skills: profile.skillsToLearn,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Languages & Interests
                if (profile.languages.isNotEmpty ||
                    profile.interests.isNotEmpty) ...[
                  _buildDetailsCard(context, colors),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Availability
                _buildAvailabilityCard(context, colors),
                const SizedBox(height: AppSpacing.lg),

                // Footer — Learning style + Member since
                _buildFooterCard(context, colors),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero header with gradient background ────────────────────────────────

  Widget _buildHeroHeader(BuildContext context, AppColorsExtension colors) {
    const double bannerHeight = 120;
    const double avatarSize = 88;
    const double avatarBorderWidth = 4;
    const double avatarTotal = avatarSize + avatarBorderWidth * 2;
    const double avatarOverlap = avatarTotal / 2;
    // Card padding clears the avatar bottom half + small gap
    const double cardTopPadding = avatarOverlap + AppSpacing.sm;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Gradient banner
        Container(
          width: double.infinity,
          height: bannerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primary,
                colors.secondary,
              ],
            ),
          ),
        ),

        // Profile info card — starts at banner bottom
        Padding(
          padding: const EdgeInsets.only(top: bannerHeight),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            // ignore: prefer_const_constructors
            padding: EdgeInsets.only(
              top: cardTopPadding,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: colors.foreground.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  profile.fullName,
                  style: AppTextStyles.h2.copyWith(
                    color: colors.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '@${profile.username}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                if (profile.location != null &&
                    profile.location!.isNotEmpty) ...[
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
                const SizedBox(height: AppSpacing.md),
                // Rating inline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StarRating(
                      rating: profile.stats.averageRating,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      profile.stats.averageRating.toStringAsFixed(1),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Avatar centered on the banner/card boundary
        Positioned(
          top: bannerHeight - avatarOverlap,
          child: Container(
            padding: const EdgeInsets.all(avatarBorderWidth),
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
          ),
        ),
      ],
    );
  }

  // ── Stats card ──────────────────────────────────────────────────────────

  Widget _buildStatsCard(BuildContext context, AppColorsExtension colors) {
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
            icon: Icons.people_outline,
            value: Formatters.number(profile.stats.connectionsCount),
            label: 'Connections',
            iconColor: colors.primary,
          ),
          _verticalDivider(colors),
          _buildStatItem(
            colors,
            icon: Icons.school_outlined,
            value: Formatters.number(profile.stats.sessionsCompleted),
            label: 'Sessions',
            iconColor: colors.success,
          ),
          _verticalDivider(colors),
          _buildStatItem(
            colors,
            icon: Icons.rate_review_outlined,
            value: Formatters.number(profile.stats.reviewsReceived),
            label: 'Reviews',
            iconColor: colors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    AppColorsExtension colors, {
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider(AppColorsExtension colors) {
    return Container(
      width: 1,
      height: 40,
      color: colors.border.withValues(alpha: 0.5),
    );
  }

  // ── About card ──────────────────────────────────────────────────────────

  Widget _buildAboutCard(BuildContext context, AppColorsExtension colors) {
    return _sectionCard(
      colors,
      icon: Icons.person_outline,
      title: 'About',
      child: Text(
        profile.bio!,
        style: AppTextStyles.bodyMedium.copyWith(
          color: colors.foreground,
          height: 1.5,
        ),
      ),
    );
  }

  // ── Skills card ─────────────────────────────────────────────────────────

  Widget _buildSkillsCard(
    BuildContext context,
    AppColorsExtension colors, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<SkillModel> skills,
  }) {
    return _sectionCard(
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

  // ── Details card (Languages + Interests) ────────────────────────────────

  Widget _buildDetailsCard(BuildContext context, AppColorsExtension colors) {
    return _sectionCard(
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

  // ── Availability card ───────────────────────────────────────────────────

  Widget _buildAvailabilityCard(
      BuildContext context, AppColorsExtension colors) {
    return _sectionCard(
      colors,
      icon: Icons.calendar_today_outlined,
      title: 'Availability',
      child: AvailabilityGrid(
        availability: profile.availability,
        readOnly: true,
      ),
    );
  }

  // ── Footer card (learning style + joined date) ──────────────────────────

  Widget _buildFooterCard(BuildContext context, AppColorsExtension colors) {
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

  // ── Shared section card wrapper ─────────────────────────────────────────

  Widget _sectionCard(
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
