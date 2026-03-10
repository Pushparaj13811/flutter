import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/user_report_model.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    this.onResolve,
    this.onDismiss,
    this.onDeleteContent,
  });

  final UserReportModel report;
  final VoidCallback? onResolve;
  final VoidCallback? onDismiss;
  final VoidCallback? onDeleteContent;

  Color _statusColor(BuildContext context, String status) {
    return switch (status) {
      'pending' => context.colors.warning,
      'resolved' => context.colors.success,
      'dismissed' => context.colors.mutedForeground,
      _ => context.colors.mutedForeground,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'pending' => Icons.schedule,
      'resolved' => Icons.check_circle_outline,
      'dismissed' => Icons.cancel_outlined,
      _ => Icons.help_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context, report.status);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: status badge + date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _statusIcon(report.status),
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      report.status[0].toUpperCase() +
                          report.status.substring(1),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Date
              Text(
                _formatDate(report.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Reported user
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: context.colors.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Reported User: ',
                style: AppTextStyles.labelMedium.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
              Expanded(
                child: Text(
                  report.reportedUserId,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.foreground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Reporter
          if (report.reporterName != null) ...[
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 16,
                  color: context.colors.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Reporter: ',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                ),
                Expanded(
                  child: Text(
                    report.reporterName!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.foreground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Reason
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.report_outlined,
                size: 16,
                color: context.colors.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Reason: ',
                style: AppTextStyles.labelMedium.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
              Expanded(
                child: Text(
                  report.reason,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.foreground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Description
          Text(
            report.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.mutedForeground,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Reviewed info
          if (report.reviewedAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Reviewed: ${_formatDate(report.reviewedAt!)}${report.reviewedBy != null ? ' by ${report.reviewedBy}' : ''}',
              style: AppTextStyles.caption.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
          ],

          // Action buttons (only for pending reports)
          if (report.status == 'pending') ...[
            const SizedBox(height: AppSpacing.md),
            Divider(height: 1, color: context.colors.border),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDismiss,
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Dismiss'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.mutedForeground,
                      side: BorderSide(color: context.colors.border),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDeleteContent,
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.destructive,
                      side: BorderSide(color: context.colors.destructive),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onResolve,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Resolve'),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.success,
                      foregroundColor: context.colors.primaryForeground,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      }
      if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}
