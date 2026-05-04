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
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';
import 'package:skill_exchange/features/sessions/widgets/video_call_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  /// Compute the correct Firestore thread ID.
  /// If conversationId already contains '_', it's a threadId (uid1_uid2).
  /// Otherwise it's the other user's UID and we need to compute the sorted pair.
  String get _threadId {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final otherId = widget.conversationId;
    // If conversationId already contains '_', it's a proper threadId
    if (otherId.contains('_')) return otherId;
    // Otherwise compute it from the two UIDs
    final sorted = [myUid, otherId]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Get the other user's UID from the threadId.
  String get _otherUserId {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final parts = _threadId.split('_');
    return parts.firstWhere((p) => p != myUid, orElse: () => widget.conversationId);
  }

  String? _cachedOtherUserName;
  String? _cachedOtherUserAvatar;

  @override
  void initState() {
    super.initState();
    // Mark conversation as read when opening.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messagingNotifierProvider.notifier)
          .markAsRead(_threadId);
    });
    _loadOtherUserProfile();
  }

  Future<void> _loadOtherUserProfile() async {
    final db = FirebaseFirestore.instance;
    final profileDoc = await db.collection('profiles').doc(_otherUserId).get();
    final userDoc = await db.collection('users').doc(_otherUserId).get();
    final profile = profileDoc.data() ?? {};
    final userData = userDoc.data() ?? {};

    if (mounted) {
      setState(() {
        _cachedOtherUserName = profile['fullName'] ?? userData['name'] ?? 'User';
        _cachedOtherUserAvatar = profile['avatar'] ?? userData['avatar'];
      });
    }
  }

  void _onSend(String content) {
    ref
        .read(messagingNotifierProvider.notifier)
        .sendMessage(_otherUserId, content);
  }

  void _onTypingChanged(bool isTyping) {
    final service = ref.read(messagingFirestoreServiceProvider);
    service.setTyping(_threadId, isTyping);
  }

  // ── Conversation metadata (cached in local state to avoid flicker) ────────

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final name = _cachedOtherUserName;
    final avatar = _cachedOtherUserAvatar;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            tooltip: 'Video Call',
            onPressed: () async {
              final otherUserName = _cachedOtherUserName ?? 'User';
              final notifier = ref.read(callNotifierProvider.notifier);
              final success = await notifier.startCall(_otherUserId, otherUserName);
              if (success && context.mounted) {
                final callState = ref.read(callNotifierProvider);
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => VideoCallScreen(
                      channelId: callState.callId!,
                      remoteUserName: otherUserName,
                      isCaller: true,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: service.messagesStream(_threadId),
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
                  return <String, dynamic>{
                    'id': doc.id,
                    'conversationId': _threadId,
                    'senderId': data['sender'] ?? '',
                    'receiverId': '',
                    'content': data['content'] ?? '',
                    'createdAt': (data['createdAt'] as Timestamp?)
                            ?.toDate()
                            .toIso8601String() ??
                        '',
                    'isFromMe': data['sender'] == currentUid,
                    'read': data['isRead'] ?? false,
                  };
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
            threadId: _threadId,
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

// ── Typing Indicator Widget ──────────────────────────��──────────────────────

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
