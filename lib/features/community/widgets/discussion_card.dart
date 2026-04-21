import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_shadows.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:video_player/video_player.dart';

/// Social-media style post card with avatar header, image carousel,
/// category badge, tags, and engagement actions.
class DiscussionCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final bool isCompact;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const DiscussionCard({
    super.key,
    required this.post,
    this.isCompact = true,
    this.onLike,
    this.onComment,
    this.onBookmark,
    this.onShare,
    this.onTap,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final title = post['title'] as String? ?? '';
    final content = post['content'] as String? ?? '';
    final tags = (post['tags'] as List?)?.cast<String>() ?? [];
    final category = post['category'] as String? ?? '';
    final isLikedByMe = post['isLikedByMe'] as bool? ?? false;
    final isBookmarked = post['isBookmarked'] as bool? ?? false;
    final likesCount = (post['likesCount'] as num?)?.toInt() ?? 0;
    final commentsCount = (post['commentsCount'] as num?)?.toInt() ??
        (post['repliesCount'] as num?)?.toInt() ??
        0;
    final images =
        (post['images'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final videoUrl = post['videoUrl'] as String?;

    // Build combined media list
    final allMedia = <Map<String, dynamic>>[];
    for (final img in images) {
      final url = img['url'] as String? ?? '';
      if (url.isNotEmpty) {
        allMedia.add({'type': 'image', 'url': url});
      }
    }
    if (videoUrl != null && videoUrl.isNotEmpty) {
      allMedia.add({'type': 'video', 'url': videoUrl});
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with padding
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildHeader(context),
            ),

            // Category + Title + Content with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Category badge
                  if (category.isNotEmpty) ...[
                    _buildCategoryBadge(context, category),
                    const SizedBox(height: 10),
                  ],

                  // Title
                  if (title.isNotEmpty) ...[
                    Text(
                      title,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: isCompact ? 2 : null,
                      overflow: isCompact ? TextOverflow.ellipsis : null,
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Content
                  if (content.isNotEmpty) _buildContent(context, content),
                ],
              ),
            ),

            // Media — FULL BLEED, no horizontal padding
            if (allMedia.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _PostMediaSection(media: allMedia),
              ),

            // Tags + Actions with padding
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  if (tags.isNotEmpty) ...[
                    _buildTags(context, tags),
                    const SizedBox(height: 12),
                  ],

                  // Divider before actions
                  Divider(color: context.colors.border, height: 1),
                  const SizedBox(height: 8),

                  // Actions bar
                  _buildActions(context, isLikedByMe, isBookmarked, likesCount,
                      commentsCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authorName = post['authorName'] as String? ?? 'Unknown';
    final authorHandle = post['authorHandle'] as String?;
    final avatarUrl = post['authorAvatar'] as String?;
    final createdAt = post['createdAt'];

    return Row(
      children: [
        // Avatar with border ring
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: context.colors.muted,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl == null || avatarUrl.isEmpty
                ? Text(
                    authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: context.colors.mutedForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  if (authorHandle != null && authorHandle.isNotEmpty) ...[
                    Text(
                      '@$authorHandle',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.mutedForeground,
                      ),
                    ),
                    Text(
                      ' \u00B7 ',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.mutedForeground,
                      ),
                    ),
                  ],
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_horiz,
              color: context.colors.mutedForeground, size: 20),
          onSelected: (value) {
            if (value == 'delete') {
              showDialog<bool>(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text('Delete Post'),
                  content: const Text(
                      'Are you sure you want to delete this post?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(false),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(true),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ).then((confirmed) {
                if (confirmed == true) onDelete?.call();
              });
            } else if (value == 'report') {
              onReport?.call();
            }
          },
          itemBuilder: (_) {
            final isOwner =
                post['author'] == FirebaseAuth.instance.currentUser?.uid;
            return [
              if (isOwner)
                const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ])),
              if (!isOwner)
                const PopupMenuItem(
                    value: 'report',
                    child: Row(children: [
                      Icon(Icons.flag_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Report'),
                    ])),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildCategoryBadge(BuildContext context, String category) {
    final color = _categoryColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        category,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String content) {
    if (!isCompact) {
      return Text(
        content,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: context.colors.foreground,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: content,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: context.colors.foreground,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 4,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: context.colors.foreground,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            if (isOverflowing) ...[
              const SizedBox(height: 4),
              Text(
                'Read more',
                style: TextStyle(
                  fontSize: 13,
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTags(BuildContext context, List<String> tags) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: tags.map((tag) {
        final displayTag = tag.startsWith('#') ? tag : '#$tag';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(
            displayTag,
            style: TextStyle(
              fontSize: 10,
              color: context.colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActions(BuildContext context, bool isLikedByMe,
      bool isBookmarked, int likesCount, int commentsCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Like
        _ActionButton(
          icon: isLikedByMe ? Icons.favorite : Icons.favorite_border,
          label: likesCount > 0 ? '$likesCount' : '',
          color: isLikedByMe
              ? const Color(0xFFEF4444)
              : context.colors.mutedForeground,
          onTap: onLike,
        ),
        // Comment
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: commentsCount > 0 ? '$commentsCount' : '',
          color: context.colors.mutedForeground,
          onTap: onComment,
        ),
        // Share
        _ActionButton(
          icon: Icons.share_outlined,
          label: '',
          color: context.colors.mutedForeground,
          onTap: onShare,
        ),
        // Bookmark
        _ActionButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: '',
          color: isBookmarked
              ? context.colors.primary
              : context.colors.mutedForeground,
          onTap: onBookmark,
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
        date = (dateValue as dynamic).toDate() as DateTime;
      }
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      if (diff.inDays < 7) return '${diff.inDays}d';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  static Color _categoryColor(String category) {
    return switch (category.toLowerCase()) {
      'announcements' => const Color(0xFF059669),
      'teaching tips' => const Color(0xFF2563EB),
      'learning resources' => const Color(0xFF8B5CF6),
      'exchange requests' => const Color(0xFFF59E0B),
      'discussion' => const Color(0xFF6B7280),
      'success stories' => const Color(0xFFEC4899),
      _ => const Color(0xFF6B7280),
    };
  }
}

// ── Instagram-style Post Media Section ───────────────────────────────────────

class _PostMediaSection extends StatefulWidget {
  final List<Map<String, dynamic>> media;

  const _PostMediaSection({required this.media});

  @override
  State<_PostMediaSection> createState() => _PostMediaSectionState();
}

class _PostMediaSectionState extends State<_PostMediaSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox.shrink();

    if (widget.media.length == 1) {
      return _buildSingleMedia(widget.media[0]);
    }

    return _buildCarousel();
  }

  Widget _buildSingleMedia(Map<String, dynamic> item) {
    if (item['type'] == 'video') {
      return _InlineVideoPlayer(url: item['url'] as String);
    }
    return _buildImage(item['url'] as String);
  }

  Widget _buildImage(String url) {
    return Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 300,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: Icon(Icons.broken_image, size: 40)),
        ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 4 / 5, // Portrait like Instagram (taller than wide)
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.media.length,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  itemBuilder: (_, index) {
                    final item = widget.media[index];
                    if (item['type'] == 'video') {
                      return _InlineVideoPlayer(url: item['url'] as String);
                    }
                    return Image.network(
                      item['url'] as String,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: const Center(
                            child: Icon(Icons.broken_image, size: 40)),
                      ),
                    );
                  },
                ),
              ),
            // Counter badge "1/4" top right
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPage + 1}/${widget.media.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Dots indicator
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.media.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentPage ? 7 : 5,
                height: i == _currentPage ? 7 : 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _currentPage
                      ? context.colors.primary
                      : context.colors.mutedForeground.withValues(alpha: 0.3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ── Inline Video Player ──────────────────────────────────────────────────────

class _InlineVideoPlayer extends StatefulWidget {
  final String url;
  const _InlineVideoPlayer({required this.url});

  @override
  State<_InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<_InlineVideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    try {
      await _controller.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
        showControls: true,
        aspectRatio: _controller.value.aspectRatio,
      );
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 250,
        color: context.colors.muted,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 40, color: context.colors.mutedForeground),
              const SizedBox(height: 8),
              Text(
                'Failed to load video',
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: 250,
        color: context.colors.muted,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}

// ── Action Button ────────────────────────────────────────────────────────────

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
          horizontal: 8,
          vertical: 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
