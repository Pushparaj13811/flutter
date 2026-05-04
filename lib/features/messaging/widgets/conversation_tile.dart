import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    this.onTap,
    this.onDelete,
  });

  final Map<String, dynamic> conversation;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  bool get _isUnread => (conversation['unreadCount'] as int? ?? 0) > 0;
  int get _unreadCount => conversation['unreadCount'] as int? ?? 0;

  String get _otherName {
    return conversation['otherUserName'] as String? ?? 'Unknown';
  }

  String? get _otherAvatar {
    return conversation['otherUserAvatar'] as String?;
  }

  String get _otherUserId {
    return conversation['otherUserId'] as String? ?? '';
  }

  String get _relativeTime {
    final raw = conversation['lastMessageAt'] as String?;
    if (raw == null || raw.isEmpty) return '';
    final dt = raw.toDateTimeOrNull;
    if (dt == null) return '';
    return dt.relativeShort;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final id = conversation['id'] as String? ?? '';

    return InkWell(
      onTap: onTap,
      onLongPress: onDelete != null
          ? () {
              showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Chat'),
                  content: Text('Delete conversation with $_otherName? This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ).then((confirmed) {
                if (confirmed == true) onDelete!();
              });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 48px avatar with live online indicator
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _otherUserId.isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('presence')
                      .doc(_otherUserId)
                      .snapshots()
                  : const Stream.empty(),
              builder: (context, presenceSnap) {
                final isOnline =
                    presenceSnap.data?.data()?['isOnline'] == true;
                return UserAvatar(
                  name: _otherName,
                  imageUrl: _otherAvatar,
                  size: 48,
                  heroTag: 'avatar_$id',
                  showOnlineIndicator: isOnline,
                );
              },
            ),
            const SizedBox(width: AppSpacing.md),
            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          _otherName,
                          style: _isUnread
                              ? AppTextStyles.labelLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                )
                              : AppTextStyles.labelLarge.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _relativeTime,
                        style: AppTextStyles.caption.copyWith(
                          color: _isUnread
                              ? colors.primary
                              : colors.mutedForeground,
                          fontWeight: _isUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Message preview row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation['lastMessage'] as String? ?? '',
                          style: _isUnread
                              ? AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.foreground,
                                )
                              : AppTextStyles.bodySmall.copyWith(
                                  color: colors.mutedForeground,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isUnread) ...[
                        const SizedBox(width: AppSpacing.sm),
                        _buildUnreadBadge(context),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _unreadCount > 99 ? '99+' : '$_unreadCount',
        style: AppTextStyles.caption.copyWith(
          color: colors.primaryForeground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
