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
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: IncomingCallListener(
            child: Column(
              children: [
                // Active call banner — tap to return to call
                const _ActiveCallBanner(),
                Expanded(
                  child: ConnectivityBanner(child: child ?? const SizedBox.shrink()),
                ),
              ],
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

    // Only show when call is active/ringing/connecting but the call screen isn't visible
    if (callState.status == CallStatus.idle ||
        callState.status == CallStatus.ended ||
        callState.status == CallStatus.declined) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        // Return to call screen
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => VideoCallScreen(
              channelId: callState.callId ?? '',
              remoteUserName: callState.remoteUserName ?? 'Call',
              isCaller: true,
            ),
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
                    : 'Calling ${callState.remoteUserName ?? ''}...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (callState.status == CallStatus.active)
              Text(
                _formatDuration(callState.duration),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
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

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
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

          // Play ringtone for incoming call
          ref.read(callSoundServiceProvider).playRingtone();

          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => IncomingCallOverlay(
                callerName: callerName,
                onAccept: () async {
                  ref.read(callSoundServiceProvider).stop();
                  Navigator.of(context).pop();
                  final notifier = ref.read(callNotifierProvider.notifier);
                  final success = await notifier.acceptCall(callId, callerName);
                  if (success && context.mounted) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => VideoCallScreen(
                          channelId: callId,
                          remoteUserName: callerName,
                          isCaller: false,
                        ),
                      ),
                    );
                  }
                },
                onDecline: () {
                  ref.read(callSoundServiceProvider).stop();
                  Navigator.of(context).pop();
                  ref.read(callNotifierProvider.notifier).declineCall(callId);
                },
              ),
            ),
          );
        }
      });
    });

    return child;
  }
}
