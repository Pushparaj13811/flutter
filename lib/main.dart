import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/services/fcm_service.dart';
import 'package:skill_exchange/core/theme/app_theme.dart';
import 'package:skill_exchange/core/widgets/connectivity_banner.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/core/services/call_overlay_service.dart';
import 'package:skill_exchange/core/services/call_sound_service.dart';
import 'package:skill_exchange/core/services/presence_service.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';
import 'package:skill_exchange/features/sessions/widgets/incoming_call_overlay.dart';
import 'package:skill_exchange/features/sessions/widgets/video_call_screen.dart';
import 'package:skill_exchange/features/settings/providers/theme_provider.dart';
import 'package:skill_exchange/firebase_options.dart';

/// Top-level background message handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  try {
    await FcmService().initialize();
  } catch (_) {
    // FCM init may fail if user doc doesn't exist yet — non-blocking
  }
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SkillExchangeApp(),
    ),
  );
}

class SkillExchangeApp extends ConsumerWidget {
  const SkillExchangeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Start presence tracking when authenticated
    ref.listen(authProvider, (prev, next) {
      final presenceService = ref.read(presenceServiceProvider);
      if (next is AuthAuthenticated) {
        presenceService.startTracking();
      } else {
        presenceService.stopTracking();
      }
    });

