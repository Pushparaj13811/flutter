import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final conversationsProvider =
    FutureProvider<List<ConversationModel>>((ref) async {
  // Conversations are stream-based in Firebase; stub as empty for now.
  // UI should use threadsStreamProvider instead.
  return <ConversationModel>[];
});

final messagesProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, conversationId) async {
  // Messages are stream-based in Firebase; stub as empty for now.
  // UI should use messagesStreamProvider instead.
  return <MessageModel>[];
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
