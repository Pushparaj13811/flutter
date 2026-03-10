import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/data/models/notification_model.dart';
import 'package:skill_exchange/features/notifications/providers/notification_provider.dart';

class NotificationTile extends ConsumerWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback? onTap;

  bool get _isUnread => !notification.read;

  String get _relativeTime {
    final dt = notification.createdAt.toDateTimeOrNull;
    if (dt == null) return '';
    return dt.relative;
  }

  IconData get _icon {
    return switch (notification.type) {
      NotificationType.connectionRequest => Icons.person_add_outlined,
      NotificationType.connectionAccepted => Icons.people_outlined,
      NotificationType.sessionReminder => Icons.schedule_outlined,
      NotificationType.sessionCancelled => Icons.event_busy_outlined,
      NotificationType.newMessage => Icons.chat_bubble_outline,
      NotificationType.reviewReceived => Icons.star_outline,
      NotificationType.system => Icons.info_outline,
    };
  }

  Color _iconColor(BuildContext context) {
    return switch (notification.type) {
      NotificationType.connectionRequest => context.colors.primary,
      NotificationType.connectionAccepted => context.colors.success,
      NotificationType.sessionReminder => context.colors.warning,
      NotificationType.sessionCancelled => context.colors.destructive,
      NotificationType.newMessage => context.colors.primary,
      NotificationType.reviewReceived => context.colors.starFilled,
      NotificationType.system => context.colors.info,
    };
  }

  Color _iconBackgroundColor(BuildContext context) {
    return _iconColor(context).withValues(alpha: 0.1);
  }

  void _handleTap(WidgetRef ref) {
    if (_isUnread) {
      ref
          .read(notificationNotifierProvider.notifier)
          .markAsRead(notification.id);
    }
    onTap?.call();
  }

  void _handleDismiss(WidgetRef ref) {
    ref
        .read(notificationNotifierProvider.notifier)
        .deleteNotification(notification.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _handleDismiss(ref),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        color: context.colors.destructive,
        child: Icon(
          Icons.delete_outline,
          color: context.colors.destructiveForeground,
        ),
      ),
      child: InkWell(
        onTap: () => _handleTap(ref),
        child: Container(
          color: _isUnread
              ? context.colors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconBadge(context),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: _isUnread
                                ? AppTextStyles.labelLarge
                                    .copyWith(fontWeight: FontWeight.w700)
                                : AppTextStyles.labelLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _relativeTime,
                          style: AppTextStyles.caption.copyWith(
                            color: _isUnread
                                ? context.colors.primary
                                : context.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      notification.message,
                      style: _isUnread
                          ? AppTextStyles.bodySmall.copyWith(
                              color: context.colors.foreground,
                            )
                          : AppTextStyles.bodySmall.copyWith(
                              color: context.colors.mutedForeground,
                            ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_isUnread) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _iconBackgroundColor(context),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _icon,
        size: 20,
        color: _iconColor(context),
      ),
    );
  }
}
