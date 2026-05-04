import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/data/sources/firebase/call_firestore_service.dart';

enum CallStatus { idle, ringing, connecting, active, ended, declined }

class CallState {
  final CallStatus status;
  final String? callId;
  final String? remoteUserId;
  final String? remoteUserName;
  final bool isMuted;
  final bool isCameraOn;
  final int? remoteUid;
  final Duration duration;

  const CallState({
    this.status = CallStatus.idle,
    this.callId,
    this.remoteUserId,
    this.remoteUserName,
    this.isMuted = false,
    this.isCameraOn = true,
    this.remoteUid,
    this.duration = Duration.zero,
  });

  CallState copyWith({
    CallStatus? status,
    String? callId,
    String? remoteUserId,
    String? remoteUserName,
    bool? isMuted,
    bool? isCameraOn,
    int? remoteUid,
    Duration? duration,
  }) {
    return CallState(
      status: status ?? this.status,
      callId: callId ?? this.callId,
      remoteUserId: remoteUserId ?? this.remoteUserId,
      remoteUserName: remoteUserName ?? this.remoteUserName,
      isMuted: isMuted ?? this.isMuted,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      remoteUid: remoteUid ?? this.remoteUid,
      duration: duration ?? this.duration,
    );
  }
}

class CallNotifier extends StateNotifier<CallState> {
  final AgoraService _agora;
  final CallFirestoreService _callService;
  StreamSubscription? _callStreamSub;
  Timer? _durationTimer;

  CallNotifier(this._agora, this._callService) : super(const CallState());

  Future<bool> startCall(String calleeUid, String calleeName) async {
    final hasPerms = await _agora.requestPermissions();
    if (!hasPerms) return false;

    try {
      await _agora.initialize();
      final callId = await _callService.createCall(calleeUid);

      state = state.copyWith(
        status: CallStatus.ringing,
        callId: callId,
        remoteUserId: calleeUid,
        remoteUserName: calleeName,
      );

      _listenToCall(callId);
      await _agora.joinChannel(callId, 0);

      return true;
    } catch (e) {
      state = const CallState();
      return false;
    }
  }

  Future<bool> acceptCall(String callId, String callerName) async {
    final hasPerms = await _agora.requestPermissions();
    if (!hasPerms) return false;

    try {
      await _agora.initialize();
      await _callService.setAnswer(callId, {'accepted': true});

      state = state.copyWith(
        status: CallStatus.connecting,
        callId: callId,
        remoteUserName: callerName,
      );

      await _agora.joinChannel(callId, 1);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> declineCall(String callId) async {
    await _callService.declineCall(callId);
    state = const CallState();
  }

  Future<void> endCall() async {
    final callId = state.callId;
    if (callId != null) {
      await _callService.endCall(callId);
    }
    await _cleanup();
    state = const CallState();
  }

  void toggleMute() {
    final muted = !state.isMuted;
    _agora.toggleMute(muted);
    state = state.copyWith(isMuted: muted);
  }

  void toggleCamera() {
    final on = !state.isCameraOn;
    _agora.toggleCamera(on);
    state = state.copyWith(isCameraOn: on);
  }

  void switchCamera() {
    _agora.switchCamera();
  }

  void onRemoteUserJoined(int uid) {
    state = state.copyWith(
      status: CallStatus.active,
      remoteUid: uid,
    );
    _startDurationTimer();
  }

  void onRemoteUserLeft(int uid) {
    endCall();
  }

  void _listenToCall(String callId) {
    _callStreamSub = _callService.callStream(callId).listen((snapshot) {
      final data = snapshot.data();
      if (data == null) return;
      final status = data['status'] as String?;
      if (status == 'ended' || status == 'declined') {
        _cleanup();
        state = state.copyWith(
          status: status == 'declined' ? CallStatus.declined : CallStatus.ended,
        );
      } else if (status == 'active') {
        state = state.copyWith(status: CallStatus.connecting);
      }
    });
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      );
    });
  }

  Future<void> _cleanup() async {
    _callStreamSub?.cancel();
    _durationTimer?.cancel();
    await _agora.leaveChannel();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}

final callNotifierProvider =
    StateNotifierProvider<CallNotifier, CallState>((ref) {
  final agora = ref.watch(agoraServiceProvider);
  final callService = ref.watch(callFirestoreServiceProvider);
  return CallNotifier(agora, callService);
});

final incomingCallsProvider = StreamProvider((ref) {
  final service = ref.watch(callFirestoreServiceProvider);
  return service.incomingCallsStream();
});
