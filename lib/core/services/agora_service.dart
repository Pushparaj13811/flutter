import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill_exchange/core/constants/agora_config.dart';

class AgoraService {
  RtcEngine? _engine;
  bool _isInitialized = false;

  RtcEngine? get engine => _engine;
  bool get isInitialized => _isInitialized;

  Future<bool> requestPermissions() async {
    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    return camera.isGranted && mic.isGranted;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

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
    await _engine?.leaveChannel();
  }

  Future<void> toggleMute(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  Future<void> toggleCamera(bool enabled) async {
    if (enabled) {
      await _engine?.enableLocalVideo(true);
    } else {
      await _engine?.enableLocalVideo(false);
    }
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    _isInitialized = false;
  }
}

final agoraServiceProvider = Provider<AgoraService>((ref) {
  final service = AgoraService();
  ref.onDispose(() => service.dispose());
  return service;
});
