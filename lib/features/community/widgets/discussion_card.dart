import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';

class DiscussionCard extends StatelessWidget {
  final DiscussionPostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onTap;

  const DiscussionCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSpacing.sm),
            Text(
              post.title,
              style: AppTextStyles.h4,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              post.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.mutedForeground,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildTags(context),
            ],
            const SizedBox(height: AppSpacing.md),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authorName = post.author?.fullName ?? 'Unknown';
    final avatarUrl = post.author?.avatar;

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.colors.muted,
          backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl) : null,
          child: avatarUrl == null
              ? Text(
                  authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: AppTextStyles.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _formatDate(post.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: post.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(
            tag,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
          label: '${post.likesCount}',
          color: post.isLikedByMe ? context.colors.destructive : context.colors.mutedForeground,
          onTap: onLike,
        ),
        const SizedBox(width: AppSpacing.lg),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: '${post.commentsCount}',
          color: context.colors.mutedForeground,
          onTap: onComment,
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
