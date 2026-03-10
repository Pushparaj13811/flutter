import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/notifications/providers/notification_provider.dart';
import 'package:skill_exchange/features/notifications/widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(notificationsProvider);
  }

  void _markAllAsRead(WidgetRef ref) {
    ref.read(notificationNotifierProvider.notifier).markAllAsRead();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => _markAllAsRead(ref),
              child: Text(
                'Mark all read',
                style: TextStyle(color: context.colors.primary),
              ),
            ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => _buildLoadingSkeleton(),
        error: (error, _) => Center(
          child: ErrorMessage(
            message: error.toString(),
            onRetry: () => _refresh(ref),
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView(
                children: const [
                  EmptyState(
                    icon: Icons.notifications_none_outlined,
                    title: 'No notifications',
                    description:
                        'You\'re all caught up! New notifications will appear here.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                indent: AppSpacing.screenPadding + 40 + AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 8,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.message(),
    );
  }
}
