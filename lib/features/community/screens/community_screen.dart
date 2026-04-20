import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/community/providers/community_provider.dart';
import 'package:skill_exchange/features/community/widgets/create_circle_sheet.dart';
import 'package:skill_exchange/features/community/widgets/create_post_sheet.dart';
import 'package:skill_exchange/features/community/widgets/discussion_card.dart';
import 'package:skill_exchange/features/community/widgets/leaderboard_tile.dart';
import 'package:skill_exchange/core/widgets/animated_list_item.dart';
import 'package:skill_exchange/features/community/widgets/learning_circle_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Rebuild to update FAB visibility based on active tab
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onLikePost(String id) {
    ref.read(communityNotifierProvider.notifier).likePost(id);
  }

  void _onJoinCircle(String id) {
    ref.read(communityNotifierProvider.notifier).joinCircle(id);
  }

  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CreatePostSheet(),
    );
  }

  void _showCreateCircleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CreateCircleSheet(),
    );
  }

  // ── Refresh ───────────────────────────────────────────────────────────────

  Future<void> _refreshDiscussions() async {
    ref.invalidate(discussionPostsProvider);
  }

  Future<void> _refreshCircles() async {
    ref.invalidate(learningCirclesProvider);
  }

  Future<void> _refreshLeaderboard() async {
    ref.invalidate(leaderboardProvider);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Discussions'),
            Tab(text: 'Circles'),
            Tab(text: 'Leaderboard'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscussionsTab(),
          _buildCirclesTab(),
          _buildLeaderboardTab(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  // ── FAB ──────────────────────────────────────────────────────────────────

  Widget? _buildFab() {
    // Only show FAB for Discussions (0) and Circles (1) tabs
    if (_tabController.index == 2) return null;

    final isDiscussions = _tabController.index == 0;

    return FloatingActionButton(
      onPressed: isDiscussions ? _showCreatePostSheet : _showCreateCircleSheet,
      child: const Icon(Icons.add),
    );
  }

  // ── Discussions Tab ─────────────────────────────────────────────────────

  Widget _buildDiscussionsTab() {
    final postsAsync = ref.watch(discussionPostsProvider);

    return postsAsync.when(
      loading: () => _buildLoadingSkeleton(),
      error: (error, _) => Center(
        child: ErrorMessage(
          message: error.toString(),
          onRetry: _refreshDiscussions,
        ),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: EmptyState(
              icon: Icons.forum_outlined,
              title: 'No discussions yet',
              description: 'Start a conversation with the community',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshDiscussions,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: posts.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.listItemGap),
            itemBuilder: (_, index) {
              final post = posts[index];
              final postId = post['id'] as String? ?? '';
              return AnimatedListItem(
                index: index,
                child: DiscussionCard(
                  post: post,
                  onLike: () => _onLikePost(postId),
                  onComment: () => _showCommentsSheet(context, postId),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ── Circles Tab ──────────────────────────────────────────────────────────

  Widget _buildCirclesTab() {
    final circlesAsync = ref.watch(learningCirclesProvider);

    return circlesAsync.when(
      loading: () => _buildLoadingSkeleton(),
      error: (error, _) => Center(
        child: ErrorMessage(
          message: error.toString(),
          onRetry: _refreshCircles,
        ),
      ),
      data: (circles) {
        if (circles.isEmpty) {
          return const Center(
            child: EmptyState(
              icon: Icons.groups_outlined,
              title: 'No learning circles yet',
              description: 'Create a circle to learn together',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshCircles,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: circles.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.listItemGap),
            itemBuilder: (_, index) {
              final circle = circles[index];
              final circleId = circle['id'] as String? ?? '';
              return AnimatedListItem(
                index: index,
                child: LearningCircleCard(
                  circle: circle,
                  onJoin: () => _onJoinCircle(circleId),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ── Leaderboard Tab ─────────────────────────────────────────────────────

  Widget _buildLeaderboardTab() {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return leaderboardAsync.when(
      loading: () => _buildLoadingSkeleton(),
      error: (error, _) => Center(
        child: ErrorMessage(
          message: error.toString(),
          onRetry: _refreshLeaderboard,
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(
            child: EmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'No leaderboard data',
              description: 'Complete sessions to earn points',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshLeaderboard,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: entries.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, index) {
              final entry = entries[index];
              return AnimatedListItem(
                index: index,
                child: LeaderboardTile(entry: entry),
              );
            },
          ),
        );
      },
    );
  }

  void _showCommentsSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _PostCommentsSheet(postId: postId),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 5,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, __) => const SkeletonCard.profile(),
    );
  }
}

// ── Post Comments Bottom Sheet ──────────────────────────────────────────────

class _PostCommentsSheet extends ConsumerStatefulWidget {
  const _PostCommentsSheet({required this.postId});

  final String postId;

  @override
  ConsumerState<_PostCommentsSheet> createState() => _PostCommentsSheetState();
}

class _PostCommentsSheetState extends ConsumerState<_PostCommentsSheet> {
  final _replyController = TextEditingController();
  List<Map<String, dynamic>> _replies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadReplies() async {
    try {
      final service = ref.read(communityFirestoreServiceProvider);
      final replies = await service.getPostReplies(widget.postId);
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

  Future<void> _submitReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    final authorName = user?.displayName ?? 'Anonymous';

    try {
      final service = ref.read(communityFirestoreServiceProvider);
      await service.createReply(widget.postId, {
        'content': text,
        'authorName': authorName,
      });
      _replyController.clear();
      await _loadReplies();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post reply: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Comments', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.md),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_replies.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text('No comments yet. Be the first!'),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _replies.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final reply = _replies[index];
                  return ListTile(
                    dense: true,
                    title: Text(reply['authorName'] ?? 'Anonymous'),
                    subtitle: Text(reply['content'] ?? ''),
                  );
                },
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _replyController,
                  decoration: const InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _submitReply,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
