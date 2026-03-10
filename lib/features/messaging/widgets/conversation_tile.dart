import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    this.onTap,
  });

  final ConversationModel conversation;
  final VoidCallback? onTap;

  bool get _isUnread => conversation.unreadCount > 0;

  /// Returns the first participant profile (the "other" user).
  String get _otherName {
    if (conversation.participantProfiles.isNotEmpty) {
      return conversation.participantProfiles.first.fullName;
    }
    return 'Unknown';
  }

  String? get _otherAvatar {
    if (conversation.participantProfiles.isNotEmpty) {
      return conversation.participantProfiles.first.avatar;
    }
    return null;
  }

  String get _relativeTime {
    final raw = conversation.lastMessageAt;
    if (raw == null || raw.isEmpty) return '';
    final dt = raw.toDateTimeOrNull;
    if (dt == null) return '';
    return dt.relativeShort;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            UserAvatar(
              name: _otherName,
              imageUrl: _otherAvatar,
              size: 48,
              heroTag: 'avatar_${conversation.id}',
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _otherName,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage ?? '',
                          style: _isUnread
                              ? AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.foreground,
                                )
                              : AppTextStyles.bodySmall.copyWith(
                                  color: context.colors.mutedForeground,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
      ),
      child: Text(
        conversation.unreadCount > 99
            ? '99+'
            : '${conversation.unreadCount}',
        style: AppTextStyles.labelSmall.copyWith(
          color: context.colors.primaryForeground,
          fontSize: 10,
        ),
      ),
    );
  }
}
