import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/features/messaging/providers/messaging_provider.dart';
import 'package:skill_exchange/features/messaging/widgets/message_bubble.dart';
import 'package:skill_exchange/features/messaging/widgets/message_input.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/message_model.dart';

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
    });
  }

  String _getOtherUserId(String threadId) {
    final parts = threadId.split('_');
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    return parts.firstWhere((p) => p != myUid, orElse: () => parts.last);
  }

  void _onSend(String content) {
    final receiverId = _getOtherUserId(widget.conversationId);
    ref
        .read(messagingNotifierProvider.notifier)
        .sendMessage(receiverId, content);
  }

  void _onTypingChanged(bool isTyping) {
    final service = ref.read(messagingFirestoreServiceProvider);
    service.setTyping(widget.conversationId, isTyping);
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
    final name = _otherUserName(ref);
    final avatar = _otherUserAvatar(ref);
    final service = ref.watch(messagingFirestoreServiceProvider);

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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: service.messagesStream(widget.conversationId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: ErrorMessage(
                      message: snapshot.error.toString(),
                      onRetry: () => setState(() {}),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return _buildLoadingSkeleton();
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Text('No messages yet. Say hello!'),
                    ),
                  );
                }

                final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
                final messages = docs.map((doc) {
                  final data = doc.data();
                  return MessageModel(
                    id: doc.id,
                    conversationId: widget.conversationId,
                    senderId: data['sender'] ?? '',
                    receiverId: '',
                    content: data['content'] ?? '',
                    createdAt: (data['createdAt'] as Timestamp?)
                            ?.toDate()
                            .toIso8601String() ??
                        '',
                    isFromMe: data['sender'] == currentUid,
                    read: data['isRead'] ?? false,
                  );
                }).toList();

                return ListView.separated(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: messages.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, index) {
                    final message =
                        messages[messages.length - 1 - index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          // Typing indicator
          _TypingIndicator(
            threadId: widget.conversationId,
            service: service,
          ),
          MessageInput(
            onSend: _onSend,
            onTypingChanged: _onTypingChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 8,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, __) => const SkeletonCard.message(),
    );
  }
}

// ── Typing Indicator Widget ─────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({
    required this.threadId,
    required this.service,
  });

  final String threadId;
  final MessagingFirestoreService service;

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: service.typingStream(threadId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data()!;
        // Check if anyone other than current user is typing recently
        bool otherIsTyping = false;
        for (final entry in data.entries) {
          if (entry.key == currentUid) continue;
          if (entry.value is Timestamp) {
            final ts = (entry.value as Timestamp).toDate();
            if (DateTime.now().difference(ts).inSeconds < 5) {
              otherIsTyping = true;
              break;
            }
          }
        }

        if (!otherIsTyping) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Text(
                'typing...',
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.mutedForeground,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
