import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class PendingRequests extends StatelessWidget {
  const PendingRequests({
    super.key,
    required this.requests,
    this.onRespond,
    this.onProfileTap,
  });

  final List<Map<String, dynamic>> requests;
  final Function(String id, bool accept)? onRespond;
  final ValueChanged<String>? onProfileTap;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: EmptyState(
          icon: Icons.inbox_outlined,
          title: 'No pending requests',
          description: 'New connection requests will appear here.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: requests.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, index) => _buildRequestCard(context, requests[index]),
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> request) {
    final String fullName = request['otherUserName'] as String? ?? 'Unknown';
    final String? avatarUrl = request['otherUserAvatar'] as String?;
    final String userId = request['otherUserId'] as String? ?? '';
    final String connectionId = request['id'] as String? ?? '';
    final String? message = request['message'] as String?;
    final String timeSince = _formatTimeAgo(request['createdAt']);

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
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      timeSince,
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (message != null && message.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.mutedForeground,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Decline',
                  onPressed: onRespond != null
                      ? () => onRespond!(connectionId, false)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Accept',
                  onPressed: onRespond != null
                      ? () => onRespond!(connectionId, true)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(dynamic dateValue) {
    if (dateValue == null) return '';
    try {
      DateTime date;
      if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else {
        // Firestore Timestamp
        date = (dateValue as dynamic).toDate() as DateTime;
      }
      return timeago.format(date);
    } catch (_) {
      return '';
    }
  }
}
