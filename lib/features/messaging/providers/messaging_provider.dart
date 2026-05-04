import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/services/notification_trigger_service.dart';

// ── Stream-based Providers ───────────────────────────────────────────────────

/// Real-time stream of conversations from Firestore, enriched with user profiles.
final conversationsStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(messagingFirestoreServiceProvider);
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final db = FirebaseFirestore.instance;

  return service.threadsStream().asyncMap((snap) async {
    final conversations = <Map<String, dynamic>>[];

    for (final doc in snap.docs) {
      final data = doc.data();
      final participants = List<String>.from(data['participants'] ?? []);
      final otherUid = participants.firstWhere(
        (p) => p != uid,
        orElse: () => '',
      );

      // Fetch other user's profile to get name and avatar
      String otherName = 'User';
      String? otherAvatar;
      if (otherUid.isNotEmpty) {
        try {
          final profileDoc = await db.collection('profiles').doc(otherUid).get();
          final userDoc = await db.collection('users').doc(otherUid).get();
          final profile = profileDoc.data() ?? {};
          final userData = userDoc.data() ?? {};
          otherName = profile['fullName'] ?? userData['name'] ?? 'User';
          otherAvatar = profile['avatar'] as String? ?? userData['avatar'] as String?;
        } catch (_) {}
      }

      conversations.add(<String, dynamic>{
        'id': doc.id,
        'participants': participants,
        'lastMessage': data['lastMessage'] as String?,
        'lastMessageAt': (data['lastMessageAt'] as Timestamp?)
            ?.toDate()
            .toIso8601String(),
        'unreadCount': (data['unreadCount_$uid'] as int?) ?? 0,
        'updatedAt': (data['lastMessageAt'] as Timestamp?)
                ?.toDate()
                .toIso8601String() ??
            '',
        'otherUserId': otherUid,
        'otherUserName': otherName,
        'otherUserAvatar': otherAvatar,
      });
    }

    return conversations;
  });
});

/// Real-time stream of messages for a specific thread as raw maps.
final messagesStreamProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, threadId) {
  final service = ref.watch(messagingFirestoreServiceProvider);
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  return service.messagesStream(threadId).map((snap) {
    return snap.docs.map((doc) {
      final data = doc.data();
      return <String, dynamic>{
        'id': doc.id,
        'conversationId': threadId,
        'senderId': data['sender'] ?? '',
        'receiverId': '',
        'content': data['content'] ?? '',
        'createdAt':
            (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? '',
        'isFromMe': data['sender'] == uid,
        'read': data['isRead'] ?? false,
      };
    }).toList();
  });
});

// ── Legacy Data Providers (kept for backward compatibility) ──────────────────

final conversationsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final streamValue = ref.watch(conversationsStreamProvider);
  return streamValue.when(
    data: (data) => data,
    loading: () => <Map<String, dynamic>>[],
    error: (_, __) => <Map<String, dynamic>>[],
  );
});

final messagesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, conversationId) async {
  final streamValue = ref.watch(messagesStreamProvider(conversationId));
  return streamValue.when(
    data: (data) => data,
    loading: () => <Map<String, dynamic>>[],
    error: (_, __) => <Map<String, dynamic>>[],
  );
});

// ── Messaging Notifier ───────────────────────────────────────────────────

class MessagingNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final MessagingFirestoreService _service;
  final NotificationTriggerService _notifications;
  final Ref _ref;

  MessagingNotifier(this._service, this._notifications, this._ref)
      : super(const AsyncValue.data([]));

  /// Loads messages for a conversation (no-op for stream-based Firebase).
  Future<void> loadMessages(String conversationId) async {
    // Messages are loaded via streams in Firebase.
    // This method exists for API compatibility.
  }

  /// Sends a message with optimistic update. Returns true on success.
  Future<bool> sendMessage(String receiverId, String content) async {
    final optimistic = <String, dynamic>{
      'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'conversationId': MessagingFirestoreService.getThreadId('', receiverId),
      'senderId': '',
      'receiverId': receiverId,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
      'isFromMe': true,
      'read': false,
    };

    final previous = state.valueOrNull ?? [];
    state = AsyncValue.data([...previous, optimistic]);

    try {
      await _service.sendMessage(receiverId, content);
      _ref.invalidate(conversationsProvider);
      try {
        await _notifications.onNewMessage(receiverId, content);
      } catch (_) {
        // Non-blocking
      }
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
    StateNotifierProvider<MessagingNotifier, AsyncValue<List<Map<String, dynamic>>>>(
        (ref) {
  final service = ref.watch(messagingFirestoreServiceProvider);
  final notifications = ref.watch(notificationTriggerServiceProvider);
  return MessagingNotifier(service, notifications, ref);
});
