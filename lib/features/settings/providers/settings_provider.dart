// Settings state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Storage Keys ──────────────────────────────────────────────────────────

class _SettingsKeys {
  const _SettingsKeys._();

  static const String pushNotifications = 'settings_push_notifications';
  static const String emailNotifications = 'settings_email_notifications';
  static const String sessionReminders = 'settings_session_reminders';
  static const String profileVisibility = 'settings_profile_visibility';
  static const String showEmail = 'settings_show_email';
  static const String showAvailability = 'settings_show_availability';
  static const String themeMode = 'settings_theme_mode';
}

// ── Settings State ────────────────────────────────────────────────────────

class SettingsState {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool sessionReminders;
  final String profileVisibility;
  final bool showEmail;
  final bool showAvailability;
  final String themeMode;

  const SettingsState({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.sessionReminders = true,
    this.profileVisibility = 'public',
    this.showEmail = true,
    this.showAvailability = true,
    this.themeMode = 'system',
  });

  SettingsState copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? sessionReminders,
    String? profileVisibility,
    bool? showEmail,
    bool? showAvailability,
    String? themeMode,
  }) {
    return SettingsState(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      sessionReminders: sessionReminders ?? this.sessionReminders,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      showEmail: showEmail ?? this.showEmail,
      showAvailability: showAvailability ?? this.showAvailability,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

// ── Settings Notifier ─────────────────────────────────────────────────────

class SettingsNotifier extends StateNotifier<AsyncValue<SettingsState>> {
  SettingsNotifier() : super(const AsyncValue.loading()) {
    loadSettings();
  }

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await _getPrefs();

      final settings = SettingsState(
        pushNotifications:
            prefs.getBool(_SettingsKeys.pushNotifications) ?? true,
        emailNotifications:
            prefs.getBool(_SettingsKeys.emailNotifications) ?? true,
        sessionReminders:
            prefs.getBool(_SettingsKeys.sessionReminders) ?? true,
        profileVisibility:
            prefs.getString(_SettingsKeys.profileVisibility) ?? 'public',
        showEmail: prefs.getBool(_SettingsKeys.showEmail) ?? true,
        showAvailability:
            prefs.getBool(_SettingsKeys.showAvailability) ?? true,
        themeMode: prefs.getString(_SettingsKeys.themeMode) ?? 'system',
      );

      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePushNotifications(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(pushNotifications: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setBool(_SettingsKeys.pushNotifications, value);
  }

  Future<void> updateEmailNotifications(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(emailNotifications: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setBool(_SettingsKeys.emailNotifications, value);
  }

  Future<void> updateSessionReminders(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(sessionReminders: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setBool(_SettingsKeys.sessionReminders, value);
  }

  Future<void> updateProfileVisibility(String value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(profileVisibility: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setString(_SettingsKeys.profileVisibility, value);
  }

  Future<void> updateShowEmail(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(showEmail: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setBool(_SettingsKeys.showEmail, value);
  }

  Future<void> updateShowAvailability(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(showAvailability: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setBool(_SettingsKeys.showAvailability, value);
  }

  Future<void> updateThemeMode(String value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(themeMode: value);
    state = AsyncValue.data(updated);

    final prefs = await _getPrefs();
    await prefs.setString(_SettingsKeys.themeMode, value);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsState>>((ref) {
  return SettingsNotifier();
});
