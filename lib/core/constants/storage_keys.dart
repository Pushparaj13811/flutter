class StorageKeys {
  StorageKeys._();

  // Auth tokens — stored in flutter_secure_storage
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // User session — stored in flutter_secure_storage
  static const String cachedUser = 'cached_user';
  static const String rememberMe = 'remember_me';

  // User preferences — stored in shared_preferences
  static const String notificationPreferences = 'notification_preferences';
  static const String privacySettings = 'privacy_settings';
  static const String themeMode = 'theme_mode';
  static const String blockedUsers = 'blocked_users';
}
