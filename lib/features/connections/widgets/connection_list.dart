import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/core/widgets/animated_list_item.dart';

class ConnectionList extends StatelessWidget {
  const ConnectionList({
    super.key,
    required this.connections,
    this.onMessage,
    this.onBook,
    this.onRemove,
    this.onProfileTap,
  });

  final List<Map<String, dynamic>> connections;
  final ValueChanged<String>? onMessage;
  final ValueChanged<String>? onBook;
  final Function(String id)? onRemove;
  final ValueChanged<String>? onProfileTap;

  @override
  Widget build(BuildContext context) {
    if (connections.isEmpty) {
      return const Center(
        child: EmptyState(
          icon: Icons.people_outline,
          title: 'No connections yet',
          description:
              'Start connecting with others to teach and learn new skills.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: connections.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, index) => AnimatedListItem(
        index: index,
        child: _buildConnectionCard(context, connections[index]),
      ),
    );
  }

  Widget _buildConnectionCard(BuildContext context, Map<String, dynamic> connection) {
    final String fullName = connection['otherUserName'] as String? ?? 'Unknown';
    final String username = connection['otherUsername'] as String? ?? '';
    final String? avatarUrl = connection['otherUserAvatar'] as String?;
    final String userId = connection['otherUserId'] as String? ?? '';
    final String connectionId = connection['id'] as String? ?? '';
    final String connectedDate = _formatDate(connection['createdAt']);

    return AppCard(
      onTap: onProfileTap != null ? () => onProfileTap!(userId) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(
                name: fullName,
                imageUrl: avatarUrl,
                size: 48,
                heroTag: 'avatar_$userId',
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: context.colors.foreground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (username.isNotEmpty)
                      Text(
                        '@$username',
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.mutedForeground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Connected $connectedDate',
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Message',
                  onPressed: onMessage != null
                      ? () => onMessage!(userId)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Book',
                  icon: Icons.calendar_today,
                  onPressed: onBook != null
                      ? () => onBook!(userId)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton.icon(
                icon: Icons.person_remove_outlined,
                tooltip: 'Remove connection',
                onPressed: onRemove != null
                    ? () => _confirmRemove(context, connectionId, fullName)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    String connectionId,
    String fullName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Connection'),
        content: Text(
          'Are you sure you want to remove $fullName from your connections?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.destructive,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onRemove?.call(connectionId);
    }
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return '';
    try {
      if (dateValue is String) {
        final date = DateTime.parse(dateValue);
        return DateFormat.yMMMd().format(date);
      }
      // Firestore Timestamp
      final date = (dateValue as dynamic).toDate() as DateTime;
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return '';
    }
  }
}
