import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/announcement_model.dart';

class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({
    super.key,
    required this.announcement,
    required this.onDelete,
  });

  final AnnouncementModel announcement;
  final VoidCallback onDelete;

  Color _priorityColor(BuildContext context) {
    final colors = context.colors;
    switch (announcement.priority) {
      case AnnouncementPriority.info:
        return colors.primary;
      case AnnouncementPriority.warning:
        return colors.warning;
      case AnnouncementPriority.critical:
        return colors.destructive;
    }
  }

  IconData _priorityIcon() {
    switch (announcement.priority) {
      case AnnouncementPriority.info:
        return Icons.info_outline;
      case AnnouncementPriority.warning:
        return Icons.warning_amber;
      case AnnouncementPriority.critical:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pColor = _priorityColor(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_priorityIcon(), color: pColor, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  announcement.title,
                  style: AppTextStyles.labelLarge,
                ),
              ),
              if (!announcement.isActive)
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
                    'Expired',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.mutedForeground,
                      fontSize: 10,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: colors.destructive,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            announcement.body,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.mutedForeground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: pColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  announcement.priority.name.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: pColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Created ${announcement.createdAt.substring(0, 10)}',
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
