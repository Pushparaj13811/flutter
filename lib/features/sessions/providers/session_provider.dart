import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final upcomingSessionsProvider =
    FutureProvider<List<SessionModel>>((ref) async {
  final service = ref.watch(sessionFirestoreServiceProvider);
  final data = await service.getMySessions();
  return data.map((d) => SessionModel.fromJson(d)).toList();
});

// ── Sessions Notifier ─────────────────────────────────────────────────────

class SessionsNotifier extends StateNotifier<AsyncValue<void>> {
  final SessionFirestoreService _service;
  final Ref _ref;

  SessionsNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> createSession(CreateSessionDto dto) async {
    state = const AsyncValue.loading();
    try {
      await _service.bookSession(dto.toJson());
      state = const AsyncValue.data(null);
      _ref.invalidate(upcomingSessionsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> cancelSession(String id, {String? reason}) async {
    state = const AsyncValue.loading();
    try {
      await _service.cancelSession(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(upcomingSessionsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> completeSession(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.completeSession(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(upcomingSessionsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> rescheduleSession(String id, RescheduleSessionDto dto) async {
    state = const AsyncValue.loading();
    try {
      await _service.rescheduleSession(
        id,
        DateTime.parse(dto.newScheduledAt),
        dto.newDuration,
        reason: dto.reason,
      );
      state = const AsyncValue.data(null);
      _ref.invalidate(upcomingSessionsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final sessionsNotifierProvider =
    StateNotifierProvider<SessionsNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(sessionFirestoreServiceProvider);
  return SessionsNotifier(service, ref);
});
