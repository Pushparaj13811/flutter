/// Environment configuration.
///
/// Values are injected via `--dart-define` at build time.
///
/// Example:
/// ```
/// flutter run --dart-define=API_BASE_URL=https://api.skillexchange.com
/// ```
class EnvConfig {
  const EnvConfig._();

  /// API base URL for all HTTP requests.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  /// WebSocket URL for real-time messaging.
  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'ws://localhost:3000',
  );

  /// Whether mock data mode is enabled (for development without backend).
  /// Defaults to `true` until a real backend is available.
  /// Set to false via: `flutter run --dart-define=ENABLE_MOCK_DATA=false`
  static const bool enableMockData = bool.fromEnvironment(
    'ENABLE_MOCK_DATA',
    defaultValue: true,
  );

  /// HTTP request timeout in seconds.
  static const int apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30,
  );

  /// Default page size for paginated requests.
  static const int defaultPageSize = int.fromEnvironment(
    'DEFAULT_PAGE_SIZE',
    defaultValue: 20,
  );

  /// Maximum file upload size in bytes (default: 5MB).
  static const int maxFileSize = int.fromEnvironment(
    'MAX_FILE_SIZE',
    defaultValue: 5242880,
  );
}
