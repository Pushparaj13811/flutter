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
            child: ConnectivityBanner(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
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

          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => IncomingCallOverlay(
                callerName: callerName,
                onAccept: () async {
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
