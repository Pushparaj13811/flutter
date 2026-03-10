import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/connection_model.dart';
import 'package:skill_exchange/data/repositories/connection_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/connection_remote_source.dart';
import 'package:skill_exchange/domain/repositories/connection_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final connectionRemoteSourceProvider = Provider<ConnectionRemoteSource>((ref) {
  return ConnectionRemoteSource(ref.watch(dioProvider));
});

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  return ConnectionRepositoryImpl(ref.watch(connectionRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final connectionsProvider =
    FutureProvider<List<ConnectionModel>>((ref) async {
  final repo = ref.watch(connectionRepositoryProvider);
  final result = await repo.getConnections();
  return result.fold(
    (failure) => throw failure,
    (connections) => connections,
  );
});

final pendingRequestsProvider =
    FutureProvider<List<ConnectionModel>>((ref) async {
  final repo = ref.watch(connectionRepositoryProvider);
  final result = await repo.getPendingRequests();
  return result.fold(
    (failure) => throw failure,
    (requests) => requests,
  );
});

final sentRequestsProvider =
    FutureProvider<List<ConnectionModel>>((ref) async {
  final repo = ref.watch(connectionRepositoryProvider);
  final result = await repo.getSentRequests();
  return result.fold(
    (failure) => throw failure,
    (requests) => requests,
  );
});

final connectionStatusProvider =
    FutureProvider.family<String, String>((ref, userId) async {
  final repo = ref.watch(connectionRepositoryProvider);
  final result = await repo.getConnectionStatus(userId);
  return result.fold(
    (failure) => throw failure,
    (status) => status,
  );
});

// ── Connections Notifier ─────────────────────────────────────────────────

class ConnectionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ConnectionRepository _repository;
  final Ref _ref;

  ConnectionsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> sendRequest(String toUserId, String? message) async {
    state = const AsyncValue.loading();
    final result = await _repository.sendRequest(toUserId, message);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(connectionsProvider);
        _ref.invalidate(sentRequestsProvider);
        _ref.invalidate(pendingRequestsProvider);
        return true;
      },
    );
  }

  Future<bool> respondToRequest(String id, bool accept) async {
    state = const AsyncValue.loading();
    final result = await _repository.respondToRequest(id, accept);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(connectionsProvider);
        _ref.invalidate(pendingRequestsProvider);
        return true;
      },
    );
  }

  Future<bool> removeConnection(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.removeConnection(id);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(connectionsProvider);
        return true;
      },
    );
  }
}

final connectionsNotifierProvider =
    StateNotifierProvider<ConnectionsNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(connectionRepositoryProvider);
  return ConnectionsNotifier(repo, ref);
});
