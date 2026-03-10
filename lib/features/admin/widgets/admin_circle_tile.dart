import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/admin_circle_model.dart';

class AdminCircleTile extends StatelessWidget {
  const AdminCircleTile({
    super.key,
    required this.circle,
    required this.onFeature,
    required this.onDelete,
  });

  final AdminCircleModel circle;
  final VoidCallback onFeature;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      child: Row(
        children: [
          // Circle avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: colors.primary.withValues(alpha: 0.1),
            backgroundImage: circle.imageUrl != null
                ? NetworkImage(circle.imageUrl!)
                : null,
            child: circle.imageUrl == null
                ? Icon(Icons.groups, color: colors.primary)
                : null,
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        circle.name,
                        style: AppTextStyles.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (circle.isFeatured) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Icon(Icons.star, size: 16, color: colors.warning),
                    ],
                    if (!circle.isActive) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.mutedForeground.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Inactive',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.mutedForeground,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  circle.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${circle.memberCount} members',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'feature':
                  onFeature();
                case 'delete':
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'feature',
                child: Row(
                  children: [
                    Icon(
                      circle.isFeatured ? Icons.star : Icons.star_outline,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(circle.isFeatured ? 'Unfeature' : 'Feature'),
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
    );
  }
}
