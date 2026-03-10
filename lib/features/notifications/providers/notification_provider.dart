import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/notification_model.dart';
import 'package:skill_exchange/data/repositories/notification_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/notification_remote_source.dart';
import 'package:skill_exchange/domain/repositories/notification_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final notificationRemoteSourceProvider =
    Provider<NotificationRemoteSource>((ref) {
  return NotificationRemoteSource(ref.watch(dioProvider));
});

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    ref.watch(notificationRemoteSourceProvider),
  );
});

// ── Data Providers ────────────────────────────────────────────────────────

final notificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  final result = await repo.getNotifications();
  return result.fold(
    (failure) => throw failure,
    (notifications) => notifications,
  );
});

/// Derived provider that computes the unread notification count.
final unreadCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.when(
    data: (notifications) =>
        notifications.where((n) => !n.read).length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});

// ── Notification Notifier ─────────────────────────────────────────────────

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repository;
  final Ref _ref;

  NotificationNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// Marks a single notification as read. Returns true on success.
  Future<bool> markAsRead(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.markAsRead(id);
      return result.fold(
        (failure) => throw failure,
        (_) => null,
      );
    });

    if (!state.hasError) {
      _ref.invalidate(notificationsProvider);
      return true;
    }
    return false;
  }

  /// Marks all notifications as read. Returns true on success.
  Future<bool> markAllAsRead() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.markAllAsRead();
      return result.fold(
        (failure) => throw failure,
        (_) => null,
      );
    });

    if (!state.hasError) {
      _ref.invalidate(notificationsProvider);
      return true;
    }
    return false;
  }

  /// Deletes a notification. Returns true on success.
  Future<bool> deleteNotification(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.deleteNotification(id);
      return result.fold(
        (failure) => throw failure,
        (_) => null,
      );
    });

    if (!state.hasError) {
      _ref.invalidate(notificationsProvider);
      return true;
    }
    return false;
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repo, ref);
});
