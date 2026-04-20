import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';

// ── Stream-based Providers ───────────────────────────────────────────────────

/// Real-time stream of conversations from Firestore.
final conversationsStreamProvider =
    StreamProvider<List<ConversationModel>>((ref) {
  final service = ref.watch(messagingFirestoreServiceProvider);
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  return service.threadsStream().map((snap) {
    return snap.docs.map((doc) {
      final data = doc.data();
      final participants = List<String>.from(data['participants'] ?? []);
      return ConversationModel(
        id: doc.id,
        participants: participants,
        lastMessage: data['lastMessage'] as String?,
        lastMessageAt: (data['lastMessageAt'] as Timestamp?)
            ?.toDate()
            .toIso8601String(),
        unreadCount: (data['unreadCount_$uid'] as int?) ?? 0,
        updatedAt: (data['lastMessageAt'] as Timestamp?)
                ?.toDate()
                .toIso8601String() ??
            '',
      );
    }).toList();
  });
});

/// Real-time stream of messages for a specific thread.
final messagesStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, threadId) {
  final service = ref.watch(messagingFirestoreServiceProvider);
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  return service.messagesStream(threadId).map((snap) {
    return snap.docs.map((doc) {
      final data = doc.data();
      return MessageModel(
        id: doc.id,
        conversationId: threadId,
        senderId: data['sender'] ?? '',
        receiverId: '',
        content: data['content'] ?? '',
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? '',
        isFromMe: data['sender'] == uid,
        read: data['isRead'] ?? false,
      );
    }).toList();
  });
});

// ── Legacy Data Providers (kept for backward compatibility) ──────────────────

final conversationsProvider =
    FutureProvider<List<ConversationModel>>((ref) async {
  // Delegate to the stream provider for real-time data
  final streamValue = ref.watch(conversationsStreamProvider);
  return streamValue.when(
    data: (data) => data,
    loading: () => <ConversationModel>[],
    error: (_, __) => <ConversationModel>[],
  );
});

final messagesProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, conversationId) async {
  final streamValue = ref.watch(messagesStreamProvider(conversationId));
  return streamValue.when(
    data: (data) => data,
    loading: () => <MessageModel>[],
    error: (_, __) => <MessageModel>[],
  );
});

// ── Messaging Notifier ───────────────────────────────────────────────────

class MessagingNotifier extends StateNotifier<AsyncValue<List<MessageModel>>> {
  final MessagingFirestoreService _service;
  final Ref _ref;

  MessagingNotifier(this._service, this._ref)
      : super(const AsyncValue.data([]));

  /// Loads messages for a conversation (no-op for stream-based Firebase).
  Future<void> loadMessages(String conversationId) async {
    // Messages are loaded via streams in Firebase.
    // This method exists for API compatibility.
  }

  /// Sends a message with optimistic update. Returns true on success.
  Future<bool> sendMessage(String receiverId, String content) async {
    // Optimistic update — add a temporary message immediately.
    final optimistic = MessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: MessagingFirestoreService.getThreadId('', receiverId),
      senderId: '',
      receiverId: receiverId,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
      isFromMe: true,
    );

    final previous = state.valueOrNull ?? [];
    state = AsyncValue.data([...previous, optimistic]);

    try {
      await _service.sendMessage(receiverId, content);
      _ref.invalidate(conversationsProvider);
      return true;
    } catch (e) {
      // Revert on failure.
      state = AsyncValue.data(previous);
      return false;
    }
  }

  /// Marks a thread as read. Returns true on success.
  Future<bool> markAsRead(String threadId) async {
    try {
      await _service.markThreadRead(threadId);
      _ref.invalidate(conversationsProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final messagingNotifierProvider =
    StateNotifierProvider<MessagingNotifier, AsyncValue<List<MessageModel>>>(
        (ref) {
  final service = ref.watch(messagingFirestoreServiceProvider);
  return MessagingNotifier(service, ref);
});