    return MaterialApp.router(
      title: 'Skill Exchange',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        // Store context for call overlay navigation
        callOverlay.setContext(context);
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: IncomingCallListener(
            child: FloatingCallPip(
              child: Column(
                children: [
                  const _ActiveCallBanner(),
                  Expanded(
                    child: ConnectivityBanner(child: child ?? const SizedBox.shrink()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActiveCallBanner extends ConsumerWidget {
  const _ActiveCallBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callNotifierProvider);

    if (callState.status == CallStatus.idle ||
        callState.status == CallStatus.ended ||
        callState.status == CallStatus.declined) {
      return const SizedBox.shrink();
    }

    // Compact green banner — tap to return to full call screen
    return GestureDetector(
      onTap: () {
        if (callOverlay.isCallScreenVisible.value) return;
        callOverlay.openCallScreen(
          VideoCallScreen(
            channelId: callState.callId ?? '',
            remoteUserName: callState.remoteUserName ?? 'Call',
            isCaller: true,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4,
          bottom: 8,
          left: 16,
          right: 16,
        ),
        color: const Color(0xFF059669),
        child: Row(
          children: [
            const Icon(Icons.videocam, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                callState.status == CallStatus.active
                    ? 'Tap to return to call'
                    : callState.status == CallStatus.calling
                        ? 'Calling ${callState.remoteUserName ?? ''}...'
                        : 'Ringing ${callState.remoteUserName ?? ''}...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (callState.status == CallStatus.active)
              _DurationText(callState.duration),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ref.read(callNotifierProvider.notifier).endCall(),
              child: const Icon(Icons.call_end, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationText extends StatelessWidget {
  const _DurationText(this.duration);
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Text('$m:$s', style: const TextStyle(color: Colors.white70, fontSize: 12));
  }
}

/// Floating PIP overlay that shows during an active call when the user
/// navigates away from the call screen. Draggable, tappable to return
/// to full screen, with end-call button.
class FloatingCallPip extends ConsumerStatefulWidget {
  const FloatingCallPip({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<FloatingCallPip> createState() => _FloatingCallPipState();
}

class _FloatingCallPipState extends ConsumerState<FloatingCallPip>
    with SingleTickerProviderStateMixin {
  static const double _pipWidth = 120;
  static const double _pipHeight = 160;
  static const double _edgePadding = 8;

  double _left = _edgePadding;
  double _top = 120;
  bool _isDragging = false;

  late AnimationController _snapController;
  Animation<Offset>? _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_snapAnimation != null) {
          setState(() {
            _left = _snapAnimation!.value.dx;
            _top = _snapAnimation!.value.dy;
          });
        }
      });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _snapToEdge() {
    final size = MediaQuery.of(context).size;
    final centerX = _left + _pipWidth / 2;
    final targetX = centerX < size.width / 2
        ? _edgePadding
        : size.width - _pipWidth - _edgePadding;
    final targetY = _top.clamp(
      MediaQuery.of(context).padding.top + _edgePadding,
      size.height - _pipHeight - _edgePadding - 80,
    );

    _snapAnimation = Tween<Offset>(
      begin: Offset(_left, _top),
      end: Offset(targetX, targetY),
    ).animate(CurvedAnimation(
      parent: _snapController,
      curve: Curves.easeOutCubic,
    ));
    _snapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callNotifierProvider);
    final agora = ref.read(agoraServiceProvider);
    final isActive = callState.status == CallStatus.active;

    final hasActiveCall = callState.status != CallStatus.idle &&
        callState.status != CallStatus.ended &&
        callState.status != CallStatus.declined;

    return Stack(
      children: [
        widget.child,

        // Only show PIP when call is active AND call screen is NOT visible
        if (hasActiveCall)
          ValueListenableBuilder<bool>(
            valueListenable: callOverlay.isCallScreenVisible,
            builder: (context, isVisible, _) {
              if (isVisible) return const SizedBox.shrink();
              return _buildPipWidget(context, callState, agora, isActive);
            },
          ),
      ],
    );
  }

  Widget _buildPipWidget(BuildContext context, CallState callState,
      AgoraService agora, bool isActive) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        onPanStart: (_) {
          _isDragging = true;
          _snapController.stop();
        },
        onPanUpdate: (details) {
          setState(() {
            final size = MediaQuery.of(context).size;
            _left = (_left + details.delta.dx)
                .clamp(0, size.width - _pipWidth);
            _top = (_top + details.delta.dy).clamp(
              MediaQuery.of(context).padding.top,
              size.height - _pipHeight - 80,
            );
          });
        },
        onPanEnd: (_) {
          _isDragging = false;
          _snapToEdge();
        },
        onTap: () {
          callOverlay.openCallScreen(
            VideoCallScreen(
              channelId: callState.callId ?? '',
              remoteUserName: callState.remoteUserName ?? 'Call',
              isCaller: true,
            ),
          );
        },
        child: Material(
          elevation: _isDragging ? 16 : 8,
          shadowColor: Colors.black45,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: _pipWidth,
            height: _pipHeight,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF059669),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  if (isActive &&
                      callState.remoteUid != null &&
                      agora.engine != null)
                    AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: agora.engine!,
                        canvas: VideoCanvas(uid: callState.remoteUid!),
                        connection:
                            RtcConnection(channelId: callState.callId ?? ''),
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            child: Text(
                              (callState.remoteUserName ?? '?').isNotEmpty
                                  ? callState.remoteUserName![0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            callState.status == CallStatus.calling
                                ? 'Calling...'
                                : callState.status == CallStatus.ringing
                                    ? 'Ringing...'
                                    : 'Connecting...',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // End call button
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () =>
                            ref.read(callNotifierProvider.notifier).endCall(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Duration badge
                  if (isActive)
                    Positioned(
                      top: 4,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _DurationText(callState.duration),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IncomingCallListener extends ConsumerWidget {
  const IncomingCallListener({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(incomingCallsProvider, (previous, next) {
      next.whenData((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          final data = doc.data();
          final callId = doc.id;
          final callerName = data['callerName'] as String? ?? 'Unknown';

          // Only react to calls created within the last 30 seconds
          final createdAt = data['createdAt'] as Timestamp?;
          if (createdAt != null) {
            final age = DateTime.now().difference(createdAt.toDate());
            if (age.inSeconds > 30) return; // Skip old/stale calls
          }

          // Don't show overlay if we're already in a call
          final currentCall = ref.read(callNotifierProvider);
          if (currentCall.status != CallStatus.idle) return;

          // Play ringtone for incoming call
          ref.read(callSoundServiceProvider).playRingtone();

          callOverlay.openCallScreen(
            IncomingCallOverlay(
              callerName: callerName,
              onAccept: () async {
                ref.read(callSoundServiceProvider).stop();
                if (context.mounted) Navigator.of(context, rootNavigator: true).maybePop();
                final notifier = ref.read(callNotifierProvider.notifier);
                final success = await notifier.acceptCall(callId, callerName);
                if (success) {
                  callOverlay.openCallScreen(
                    VideoCallScreen(
                      channelId: callId,
                      remoteUserName: callerName,
                      isCaller: false,
                    ),
                  );
                }
              },
              onDecline: () {
                ref.read(callSoundServiceProvider).stop();
                if (context.mounted) Navigator.of(context, rootNavigator: true).maybePop();
                ref.read(callNotifierProvider.notifier).declineCall(callId);
              },
            ),
          );
        }
      });
    });

    return child;
  }
}
