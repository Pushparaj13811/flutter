import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/services/fcm_service.dart';
import 'package:skill_exchange/core/theme/app_theme.dart';
import 'package:skill_exchange/core/widgets/connectivity_banner.dart';
import 'package:skill_exchange/features/settings/providers/theme_provider.dart';
import 'package:skill_exchange/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          child: ConnectivityBanner(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
