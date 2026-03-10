import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';
import 'package:skill_exchange/data/repositories/messaging_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/messaging_remote_source.dart';
import 'package:skill_exchange/domain/repositories/messaging_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final messagingRemoteSourceProvider = Provider<MessagingRemoteSource>((ref) {
  return MessagingRemoteSource(ref.watch(dioProvider));
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.watch(messagingRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final conversationsProvider =
    FutureProvider<List<ConversationModel>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final result = await repo.getConversations();
  return result.fold(
    (failure) => throw failure,
    (conversations) => conversations,
  );
});

final messagesProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, conversationId) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final result = await repo.getMessages(conversationId);
  return result.fold(
    (failure) => throw failure,
    (messages) => messages,
  );
});

// ── Messaging Notifier ───────────────────────────────────────────────────

class MessagingNotifier extends StateNotifier<AsyncValue<List<MessageModel>>> {
  final MessagingRepository _repository;
  final Ref _ref;

  MessagingNotifier(this._repository, this._ref)
      : super(const AsyncValue.data([]));

  /// Loads messages for the given conversation and updates state.
  Future<void> loadMessages(String conversationId) async {
    state = const AsyncValue.loading();
    final result = await _repository.getMessages(conversationId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (messages) => AsyncValue.data(messages),
    );
  }

  /// Sends a message with optimistic update. Returns true on success.
  Future<bool> sendMessage(String conversationId, String content) async {
    // Optimistic update — add a temporary message immediately.
    final optimistic = MessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: '',
      receiverId: '',
      content: content,
      createdAt: DateTime.now().toIso8601String(),
      isFromMe: true,
    );

    final previous = state.valueOrNull ?? [];
    state = AsyncValue.data([...previous, optimistic]);

    final result = await _repository.sendMessage(conversationId, content);
    return result.fold(
      (failure) {
        // Revert on failure.
        state = AsyncValue.data(previous);
        return false;
      },
      (message) {
        // Replace the optimistic message with the real one.
        final current = state.valueOrNull ?? [];
        final updated = current
            .map((m) => m.id == optimistic.id ? message : m)
            .toList();
        state = AsyncValue.data(updated);
        _ref.invalidate(conversationsProvider);
        return true;
      },
    );
  }

  /// Marks a conversation as read. Returns true on success.
  Future<bool> markAsRead(String id) async {
    final result = await _repository.markAsRead(id);
    return result.fold(
      (failure) => false,
      (_) {
        _ref.invalidate(conversationsProvider);
        return true;
      },
    );
  }
}

final messagingNotifierProvider =
    StateNotifierProvider<MessagingNotifier, AsyncValue<List<MessageModel>>>(
        (ref) {
  final repo = ref.watch(messagingRepositoryProvider);
  return MessagingNotifier(repo, ref);
});
