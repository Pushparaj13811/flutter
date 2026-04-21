import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/community/widgets/discussion_card.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  List<Map<String, dynamic>> _replies = [];
  bool _loading = true;
  bool _submitting = false;
  String? _replyingToName;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadReplies() async {
    final postId = widget.post['id'] as String?;
    if (postId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final service = ref.read(communityFirestoreServiceProvider);
      final replies = await service.getPostReplies(postId);
      if (mounted) {
        setState(() {
          _replies = replies;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startReply(String authorName) {
    setState(() => _replyingToName = authorName);
    _commentController.text = '@$authorName ';
    _commentFocusNode.requestFocus();
    // Move cursor to end
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _commentController.text.length),
    );
  }

  void _cancelReply() {
    setState(() => _replyingToName = null);
    _commentController.clear();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final postId = widget.post['id'] as String?;
    if (postId == null) return;

    setState(() => _submitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String authorName = 'Anonymous';
    String? authorAvatar;

    // Fetch user profile for name and avatar
    if (uid.isNotEmpty) {
      try {
        final profileDoc = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(uid)
            .get();
        final profile = profileDoc.data() ?? {};
        authorName =
            profile['fullName'] as String? ??
            profile['username'] as String? ??
            'Anonymous';
        authorAvatar = profile['avatar'] as String?;
      } catch (_) {
        // Fall back to FirebaseAuth display name
        final user = FirebaseAuth.instance.currentUser;
        authorName = user?.displayName ?? 'Anonymous';
        authorAvatar = user?.photoURL;
      }
    }

    try {
      final service = ref.read(communityFirestoreServiceProvider);
      await service.createReply(postId, {
        'content': text,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
      });
      _commentController.clear();
      setState(() => _replyingToName = null);
      await _loadReplies();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.post['title'] as String? ?? 'Post';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadReplies,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  // Full post card
                  DiscussionCard(
                    post: widget.post,
                    isCompact: false,
                    onLike: () {
                      final postId = widget.post['id'] as String?;
                      if (postId == null) return;
                      final service =
                          ref.read(communityFirestoreServiceProvider);
                      service.likePost(postId);
                    },
                    onComment: () {
                      _commentFocusNode.requestFocus();
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Comments header
                  Text(
                    'Comments',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Comments list
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_replies.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(
                        child: Text(
                          'No comments yet. Be the first!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.mutedForeground,
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(_replies.length, (index) {
                      return _CommentTile(
                        reply: _replies[index],
                        onReply: _startReply,
                      );
                    }),
                ],
              ),
            ),
          ),

          // Comment input pinned to bottom
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(
          top: BorderSide(color: context.colors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replying-to indicator
            if (_replyingToName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 14,
                        color: context.colors.mutedForeground),
                    const SizedBox(width: 4),
                    Text(
                      'Replying to @$_replyingToName',
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _cancelReply,
                      child: Icon(Icons.close, size: 16,
                          color: context.colors.mutedForeground),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: context.colors.mutedForeground,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.send, color: context.colors.primary),
                  onPressed: _submitting ? null : _submitComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Comment Tile ─────────────────────────────────────────────────────────────

class _CommentTile extends StatelessWidget {
  final Map<String, dynamic> reply;
  final void Function(String authorName) onReply;

  const _CommentTile({required this.reply, required this.onReply});

  @override
  Widget build(BuildContext context) {
    final authorName = reply['authorName'] as String? ?? 'Anonymous';
    final content = reply['content'] as String? ?? '';
    final avatarUrl = reply['authorAvatar'] as String?;
    final createdAt = reply['createdAt'];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: context.colors.muted,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl == null || avatarUrl.isEmpty
                ? Text(
                    authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                    style: AppTextStyles.caption.copyWith(
                      color: context.colors.mutedForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.colors.muted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            authorName,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (createdAt != null) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              _formatTimeAgo(createdAt),
                              style: AppTextStyles.caption.copyWith(
                                color: context.colors.mutedForeground,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        content,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // Reply button
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: GestureDetector(
                    onTap: () => onReply(authorName),
                    child: Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.mutedForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(dynamic dateValue) {
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
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}
