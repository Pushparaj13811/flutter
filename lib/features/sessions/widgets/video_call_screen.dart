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
  bool _hasPopped = false;

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

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) {
      _resetControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _resetControlsTimer() {
    _hideControlsTimer?.cancel();
    if (!_controlsVisible) {
      setState(() => _controlsVisible = true);
    }
    _hideControlsTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  void _safePop() {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    Navigator.of(context).pop();
  }

  Future<void> _endCallAndPop() async {
    await ref.read(callNotifierProvider.notifier).endCall();
    _safePop();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    // Do NOT end call on dispose — user might have pressed back to minimize
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

    // Auto-pop when call ends from remote side
    if ((callState.status == CallStatus.ended ||
            callState.status == CallStatus.declined) &&
        !_hasPopped) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _safePop());
    }

    return PopScope(
      canPop: true, // Allow back to minimize (like WhatsApp)
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _toggleControls,
          child: Stack(
            children: [
              // Remote video (full screen)
              if (callState.remoteUid != null && agora.engine != null)
                Positioned.fill(
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: agora.engine!,
                      canvas: VideoCanvas(uid: callState.remoteUid!),
                      connection: RtcConnection(channelId: widget.channelId),
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Center(
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
                            style:
                                AppTextStyles.h1.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.remoteUserName,
                          style:
                              AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _statusText(callState.status),
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),

              // Tap overlay — ensures taps register even over Agora video
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _toggleControls,
                  child: const SizedBox.expand(),
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

              // Top bar — always visible with back button
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_controlsVisible,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 8,
                        right: 16,
                        bottom: 12,
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
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: Text(
                              widget.remoteUserName,
                              style: AppTextStyles.labelLarge
                                  .copyWith(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (callState.status == CallStatus.active)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatDuration(callState.duration),
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_controlsVisible,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom:
                            MediaQuery.of(context).padding.bottom + 20,
                        top: 20,
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
                            icon: callState.isMuted
                                ? Icons.mic_off
                                : Icons.mic,
                            label: callState.isMuted ? 'Unmute' : 'Mute',
                            isActive: callState.isMuted,
                            onTap: () => ref
                                .read(callNotifierProvider.notifier)
                                .toggleMute(),
                          ),
                          _ControlButton(
                            icon: callState.isCameraOn
                                ? Icons.videocam
                                : Icons.videocam_off,
                            label: callState.isCameraOn
                                ? 'Camera Off'
                                : 'Camera On',
                            isActive: !callState.isCameraOn,
                            onTap: () => ref
                                .read(callNotifierProvider.notifier)
                                .toggleCamera(),
                          ),
                          _ControlButton(
                            icon: Icons.cameraswitch,
                            label: 'Flip',
                            onTap: () => ref
                                .read(callNotifierProvider.notifier)
                                .switchCamera(),
                          ),
                          _ControlButton(
                            icon: Icons.call_end,
                            label: 'End',
                            isDestructive: true,
                            onTap: _endCallAndPop,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(CallStatus status) {
    return switch (status) {
      CallStatus.ringing => 'Ringing...',
      CallStatus.connecting => 'Connecting...',
      CallStatus.active => 'Connected',
      CallStatus.ended => 'Call Ended',
      CallStatus.declined => 'Call Declined',
      CallStatus.idle => '',
    };
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
            width: 56,
            height: 56,
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
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
