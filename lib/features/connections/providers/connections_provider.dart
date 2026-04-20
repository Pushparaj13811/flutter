import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/data/sources/firebase/connection_firestore_service.dart';

// ── Helper: enrich connection with the other user's profile ──────────────

Future<Map<String, dynamic>> _enrichConnection(Map<String, dynamic> conn) async {
  final myUid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;

  final otherUid = conn['requester'] == myUid
      ? conn['recipient'] as String?
      : conn['requester'] as String?;

  if (otherUid == null || otherUid.isEmpty) {
    return {
      ...conn,
      'otherUserId': '',
      'otherUserName': 'Unknown',
      'otherUserAvatar': null,
      'otherUsername': '',
    };
  }

  try {
    final profileDoc = await db.collection('profiles').doc(otherUid).get();
    final userDoc = await db.collection('users').doc(otherUid).get();
    final profileData = profileDoc.data() ?? {};
    final userData = userDoc.data() ?? {};

    return {
      ...conn,
      'otherUserId': otherUid,
      'otherUserName': profileData['fullName'] ?? userData['name'] ?? userData['displayName'] ?? 'User',
      'otherUserAvatar': profileData['avatar'] ?? userData['avatar'] ?? userData['photoURL'],
      'otherUsername': profileData['username'] ?? userData['username'] ?? '',
    };
  } catch (_) {
    // Enrichment failed — return connection with fallback display values
    return {
      ...conn,
      'otherUserId': otherUid,
      'otherUserName': 'User',
      'otherUserAvatar': null,
      'otherUsername': '',
    };
  }
}

Future<List<Map<String, dynamic>>> _enrichAll(List<Map<String, dynamic>> list) async {
  final enriched = <Map<String, dynamic>>[];
  for (final conn in list) {
    enriched.add(await _enrichConnection(conn));
  }
  return enriched;
}

// ── Data Providers ────────────────────────────────────────────────────────

final connectionsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  final data = await service.getMyConnections();
  return _enrichAll(data);
});

final pendingRequestsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  final data = await service.getPendingRequests();
  return _enrichAll(data);
});

final sentRequestsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  final data = await service.getSentRequests();
  return _enrichAll(data);
});

final connectionStatusProvider =
    FutureProvider.family<String, String>((ref, userId) async {
  final service = ref.watch(connectionFirestoreServiceProvider);
  return service.getConnectionStatus(userId);
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
