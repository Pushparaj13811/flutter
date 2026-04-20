import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/messaging/providers/messaging_provider.dart';
import 'package:skill_exchange/core/widgets/animated_list_item.dart';
import 'package:skill_exchange/features/messaging/widgets/conversation_tile.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(conversationsStreamProvider);
    ref.invalidate(conversationsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: conversationsAsync.when(
        loading: () => _buildLoadingSkeleton(),
        error: (error, _) => Center(
          child: ErrorMessage(
            message: error.toString(),
            onRetry: () => _refresh(ref),
          ),
        ),
        data: (conversations) {
          if (conversations.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView(
                children: const [
                  EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'No conversations yet',
                    description:
                        'Start a conversation with one of your connections.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                indent: AppSpacing.screenPadding + 48 + AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return AnimatedListItem(
                  index: index,
                  child: ConversationTile(
                    conversation: conversation,
                    onTap: () =>
                        context.push('/messages/${conversation.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 6,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.message(),
    );
  }
}
