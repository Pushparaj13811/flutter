import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/utils/firestore_helpers.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final upcomingSessionsProvider =
    FutureProvider<List<SessionModel>>((ref) async {
  final service = ref.watch(sessionFirestoreServiceProvider);
  final data = await service.getMySessions();
  return data.map((d) => _parseSession(d)).toList();
});

/// Safe parser that won't crash on missing/mismatched Firestore fields.
SessionModel _parseSession(Map<String, dynamic> d) {
  return SessionModel(
    id: d['id'] as String? ?? '',
    hostId: d['hostId'] as String? ?? d['host'] as String? ?? '',
    participantId: d['participantId'] as String? ?? d['participant'] as String? ?? '',
    title: d['title'] as String? ?? d['skill'] as String? ?? 'Session',
    description: d['description'] as String? ?? '',
    skillsToCover: (d['skillsToCover'] as List?)?.cast<String>() ?? [],
    scheduledAt: toIsoString(d['scheduledAt']),
    duration: (d['duration'] as num?)?.toInt() ?? 60,
    status: _parseSessionStatus(d['status'] as String? ?? 'scheduled'),
    sessionMode: d['sessionMode'] as String? ?? d['mode'] as String? ?? 'online',
    meetingPlatform: d['meetingPlatform'] as String?,
    meetingLink: d['meetingLink'] as String?,
    location: d['location'] as String?,
    notes: d['notes'] as String?,
    createdAt: toIsoString(d['createdAt']),
    updatedAt: toIsoString(d['updatedAt'] ?? d['createdAt']),
  );
}

SessionStatus _parseSessionStatus(String status) {
  return switch (status) {
    'completed' => SessionStatus.completed,
    'cancelled' => SessionStatus.cancelled,
    _ => SessionStatus.scheduled,
  };
}

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
