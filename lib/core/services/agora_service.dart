import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill_exchange/core/constants/agora_config.dart';

class AgoraService {
  RtcEngine? _engine;
  bool _isInitialized = false;

  RtcEngine? get engine => _engine;
  bool get isInitialized => _isInitialized;

  bool get hasValidAppId =>
      AgoraConfig.appId.isNotEmpty &&
      AgoraConfig.appId != 'YOUR_AGORA_APP_ID';

  Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;

    // If permanently denied, open settings
    if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    return camera.isGranted && mic.isGranted;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    if (!hasValidAppId) {
      throw Exception(
        'Agora App ID not configured. '
        'Get one from https://console.agora.io and set it in '
        'lib/core/constants/agora_config.dart',
      );
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: AgoraConfig.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await _engine!.enableVideo();
    await _engine!.startPreview();

    _isInitialized = true;
  }

  Future<void> joinChannel(String channelId, int uid) async {
    if (!_isInitialized) await initialize();

    await _engine!.joinChannel(
      token: AgoraConfig.token ?? '',
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leaveChannel() async {
    try {
      await _engine?.leaveChannel();
    } catch (e) {
      debugPrint('AgoraService.leaveChannel error: $e');
    }
  }

  Future<void> toggleMute(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  Future<void> toggleCamera(bool enabled) async {
    await _engine?.enableLocalVideo(enabled);
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  Future<void> dispose() async {
    try {
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (e) {
      debugPrint('AgoraService.dispose error: $e');
    }
    _engine = null;
    _isInitialized = false;
  }
}

final agoraServiceProvider = Provider<AgoraService>((ref) {
  final service = AgoraService();
  ref.onDispose(() => service.dispose());
  return service;
});
