import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/admin_circle_tile.dart';
import 'package:skill_exchange/features/admin/widgets/admin_post_tile.dart';

class CommunityManagementScreen extends ConsumerWidget {
  const CommunityManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Circles'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(adminPostsProvider);
                ref.invalidate(adminCirclesProvider);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _PostsTab(ref: ref),
            _CirclesTab(ref: ref),
          ],
        ),
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  const _PostsTab({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(adminPostsProvider);

    return postsAsync.when(
      loading: () => const _LoadingList(),
      error: (e, _) => Center(
        child: ErrorMessage(
          message: 'Could not load posts.',
          onRetry: () => ref.invalidate(adminPostsProvider),
        ),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No posts found.'));
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminPostsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: posts.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.listItemGap),
            itemBuilder: (context, index) {
              final post = posts[index];
              return AdminPostTile(
                post: post,
                onPin: () => ref
                    .read(adminNotifierProvider.notifier)
                    .pinPost(post.id),
                onHide: () => ref
                    .read(adminNotifierProvider.notifier)
                    .hidePost(post.id),
                onDelete: () => ref
                    .read(adminNotifierProvider.notifier)
                    .deletePost(post.id),
              );
            },
          ),
        );
      },
    );
  }
}

class _CirclesTab extends StatelessWidget {
  const _CirclesTab({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final circlesAsync = ref.watch(adminCirclesProvider);

    return circlesAsync.when(
      loading: () => const _LoadingList(),
      error: (e, _) => Center(
        child: ErrorMessage(
          message: 'Could not load circles.',
          onRetry: () => ref.invalidate(adminCirclesProvider),
        ),
      ),
      data: (circles) {
        if (circles.isEmpty) {
          return const Center(child: Text('No circles found.'));
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminCirclesProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: circles.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.listItemGap),
            itemBuilder: (context, index) {
              final circle = circles[index];
              return AdminCircleTile(
                circle: circle,
                onFeature: () => ref
                    .read(adminNotifierProvider.notifier)
                    .featureCircle(circle.id),
                onDelete: () => ref
                    .read(adminNotifierProvider.notifier)
                    .deleteCircle(circle.id),
              );
            },
          ),
        );
      },
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: const [
        SkeletonCard(height: 100),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 100),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 100),
      ],
    );
  }
}
