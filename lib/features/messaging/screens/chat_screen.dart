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
    if (otherId.contains('_')) return otherId;
    final sorted = [myUid, otherId]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Get the other user's UID from the threadId.
  String get _otherUserId {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final parts = _threadId.split('_');
    return parts.firstWhere((p) => p != myUid,
        orElse: () => widget.conversationId);
  }

  String? _cachedOtherUserName;
  String? _cachedOtherUserAvatar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagingNotifierProvider.notifier).markAsRead(_threadId);
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
        _cachedOtherUserName =
            profile['fullName'] ?? userData['name'] ?? 'User';
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

  @override
  Widget build(BuildContext context) {
    final name = _cachedOtherUserName;
    final avatar = _cachedOtherUserAvatar;
    final colors = context.colors;
    final service = ref.watch(messagingFirestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 48,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: colors.foreground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            if (name != null) ...[
              UserAvatar(
                name: name,
                imageUrl: avatar,
                size: 36,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name ?? 'Chat',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Typing / online status row
                  _OnlineStatusSubtitle(
                    threadId: _threadId,
                    otherUserId: _otherUserId,
                    service: service,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Video call
          IconButton(
            icon: Icon(Icons.videocam_outlined,
                color: colors.primary, size: 24),
            tooltip: 'Video Call',
            onPressed: () async {
              final otherUserName = _cachedOtherUserName ?? 'User';
              final notifier = ref.read(callNotifierProvider.notifier);
              final success =
                  await notifier.startCall(_otherUserId, otherUserName);
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
              } else if (!success && context.mounted) {
                final callState = ref.read(callNotifierProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(callState.error ?? 'Failed to start video call'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          // More options
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: colors.foreground, size: 22),
            onSelected: (value) async {
              if (value == 'delete') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Chat'),
                    content: const Text('Delete this entire conversation? This cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await service.deleteConversation(_threadId);
                  if (context.mounted) Navigator.of(context).pop();
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Chat', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
        elevation: 0,
        scrolledUnderElevation: 1,
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
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded,
                              size: 48, color: colors.mutedForeground),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No messages yet',
                            style: AppTextStyles.h4
                                .copyWith(color: colors.foreground),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Say hello!',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: colors.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final currentUid =
                    FirebaseAuth.instance.currentUser?.uid ?? '';
                final messages = docs.map((doc) {
                  final data = doc.data();
                  return <String, dynamic>{
                    'id': doc.id,
                    'conversationId': _threadId,
                    'senderId': data['sender'] ?? '',
                    'receiverId': '',
                    'content': data['content'] ?? '',
                    'createdAt':
                        (data['createdAt'] as Timestamp?)
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
                    vertical: AppSpacing.md,
                  ),
                  itemCount: messages.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, index) {
                    final message = messages[messages.length - 1 - index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          // Typing indicator (moved into input area visually)
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

// ── Online Status / Typing Subtitle ─────────────────────────────────────────

class _OnlineStatusSubtitle extends StatelessWidget {
  const _OnlineStatusSubtitle({
    required this.threadId,
    required this.otherUserId,
    required this.service,
  });

  final String threadId;
  final String otherUserId;
  final MessagingFirestoreService service;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final db = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: db.collection('presence').doc(otherUserId).snapshots(),
      builder: (context, presenceSnap) {
        final isOnline = presenceSnap.data?.data()?['isOnline'] == true;
        final lastSeen = presenceSnap.data?.data()?['lastSeen'];

        // Also check typing
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: service.typingStream(threadId),
          builder: (context, typingSnap) {
            bool otherIsTyping = false;
            if (typingSnap.hasData && typingSnap.data?.data() != null) {
              final data = typingSnap.data!.data()!;
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
            }

            String text;
            Color textColor;
            FontStyle fontStyle = FontStyle.normal;

            if (otherIsTyping) {
              text = 'typing...';
              textColor = colors.primary;
              fontStyle = FontStyle.italic;
            } else if (isOnline) {
              text = 'online';
              textColor = colors.success;
            } else if (lastSeen is Timestamp) {
              final dt = lastSeen.toDate();
              final diff = DateTime.now().difference(dt);
              if (diff.inMinutes < 1) {
                text = 'last seen just now';
              } else if (diff.inMinutes < 60) {
                text = 'last seen ${diff.inMinutes}m ago';
              } else if (diff.inHours < 24) {
                text = 'last seen ${diff.inHours}h ago';
              } else {
                text = 'last seen ${diff.inDays}d ago';
              }
              textColor = colors.mutedForeground;
            } else {
              text = 'offline';
              textColor = colors.mutedForeground;
            }

            return Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: textColor,
                fontStyle: fontStyle,
                fontSize: 11,
              ),
            );
          },
        );
      },
    );
  }
}

// ── Typing Indicator (legacy — kept for spacing, shows nothing) ──────────────

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({
    required this.threadId,
    required this.service,
  });

  final String threadId;
  final MessagingFirestoreService service;

  @override
  Widget build(BuildContext context) {
    // Typing is now shown in the AppBar subtitle — keep this widget as
    // an invisible spacer so layout doesn't shift.
    return const SizedBox.shrink();
  }
}
