import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/data/repositories/session_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/session_remote_source.dart';
import 'package:skill_exchange/domain/repositories/session_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final sessionRemoteSourceProvider = Provider<SessionRemoteSource>((ref) {
  return SessionRemoteSource(ref.watch(dioProvider));
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(ref.watch(sessionRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final upcomingSessionsProvider =
    FutureProvider<List<SessionModel>>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final result = await repo.getUpcomingSessions();
  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});

// ── Sessions Notifier ─────────────────────────────────────────────────────

class SessionsNotifier extends StateNotifier<AsyncValue<void>> {
  final SessionRepository _repository;
  final Ref _ref;

  SessionsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createSession(CreateSessionDto dto) async {
    state = const AsyncValue.loading();
    final result = await _repository.createSession(dto);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(upcomingSessionsProvider);
        return true;
      },
    );
  }

  Future<bool> cancelSession(String id, {String? reason}) async {
    state = const AsyncValue.loading();
    final result = await _repository.cancelSession(id, reason: reason);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(upcomingSessionsProvider);
        return true;
      },
    );
  }

  Future<bool> completeSession(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.completeSession(id);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(upcomingSessionsProvider);
        return true;
      },
    );
  }

  Future<bool> rescheduleSession(String id, RescheduleSessionDto dto) async {
    state = const AsyncValue.loading();
    final result = await _repository.rescheduleSession(id, dto);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(upcomingSessionsProvider);
        return true;
      },
    );
  }
}

final sessionsNotifierProvider =
    StateNotifierProvider<SessionsNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(sessionRepositoryProvider);
  return SessionsNotifier(repo, ref);
});
