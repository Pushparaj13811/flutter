import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/notifications/providers/notification_provider.dart';

class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadCountProvider);

    if (count == 0) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: context.colors.destructive,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : '$count',
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.colors.destructiveForeground,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
