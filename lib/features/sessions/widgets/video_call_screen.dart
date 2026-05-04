import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.remoteUserName,
    required this.isCaller,
  });

  final String channelId;
  final String remoteUserName;
  final bool isCaller;

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _setupAgoraCallbacks();
    _resetControlsTimer();
  }

  void _setupAgoraCallbacks() {
    final agora = ref.read(agoraServiceProvider);
    final engine = agora.engine;
    if (engine == null) return;

    engine.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (connection, remoteUid, elapsed) {
        ref.read(callNotifierProvider.notifier).onRemoteUserJoined(remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        ref.read(callNotifierProvider.notifier).onRemoteUserLeft(remoteUid);
      },
    ));
  }

  void _resetControlsTimer() {
    _hideControlsTimer?.cancel();
    setState(() => _controlsVisible = true);
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callNotifierProvider);
    final agora = ref.read(agoraServiceProvider);

    // Auto-pop when call ends
    if (callState.status == CallStatus.ended ||
        callState.status == CallStatus.declined) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _resetControlsTimer,
        child: Stack(
          children: [
            // Remote video (full screen)
            if (callState.remoteUid != null && agora.engine != null)
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: agora.engine!,
                  canvas: VideoCanvas(uid: callState.remoteUid!),
                  connection: RtcConnection(channelId: widget.channelId),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white24,
                      child: Text(
                        widget.remoteUserName.isNotEmpty
                            ? widget.remoteUserName[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.h1.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.remoteUserName,
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      callState.status == CallStatus.ringing
                          ? 'Ringing...'
                          : callState.status == CallStatus.connecting
                              ? 'Connecting...'
                              : 'Waiting...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

            // Local video (PIP - top right)
            if (callState.isCameraOn && agora.engine != null)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 140,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: agora.engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),

            // Top bar
            if (_controlsVisible)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.remoteUserName,
                          style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (callState.status == CallStatus.active)
                        Text(
                          _formatDuration(callState.duration),
                          style: AppTextStyles.labelMedium.copyWith(color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ),

            // Bottom controls
            if (_controlsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    top: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: callState.isMuted ? Icons.mic_off : Icons.mic,
                        label: callState.isMuted ? 'Unmute' : 'Mute',
                        isActive: callState.isMuted,
                        onTap: () => ref.read(callNotifierProvider.notifier).toggleMute(),
                      ),
                      _ControlButton(
                        icon: callState.isCameraOn ? Icons.videocam : Icons.videocam_off,
                        label: callState.isCameraOn ? 'Camera Off' : 'Camera On',
                        isActive: !callState.isCameraOn,
                        onTap: () => ref.read(callNotifierProvider.notifier).toggleCamera(),
                      ),
                      _ControlButton(
                        icon: Icons.cameraswitch,
                        label: 'Flip',
                        onTap: () => ref.read(callNotifierProvider.notifier).switchCamera(),
                      ),
                      _ControlButton(
                        icon: Icons.call_end,
                        label: 'End',
                        isDestructive: true,
                        onTap: () => ref.read(callNotifierProvider.notifier).endCall(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red
                  : isActive
                      ? Colors.white
                      : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDestructive
                  ? Colors.white
                  : isActive
                      ? Colors.black
                      : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
