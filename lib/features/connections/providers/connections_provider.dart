import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/utils/firestore_helpers.dart';
import 'package:skill_exchange/data/models/connection_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final connectionsProvider =
    FutureProvider<List<ConnectionModel>>((ref) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  final data = await service.getMyConnections();
  return data.map((d) => parseConnection(d)).toList();
});

final pendingRequestsProvider =
    FutureProvider<List<ConnectionModel>>((ref) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  final data = await service.getPendingRequests();
  return data.map((d) => parseConnection(d)).toList();
});

final sentRequestsProvider =
    FutureProvider<List<ConnectionModel>>((ref) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  final data = await service.getSentRequests();
  return data.map((d) => parseConnection(d)).toList();
});

final connectionStatusProvider =
    FutureProvider.family<String, String>((ref, userId) async {
  // Determine connection status by checking existing connections
  final service = ref.watch(connectionFirestoreServiceProvider);
  final connections = await service.getMyConnections();
  final pending = await service.getPendingRequests();
  final sent = await service.getSentRequests();

  if (connections.any((c) => c['id'] == userId || c['requester'] == userId || c['recipient'] == userId)) {
    return 'connected';
  }
  if (pending.any((c) => c['requester'] == userId)) {
    return 'pending_received';
  }
  if (sent.any((c) => c['recipient'] == userId)) {
    return 'pending_sent';
  }
  return 'none';
});

// ── Connections Notifier ─────────────────────────────────────────────────

class ConnectionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ConnectionFirestoreService _service;
  final Ref _ref;

  ConnectionsNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> sendRequest(String toUserId, String? message) async {
    state = const AsyncValue.loading();
    try {
      await _service.sendRequest(toUserId, message: message);
      state = const AsyncValue.data(null);
      _ref.invalidate(connectionsProvider);
      _ref.invalidate(sentRequestsProvider);
      _ref.invalidate(pendingRequestsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> respondToRequest(String id, bool accept) async {
    state = const AsyncValue.loading();
    try {
      if (accept) {
        await _service.acceptRequest(id);
      } else {
        await _service.rejectRequest(id);
      }
      state = const AsyncValue.data(null);
      _ref.invalidate(connectionsProvider);
      _ref.invalidate(pendingRequestsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> removeConnection(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.removeConnection(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(connectionsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final connectionsNotifierProvider =
    StateNotifierProvider<ConnectionsNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(connectionFirestoreServiceProvider);
  return ConnectionsNotifier(service, ref);
});
