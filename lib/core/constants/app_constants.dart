class AppConstants {
  AppConstants._();

  static const String appName = 'Skill Exchange';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File uploads
  static const int maxFileSize = 5242880; // 5 MB in bytes

  // Auth
  static const int tokenExpirySeconds = 86400; // 24 hours

  // UI behaviour
  static const int searchDebounceMs = 300;
  static const int animationDurationMs = 300;
}
