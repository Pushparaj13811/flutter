import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/admin_post_model.dart';

class AdminPostTile extends StatelessWidget {
  const AdminPostTile({
    super.key,
    required this.post,
    required this.onPin,
    required this.onHide,
    required this.onDelete,
  });

  final AdminPostModel post;
  final VoidCallback onPin;
  final VoidCallback onHide;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: post.authorAvatar != null
                    ? NetworkImage(post.authorAvatar!)
                    : null,
                child: post.authorAvatar == null
                    ? Text(post.authorName[0])
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: AppTextStyles.labelLarge,
                    ),
                    Text(
                      post.createdAt.substring(0, 10),
                      style: AppTextStyles.caption.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              // Badges
              if (post.isPinned)
                _Badge(
                  icon: Icons.push_pin,
                  label: 'Pinned',
                  color: colors.primary,
                ),
              if (post.isHidden) ...[
                if (post.isPinned) const SizedBox(width: AppSpacing.xs),
                _Badge(
                  icon: Icons.visibility_off,
                  label: 'Hidden',
                  color: colors.destructive,
                ),
              ],
              const SizedBox(width: AppSpacing.xs),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'pin':
                      onPin();
                    case 'hide':
                      onHide();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pin',
                    child: Row(
                      children: [
                        Icon(
                          post.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(post.isPinned ? 'Unpin' : 'Pin'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'hide',
                    child: Row(
                      children: [
                        Icon(
                          post.isHidden ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(post.isHidden ? 'Show' : 'Hide'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: colors.destructive,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Delete',
                          style: TextStyle(color: colors.destructive),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Content preview
          Text(
            post.content,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Skill tag + stats
          Row(
            children: [
              if (post.skillTag.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post.skillTag,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              const Spacer(),
              Icon(Icons.thumb_up_outlined,
                  size: 14, color: colors.mutedForeground),
              const SizedBox(width: 4),
              Text(
                '${post.likesCount}',
                style: AppTextStyles.caption.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.reply, size: 14, color: colors.mutedForeground),
              const SizedBox(width: 4),
              Text(
                '${post.repliesCount}',
                style: AppTextStyles.caption.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
