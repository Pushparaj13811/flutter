import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/connection_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PendingRequests extends StatelessWidget {
  const PendingRequests({
    super.key,
    required this.requests,
    this.onRespond,
    this.onProfileTap,
  });

  final List<ConnectionModel> requests;
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
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, index) => _buildRequestCard(context, requests[index]),
    );
  }

  Widget _buildRequestCard(BuildContext context, ConnectionModel request) {
    final profile = request.fromUser;
    final String fullName = profile?.fullName ?? 'Unknown';
    final String? avatarUrl = profile?.avatar;
    final String userId = profile?.id ?? request.fromUserId;
    final String timeSince = _formatTimeAgo(request.createdAt);

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
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Text(
                request.message!,
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
                      ? () => onRespond!(request.id, false)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Accept',
                  onPressed: onRespond != null
                      ? () => onRespond!(request.id, true)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return timeago.format(date);
    } catch (_) {
      return isoDate;
    }
  }
}
