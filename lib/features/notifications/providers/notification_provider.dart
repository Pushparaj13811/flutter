import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/notification_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final notificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  // Notifications are stream-based in Firebase; stub as empty for FutureProvider.
  // UI should use the stream from notificationFirestoreServiceProvider directly.
  return <NotificationModel>[];
});

/// Derived provider that computes the unread notification count.
final unreadCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.when(
    data: (notifications) =>
        notifications.where((n) => !n.read).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// ── Notification Notifier ─────────────────────────────────────────────────

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationFirestoreService _service;
  final Ref _ref;

  NotificationNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  /// Marks a single notification as read. Returns true on success.
  Future<bool> markAsRead(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.markAsRead(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(notificationsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Marks all notifications as read. Returns true on success.
  Future<bool> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      await _service.markAllAsRead();
      state = const AsyncValue.data(null);
      _ref.invalidate(notificationsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Deletes a notification. Returns true on success.
  Future<bool> deleteNotification(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteNotification(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(notificationsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(notificationFirestoreServiceProvider);
  return NotificationNotifier(service, ref);
});
