import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/community/providers/community_provider.dart';
import 'package:skill_exchange/features/community/widgets/create_post_sheet.dart';
import 'package:skill_exchange/features/community/widgets/discussion_card.dart';

class CircleDetailScreen extends ConsumerStatefulWidget {
  final String circleId;

  const CircleDetailScreen({super.key, required this.circleId});

  @override
  ConsumerState<CircleDetailScreen> createState() => _CircleDetailScreenState();
}

class _CircleDetailScreenState extends ConsumerState<CircleDetailScreen> {
  Map<String, dynamic>? _circle;
  List<Map<String, dynamic>> _posts = [];
  bool _loadingCircle = true;
  bool _loadingPosts = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadCircle(), _loadPosts()]);
  }

  Future<void> _loadCircle() async {
    try {
      final service = ref.read(communityFirestoreServiceProvider);
      final circle = await service.getCircleById(widget.circleId);
      if (mounted) {
        setState(() {
          _circle = circle;
          _loadingCircle = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loadingCircle = false;
        });
      }
    }
  }

  Future<void> _loadPosts() async {
    try {
      final service = ref.read(communityFirestoreServiceProvider);
      final posts = await service.getCirclePosts(widget.circleId);
      final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (mounted) {
        setState(() {
          _posts = posts.map((d) {
            final likedBy = (d['likedBy'] as List?)?.cast<String>() ?? [];
            return {
              ...d,
              'isLikedByMe': likedBy.contains(currentUid),
              'likesCount': (d['likesCount'] as num?)?.toInt() ?? 0,
              'commentsCount': (d['repliesCount'] as num?)?.toInt() ??
                  (d['commentsCount'] as num?)?.toInt() ??
                  0,
            };
          }).toList();
          _loadingPosts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingPosts = false;
        });
      }
    }
  }

  Future<void> _onJoinOrLeave() async {
    if (_circle == null) return;
    final members = (_circle!['members'] as List?)?.cast<String>() ?? [];
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isMember = members.contains(currentUid);

    final notifier = ref.read(communityNotifierProvider.notifier);
    if (isMember) {
      await notifier.leaveCircle(widget.circleId);
    } else {
      await notifier.joinCircle(widget.circleId);
    }
    await _loadCircle();
  }

  void _onLikePost(String id) {
    ref.read(communityNotifierProvider.notifier).likePost(id);
    _loadPosts();
  }

  void _navigateToCreatePost() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(
          circleId: widget.circleId,
          circleName: _circle?['name'] as String?,
        ),
      ),
    );
    if (result == true) {
      _loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCircle) {
      return Scaffold(
        appBar: AppBar(title: const Text('Circle')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Circle')),
        body: Center(
          child: ErrorMessage(
            message: _error!,
            onRetry: _loadData,
          ),
        ),
      );
    }

    final circle = _circle!;
    final name = circle['name'] as String? ?? 'Circle';
    final description = circle['description'] as String? ?? '';
    final category = circle['category'] as String? ?? '';
    final members = (circle['members'] as List?)?.cast<String>() ?? [];
    final maxMembers = (circle['maxMembers'] as num?)?.toInt() ?? 50;
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isMember = members.contains(currentUid);
    final isFull = members.length >= maxMembers;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            // Circle info card
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description.isNotEmpty) ...[
                    Text(
                      description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (category.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.category_outlined,
                            size: 16, color: context.colors.mutedForeground),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Category: $category',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 16, color: context.colors.mutedForeground),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Members: ${members.length}/$maxMembers',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: isMember
                        ? OutlinedButton(
                            onPressed: _onJoinOrLeave,
                            child: const Text('Leave Circle'),
                          )
                        : FilledButton(
                            onPressed: isFull ? null : _onJoinOrLeave,
                            child:
                                Text(isFull ? 'Circle is Full' : 'Join Circle'),
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Posts section header
            Text('Posts', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),

            // Posts list
            if (_loadingPosts)
              ...List.generate(3, (_) => const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.listItemGap),
                child: SkeletonCard.profile(),
              ))
            else if (_posts.isEmpty)
              const EmptyState(
                icon: Icons.forum_outlined,
                title: 'No posts yet',
                description: 'Be the first to post in this circle',
              )
            else
              ...List.generate(_posts.length, (index) {
                final post = _posts[index];
                final postId = post['id'] as String? ?? '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.listItemGap),
                  child: DiscussionCard(
                    post: post,
                    onLike: () => _onLikePost(postId),
                  ),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: isMember
          ? FloatingActionButton(
              onPressed: _navigateToCreatePost,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
