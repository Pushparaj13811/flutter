import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/data/models/activity_log_model.dart';

class ActivityLogTile extends StatelessWidget {
  const ActivityLogTile({super.key, required this.log});

  final ActivityLogModel log;

  IconData _actionIcon() {
    switch (log.action) {
      case 'ban_user':
        return Icons.block;
      case 'unban_user':
        return Icons.check_circle_outline;
      case 'resolve_report':
        return Icons.gavel;
      case 'hide_post':
        return Icons.visibility_off;
      case 'pin_post':
        return Icons.push_pin;
      case 'delete_post':
        return Icons.delete;
      case 'feature_circle':
        return Icons.star;
      case 'update_circle':
        return Icons.edit;
      case 'create_skill':
        return Icons.add_circle_outline;
      case 'delete_skill':
        return Icons.remove_circle_outline;
      case 'create_announcement':
        return Icons.campaign;
      case 'delete_announcement':
        return Icons.campaign_outlined;
      default:
        return Icons.history;
    }
  }

  Color _actionColor(BuildContext context) {
    final colors = context.colors;
    if (log.action.startsWith('delete') || log.action == 'ban_user') {
      return colors.destructive;
    }
    if (log.action.startsWith('create') || log.action == 'unban_user') {
      return colors.success;
    }
    return colors.primary;
  }

  String _formatAction() {
    return log.action.replaceAll('_', ' ').toUpperCase();
  }

  String _relativeTime() {
    try {
      final dt = DateTime.parse(log.timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return log.timestamp.substring(0, 10);
    } catch (_) {
      return log.timestamp.substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = _actionColor(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colors.border,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_actionIcon(), size: 16, color: color),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          _formatAction(),
                          style: AppTextStyles.caption.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _relativeTime(),
                          style: AppTextStyles.caption.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log.details,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'by ${log.adminName} · ${log.targetType}:${log.targetId}',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
