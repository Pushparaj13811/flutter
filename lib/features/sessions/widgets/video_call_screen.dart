import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/core/services/call_sound_service.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/services/call_overlay_service.dart';
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.remoteUserName,
    required this.isCaller,
    this.calleeId, // Only for caller — screen will call startCall itself
  });

  final String channelId;
  final String remoteUserName;
  final bool isCaller;
  final String? calleeId; // Only for caller — the screen will call startCall itself

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;
  bool _hasPopped = false;
  bool _callbacksRegistered = false;

  // PIP state: which video is in the small PIP window
  // false = local video in PIP (default), true = remote video in PIP
  bool _remoteInPip = false;

  // Draggable PIP position
  double _pipLeft = -1; // -1 means not initialized yet
  double _pipTop = -1;
  static const double _pipW = 110;
  static const double _pipH = 150;

  @override
  void initState() {
    super.initState();
    callOverlay.onCallScreenOpened();
    _resetControlsTimer();
    if (widget.isCaller && widget.calleeId != null) {
      // Caller flow: screen opened first, now initiate the call
      _initiateCall();
    } else {
      // Callee flow (or re-open via PIP/banner): Agora is already ready
      _setupAgoraCallbacks();
    }
  }

  Future<void> _initiateCall() async {
    final notifier = ref.read(callNotifierProvider.notifier);
    final success =
        await notifier.startCall(widget.calleeId!, widget.remoteUserName);
    if (success && mounted) {
      _setupAgoraCallbacks();
      final sound = ref.read(callSoundServiceProvider);
      if (!sound.isPlaying) sound.playDialTone();
    } else if (!success && mounted) {
      final error = ref.read(callNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to start call'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _setupAgoraCallbacks() {
    if (_callbacksRegistered) return;
    final agora = ref.read(agoraServiceProvider);
    final engine = agora.engine;
    if (engine == null) return;
    _callbacksRegistered = true;

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
    if (!_controlsVisible) setState(() => _controlsVisible = true);
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

  void _swapVideos() {
    // Only swap when both local camera and remote video are available
    final callState = ref.read(callNotifierProvider);
    final agora = ref.read(agoraServiceProvider);
    if (callState.remoteUid == null || agora.engine == null || !callState.isCameraOn) return;
    setState(() => _remoteInPip = !_remoteInPip);
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    callOverlay.onCallScreenClosed();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callNotifierProvider);
    final agora = ref.read(agoraServiceProvider);
    final hasRemote = callState.remoteUid != null && agora.engine != null;
    final hasCamera = callState.isCameraOn && agora.engine != null;

    // Reset swap if conditions are no longer met
    if (_remoteInPip && (!hasRemote || !hasCamera)) {
      _remoteInPip = false;
    }

    // Initialize PIP position on first build
    if (_pipLeft < 0) {
      final size = MediaQuery.of(context).size;
      _pipLeft = size.width - _pipW - 12;
      _pipTop = MediaQuery.of(context).padding.top + 12;
    }

    // Auto-pop when call ends from remote side
    if ((callState.status == CallStatus.ended ||
            callState.status == CallStatus.declined) &&
        !_hasPopped) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _safePop());
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _toggleControls,
          child: Stack(
            children: [
              // ── Full-screen video ──────────────────────────────────────
              _buildFullScreenView(callState, agora, hasRemote, hasCamera),

              // ── Tap overlay for controls toggle ────────────────────────
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _toggleControls,
                  child: const SizedBox.expand(),
                ),
              ),

              // ── Draggable PIP (swappable) ──────────────────────────────
              if (hasCamera || hasRemote)
                _buildDraggablePip(callState, agora, hasRemote, hasCamera),

              // ── Top bar ────────────────────────────────────────────────
              _buildTopBar(context, callState),

              // ── Bottom controls ────────────────────────────────────────
              _buildBottomControls(context, callState),
            ],
          ),
        ),
      ),
    );
  }

  // ── Full-screen view (shows remote by default, local if swapped) ─────────

  Widget _buildFullScreenView(
      CallState callState, AgoraService agora, bool hasRemote, bool hasCamera) {
    if (_remoteInPip) {
      // Local video full-screen
      if (hasCamera) {
        return Positioned.fill(
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: agora.engine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        );
      }
    } else {
      // Remote video full-screen (default)
      if (hasRemote) {
        return Positioned.fill(
          child: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: agora.engine!,
              canvas: VideoCanvas(uid: callState.remoteUid!),
              connection: RtcConnection(channelId: widget.channelId),
            ),
          ),
        );
      }
    }

    // Placeholder when no video
    return Positioned.fill(
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
              _statusText(callState.status),
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // ── Draggable PIP (shows local by default, remote if swapped) ────────────

  Widget _buildDraggablePip(
      CallState callState, AgoraService agora, bool hasRemote, bool hasCamera) {
    final bool showPip = _remoteInPip ? hasRemote : hasCamera;
    if (!showPip) return const SizedBox.shrink();

    return Positioned(
      left: _pipLeft,
      top: _pipTop,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final size = MediaQuery.of(context).size;
            _pipLeft = (_pipLeft + details.delta.dx).clamp(0, size.width - _pipW);
            _pipTop = (_pipTop + details.delta.dy).clamp(
              MediaQuery.of(context).padding.top,
              size.height - _pipH - 100,
            );
          });
        },
        onTap: _swapVideos, // Tap PIP to swap full-screen and PIP
        child: Container(
          width: _pipW,
          height: _pipH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white30, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Video content
                if (_remoteInPip && hasRemote)
                  AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: agora.engine!,
                      canvas: VideoCanvas(uid: callState.remoteUid!),
                      connection: RtcConnection(channelId: widget.channelId),
                    ),
                  )
                else if (!_remoteInPip && hasCamera)
                  AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agora.engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),

                // Swap icon hint
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, CallState callState) {
    return Positioned(
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    widget.remoteUserName,
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (callState.status == CallStatus.active)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDuration(callState.duration),
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom controls ────────────────────────────────────────────────────────

  Widget _buildBottomControls(BuildContext context, CallState callState) {
    return Positioned(
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
              bottom: MediaQuery.of(context).padding.bottom + 20,
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
                  icon: callState.isMuted ? Icons.mic_off : Icons.mic,
                  label: callState.isMuted ? 'Unmute' : 'Mute',
                  isActive: callState.isMuted,
                  onTap: () =>
                      ref.read(callNotifierProvider.notifier).toggleMute(),
                ),
                _ControlButton(
                  icon: callState.isCameraOn
                      ? Icons.videocam
                      : Icons.videocam_off,
                  label: callState.isCameraOn ? 'Camera Off' : 'Camera On',
                  isActive: !callState.isCameraOn,
                  onTap: () =>
                      ref.read(callNotifierProvider.notifier).toggleCamera(),
                ),
                _ControlButton(
                  icon: Icons.cameraswitch,
                  label: 'Flip',
                  onTap: () =>
                      ref.read(callNotifierProvider.notifier).switchCamera(),
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
    );
  }

  String _statusText(CallStatus status) {
    return switch (status) {
      CallStatus.calling => 'Calling...',
      CallStatus.ringing => 'Ringing...',
      CallStatus.connecting => 'Connecting...',
      CallStatus.active => 'Connected',
      CallStatus.ended => 'Call Ended',
      CallStatus.declined => 'Call Declined',
      CallStatus.idle => '',
    };
  }
}

// ── Control Button ────────────────────────────────────────────────────────────

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
