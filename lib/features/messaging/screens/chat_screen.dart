import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/features/messaging/providers/messaging_provider.dart';
import 'package:skill_exchange/features/messaging/widgets/message_bubble.dart';
import 'package:skill_exchange/features/messaging/widgets/message_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Mark conversation as read when opening.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messagingNotifierProvider.notifier)
          .markAsRead(widget.conversationId);
      ref
          .read(messagingNotifierProvider.notifier)
          .loadMessages(widget.conversationId);
    });
  }

  void _onSend(String content) {
    ref
        .read(messagingNotifierProvider.notifier)
        .sendMessage(widget.conversationId, content);
  }

  // ── Conversation metadata ──────────────────────────────────────────────

  String? _otherUserName(WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    return conversationsAsync.whenOrNull(
      data: (conversations) {
        final match = conversations.where(
          (c) => c.id == widget.conversationId,
        );
        if (match.isEmpty) return null;
        final conversation = match.first;
        if (conversation.participantProfiles.isNotEmpty) {
          return conversation.participantProfiles.first.fullName;
        }
        return null;
      },
    );
  }

  String? _otherUserAvatar(WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    return conversationsAsync.whenOrNull(
      data: (conversations) {
        final match = conversations.where(
          (c) => c.id == widget.conversationId,
        );
        if (match.isEmpty) return null;
        final conversation = match.first;
        if (conversation.participantProfiles.isNotEmpty) {
          return conversation.participantProfiles.first.avatar;
        }
        return null;
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagingNotifierProvider);
    final name = _otherUserName(ref);
    final avatar = _otherUserAvatar(ref);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            if (name != null) ...[
              UserAvatar(
                name: name,
                imageUrl: avatar,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                name ?? 'Chat',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => _buildLoadingSkeleton(),
              error: (error, _) => Center(
                child: ErrorMessage(
                  message: error.toString(),
                  onRetry: () => ref
                      .read(messagingNotifierProvider.notifier)
                      .loadMessages(widget.conversationId),
                ),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Text('No messages yet. Say hello!'),
                    ),
                  );
                }

                return ListView.separated(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: messages.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, index) {
                    // Reversed list: newest at bottom, so index 0 is the
                    // last element in the messages list.
                    final message =
                        messages[messages.length - 1 - index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          MessageInput(onSend: _onSend),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 8,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.message(),
    );
  }
}
