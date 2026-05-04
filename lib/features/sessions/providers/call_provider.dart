import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/core/services/call_sound_service.dart';
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
  final String? error;

  const CallState({
    this.status = CallStatus.idle,
    this.callId,
    this.remoteUserId,
    this.remoteUserName,
    this.isMuted = false,
    this.isCameraOn = true,
    this.remoteUid,
    this.duration = Duration.zero,
    this.error,
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
    String? error,
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
      error: error,
    );
  }
}

class CallNotifier extends StateNotifier<CallState> {
  final AgoraService _agora;
  final CallFirestoreService _callService;
  final CallSoundService _sound;
  StreamSubscription? _callStreamSub;
  Timer? _durationTimer;

  CallNotifier(this._agora, this._callService, this._sound)
      : super(const CallState());

  Future<bool> startCall(String calleeUid, String calleeName) async {
    if (!_agora.hasValidAppId) {
      state = state.copyWith(
        error: 'Video call not configured. Please set up Agora App ID.',
      );
      return false;
    }

    final hasPerms = await _agora.requestPermissions();
    if (!hasPerms) {
      state = state.copyWith(error: 'Camera and microphone permissions required.');
      return false;
    }

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
      _sound.playDialTone(); // Ring-back tone while waiting

      return true;
    } catch (e) {
      _sound.stop();
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
    _sound.stop();
    await _callService.declineCall(callId);
    state = const CallState();
  }

  Future<void> endCall() async {
    _sound.stop();
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
    _sound.stop(); // Stop dial/ring tone when connected
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
        _sound.stop();
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
  final sound = ref.watch(callSoundServiceProvider);
  return CallNotifier(agora, callService, sound);
});

final incomingCallsProvider = StreamProvider((ref) {
  final service = ref.watch(callFirestoreServiceProvider);
  return service.incomingCallsStream();
});
