import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/core/constants/storage_keys.dart';

class PreferencesSource {
  final SharedPreferences _prefs;

  PreferencesSource(this._prefs);

  // ── Cached User ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getCachedUser() async {
    final json = _prefs.getString(StorageKeys.cachedUser);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<void> saveCachedUser(Map<String, dynamic> user) async {
    await _prefs.setString(StorageKeys.cachedUser, jsonEncode(user));
  }

  Future<void> clearCachedUser() async {
    await _prefs.remove(StorageKeys.cachedUser);
  }

  // ── Remember Me ───────────────────────────────────────────────────────

  bool getRememberMe() {
    return _prefs.getBool(StorageKeys.rememberMe) ?? false;
  }

  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(StorageKeys.rememberMe, value);
  }

  // ── Theme Mode ────────────────────────────────────────────────────────

  String? getThemeMode() {
    return _prefs.getString(StorageKeys.themeMode);
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode);
  }

  // ── Notification Preferences ──────────────────────────────────────────

  Map<String, dynamic>? getNotificationPreferences() {
    final json = _prefs.getString(StorageKeys.notificationPreferences);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<void> setNotificationPreferences(Map<String, dynamic> prefs) async {
    await _prefs.setString(
      StorageKeys.notificationPreferences,
      jsonEncode(prefs),
    );
  }

  // ── Privacy Settings ──────────────────────────────────────────────────

  Map<String, dynamic>? getPrivacySettings() {
    final json = _prefs.getString(StorageKeys.privacySettings);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<void> setPrivacySettings(Map<String, dynamic> settings) async {
    await _prefs.setString(StorageKeys.privacySettings, jsonEncode(settings));
  }

  // ── Blocked Users ─────────────────────────────────────────────────────

  List<String> getBlockedUsers() {
    final json = _prefs.getString(StorageKeys.blockedUsers);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.cast<String>();
  }

  Future<void> setBlockedUsers(List<String> userIds) async {
    await _prefs.setString(StorageKeys.blockedUsers, jsonEncode(userIds));
  }

  // ── Clear All ─────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
