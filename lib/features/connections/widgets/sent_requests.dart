import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';

class SentRequests extends StatelessWidget {
  const SentRequests({
    super.key,
    required this.requests,
    this.onProfileTap,
  });

  final List<Map<String, dynamic>> requests;
  final ValueChanged<String>? onProfileTap;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: EmptyState(
          icon: Icons.send_outlined,
          title: 'No sent requests',
          description: 'Requests you send will appear here.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: requests.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, index) => _buildSentCard(context, requests[index]),
    );
  }

  Widget _buildSentCard(BuildContext context, Map<String, dynamic> request) {
    final String fullName = request['otherUserName'] as String? ?? 'Unknown';
    final String? avatarUrl = request['otherUserAvatar'] as String?;
    final String userId = request['otherUserId'] as String? ?? '';
    final String? message = request['message'] as String?;
    final String status = request['status'] as String? ?? 'pending';
    final String sentDate = _formatDate(request['createdAt']);

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
                      'Sent $sentDate',
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(context, status),
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
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final (String label, Color bg, Color fg) = switch (status) {
      'pending' => (
          'Pending',
          context.colors.warning.withValues(alpha: 0.2),
          context.colors.foreground,
        ),
      'accepted' => (
          'Accepted',
          context.colors.success.withValues(alpha: 0.2),
          context.colors.foreground,
        ),
      'rejected' => (
          'Declined',
          context.colors.destructive.withValues(alpha: 0.2),
          context.colors.destructive,
        ),
      _ => (
          'Pending',
          context.colors.warning.withValues(alpha: 0.2),
          context.colors.foreground,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: fg),
      ),
    );
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return '';
    try {
      DateTime date;
      if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else {
        // Firestore Timestamp
        date = (dateValue as dynamic).toDate() as DateTime;
      }
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return '';
    }
  }
}
