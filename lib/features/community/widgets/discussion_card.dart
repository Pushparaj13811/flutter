import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class DiscussionCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onTap;

  const DiscussionCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = post['title'] as String? ?? '';
    final content = post['content'] as String? ?? '';
    final tags = (post['tags'] as List?)?.cast<String>() ?? [];
    final isLikedByMe = post['isLikedByMe'] as bool? ?? false;
    final likesCount = (post['likesCount'] as num?)?.toInt() ?? 0;
    final commentsCount = (post['commentsCount'] as num?)?.toInt() ??
        (post['repliesCount'] as num?)?.toInt() ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.h4,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.mutedForeground,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // Media display
            Builder(builder: (context) {
              final images =
                  (post['images'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final videoUrl = post['videoUrl'] as String?;
              final mediaType = post['mediaType'] as String? ?? 'text';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mediaType == 'image' && images.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildImageGallery(context, images),
                  ],
                  if (mediaType == 'video' &&
                      videoUrl != null &&
                      videoUrl.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildVideoPreview(context, videoUrl),
                  ],
                ],
              );
            }),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildTags(context, tags),
            ],
            const SizedBox(height: AppSpacing.md),
            _buildActions(context, isLikedByMe, likesCount, commentsCount),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authorName = post['authorName'] as String? ?? 'Unknown';
    final avatarUrl = post['authorAvatar'] as String?;
    final createdAt = post['createdAt'];

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.colors.muted,
          backgroundImage:
              avatarUrl != null && avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Text(
                  authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: AppTextStyles.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _formatDate(createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(
      BuildContext context, List<Map<String, dynamic>> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.network(
          images[0]['url'] as String? ?? '',
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      );
    }

    // Multiple images — horizontal scroll
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, i) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Image.network(
              images[index]['url'] as String? ?? '',
              width: 200,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 200,
                height: 160,
                color: context.colors.muted,
                child: Icon(Icons.broken_image,
                    color: context.colors.mutedForeground),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoPreview(BuildContext context, String videoUrl) {
    return GestureDetector(
      onTap: () {
        // Video URL can be opened externally if url_launcher is available
      },
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: context.colors.muted,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.play_circle_outline,
                size: 48, color: context.colors.primary),
            Positioned(
              bottom: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Video',
                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context, List<String> tags) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(
            tag,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActions(BuildContext context, bool isLikedByMe, int likesCount, int commentsCount) {
    return Row(
      children: [
        _ActionButton(
          icon: isLikedByMe ? Icons.favorite : Icons.favorite_border,
          label: '$likesCount',
          color: isLikedByMe ? context.colors.destructive : context.colors.mutedForeground,
          onTap: onLike,
        ),
        const SizedBox(width: AppSpacing.lg),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: '$commentsCount',
          color: context.colors.mutedForeground,
          onTap: onComment,
        ),
      ],
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
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
