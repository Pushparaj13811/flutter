import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/admin_skill_model.dart';

class AdminSkillTile extends StatelessWidget {
  const AdminSkillTile({
    super.key,
    required this.skill,
    required this.onToggleActive,
    required this.onDelete,
  });

  final AdminSkillModel skill;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(skill.name, style: AppTextStyles.labelLarge),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill.category,
                        style: AppTextStyles.caption.copyWith(
                          color: colors.secondary,
                        ),
                      ),
                    ),
                    if (!skill.isActive) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.destructive.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Inactive',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.destructive,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${skill.usageCount} users',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'toggle':
                  onToggleActive();
                case 'delete':
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      skill.isActive
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(skill.isActive ? 'Deactivate' : 'Activate'),
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
