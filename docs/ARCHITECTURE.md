# Skill Exchange — Flutter Architecture Document

> This is the definitive architecture reference for the Flutter Skill Exchange app.
> Every structural decision is documented and justified here.
> All implementation must conform to this document.

---

## Table of Contents

1. [Package Selection](#1-package-selection)
2. [Folder Structure](#2-folder-structure)
3. [Layer Responsibilities](#3-layer-responsibilities)
4. [Networking Architecture](#4-networking-architecture)
5. [Authentication Architecture](#5-authentication-architecture)
6. [Riverpod State Management Patterns](#6-riverpod-state-management-patterns)
7. [Theme System](#7-theme-system)
8. [Navigation Architecture](#8-navigation-architecture)
9. [Shared Widget Catalogue](#9-shared-widget-catalogue)
10. [Feature Modules](#10-feature-modules)

---

## 1. Package Selection

Every package is justified against alternatives. Only actively maintained,
null-safe, Flutter 3.x compatible packages are used.

### State Management: **Riverpod 2.x with code generation**

| Evaluated | Decision |
|-----------|----------|
| Riverpod 2.x + riverpod_generator | **CHOSEN** |
| BLoC | Rejected — excessive boilerplate for this app's complexity |
| Provider | Rejected — Riverpod is its successor with better testing, no BuildContext dependency |

**Justification:** The React app uses a mix of Zustand (global client state), Jotai (atomic UI state),
and React Query (server state with caching). Riverpod mirrors all three:
- `Notifier` / `AsyncNotifier` replaces Zustand stores
- Simple `Provider` / `StateProvider` replaces Jotai atoms
- `FutureProvider` / `AsyncNotifierProvider` with `ref.invalidate()` replaces React Query's
  `useQuery` + `useMutation` + `invalidateQueries` pattern
- Code generation via `riverpod_generator` reduces boilerplate
- `ref.keepAlive()` replaces React Query's `gcTime` for caching

### Navigation: **go_router**

| Evaluated | Decision |
|-----------|----------|
| go_router | **CHOSEN** |
| auto_route | Rejected — code generation overhead, go_router is simpler for this app |

**Justification:** The React app uses react-router-dom v7 with `createBrowserRouter` —
a declarative, path-based router. go_router is the direct Flutter equivalent:
- Declarative route definitions
- Path parameters (`:userId`, `:conversationId`)
- Redirect-based auth guards (mirrors `ProtectedRoute`)
- `ShellRoute` for bottom navigation (mirrors `DashboardLayout`)
- Deep link support on iOS and Android out of the box
- Official Flutter team backing

### HTTP Client: **Dio**

| Evaluated | Decision |
|-----------|----------|
| dio | **CHOSEN** |
| http | Rejected — no interceptor support, no request cancellation |

**Justification:** The React app uses Axios with interceptors for auth token injection,
error mapping, and logging. Dio provides identical capabilities:
- Request/response interceptors (auth, logging, error mapping)
- Request cancellation via `CancelToken`
- `FormData` support for file uploads (avatar, attachments)
- Configurable timeouts and retry logic

### Local Storage

| Purpose | Package | Justification |
|---------|---------|---------------|
| Sensitive data (tokens) | `flutter_secure_storage` | Encrypted keychain (iOS) / keystore (Android) |
| Non-sensitive preferences | `shared_preferences` | Simple key-value for settings, UI prefs |

The React app stores tokens in `localStorage` and settings in `localStorage`.
On mobile, tokens must be in secure storage. Preferences (notification settings,
privacy settings, theme) go in shared_preferences.

### Dependency Injection: **Riverpod providers**

No separate DI package. Riverpod providers serve as the DI container.
Repository implementations are provided via `Provider` and overridden in tests.

### Image Handling

| Package | Purpose |
|---------|---------|
| `cached_network_image` | Remote avatar and image display with caching |
| `image_picker` | Camera/gallery image selection for avatar upload |

### Form Handling: **reactive_forms**

| Evaluated | Decision |
|-----------|----------|
| reactive_forms | **CHOSEN** |
| flutter_form_builder + form_builder_validators | Rejected — less composable, weaker validation |

**Justification:** The React app uses react-hook-form + Zod for form state and validation.
reactive_forms provides the closest Flutter equivalent:
- Reactive form groups with typed controls
- Built-in validators mirroring Zod schemas
- Async validators for server-side checks
- FormArray support for dynamic skill lists

### Real-time Communication: **web_socket_channel**

The React app has `VITE_WS_URL` configured and messaging with real-time characteristics.
`web_socket_channel` is the standard Dart WebSocket implementation. If the backend uses
Socket.IO, `socket_io_client` will be used instead.

### Push Notifications

| Package | Purpose |
|---------|---------|
| `firebase_messaging` | Remote push notification delivery |
| `flutter_local_notifications` | Local notification display and scheduling |

The React app has 7 notification types (connection_request, connection_accepted,
session_reminder, session_cancelled, new_message, review_received, system).
These need push notification support on mobile.

### Code Generation

| Package | Purpose |
|---------|---------|
| `build_runner` | Runs code generators |
| `freezed` + `freezed_annotation` | Immutable data classes with copyWith, equality |
| `json_annotation` + `json_serializable` | JSON serialisation/deserialisation |
| `riverpod_generator` + `riverpod_annotation` | Riverpod provider code generation |

### Additional Packages

| Package | Purpose |
|---------|---------|
| `fpdart` | `Either<Failure, T>` for typed error handling in repositories |
| `intl` | Date/time formatting (replaces date-fns) |
| `url_launcher` | Opening external links, meeting URLs |
| `shimmer` | Loading skeleton animations (replaces skeleton component) |
| `flutter_rating_bar` | Star rating display and input |
| `timeago` | Relative time formatting ("5m ago", "2h ago") |
| `connectivity_plus` | Network status detection for offline handling |

### Final pubspec.yaml Dependencies

```yaml
name: skill_exchange
description: Skill Exchange — connect, teach, and learn from each other.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.11.1

dependencies:
  flutter:
    sdk: flutter

  # UI
  cupertino_icons: ^1.0.8
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  flutter_rating_bar: ^4.0.1
  timeago: ^3.7.0
  url_launcher: ^6.3.1

  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Navigation
  go_router: ^14.8.1

  # Networking
  dio: ^5.7.0
  web_socket_channel: ^3.0.2
  connectivity_plus: ^6.1.2

  # Local Storage
  flutter_secure_storage: ^9.2.4
  shared_preferences: ^2.3.5

  # Forms
  reactive_forms: ^17.1.1

  # Serialisation
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Functional Programming
  fpdart: ^1.1.0

  # Firebase (notifications)
  firebase_core: ^3.12.1
  firebase_messaging: ^15.2.5
  flutter_local_notifications: ^18.0.1

  # Media
  image_picker: ^1.1.2

  # Utilities
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

  # Code Generation
  build_runner: ^2.4.14
  freezed: ^2.5.8
  json_serializable: ^6.9.4
  riverpod_generator: ^2.6.3

  # Testing
  mocktail: ^1.0.4
  riverpod_test: ^0.1.0

flutter:
  uses-material-design: true
```

---

## 2. Folder Structure

Feature-first organisation. Every directory has a clear, single responsibility.

```
lib/
├── core/                         # App-wide shared code
│   ├── constants/                # App-wide constants
│   │   ├── app_constants.dart    # App name, version, defaults
│   │   ├── api_endpoints.dart    # All API path constants (from apiConfig.ts)
│   │   └── storage_keys.dart     # All storage key strings
│   │
│   ├── errors/                   # Error handling
│   │   ├── failures.dart         # Failure sealed class hierarchy
│   │   └── exceptions.dart       # Typed exception classes
│   │
│   ├── extensions/               # Dart extensions
│   │   ├── context_extensions.dart    # BuildContext helpers (theme, mediaQuery)
│   │   ├── string_extensions.dart     # String utilities
│   │   └── date_extensions.dart       # DateTime formatting helpers
│   │
│   ├── theme/                    # Complete design system
│   │   ├── app_colors.dart       # All color constants (light + dark)
│   │   ├── app_text_styles.dart  # All TextStyle definitions
│   │   ├── app_spacing.dart      # Spacing constants (4, 8, 12, 16, 24, 32)
│   │   ├── app_radius.dart       # BorderRadius constants
│   │   ├── app_shadows.dart      # BoxShadow definitions
│   │   └── app_theme.dart        # ThemeData for light and dark modes
│   │
│   ├── utils/                    # Pure utility functions
│   │   ├── validators.dart       # Shared validation logic
│   │   └── formatters.dart       # Number, date, currency formatters
│   │
│   └── widgets/                  # Shared widgets used across 2+ features
│       ├── app_button.dart       # AppButton with variants
│       ├── app_text_field.dart   # AppTextField with decoration
│       ├── app_card.dart         # AppCard wrapper
│       ├── user_avatar.dart      # UserAvatar with size variants
│       ├── skill_tag.dart        # SkillTag with level colours
│       ├── star_rating.dart      # StarRating (readonly + interactive)
│       ├── loading_spinner.dart  # LoadingSpinner with size
│       ├── skeleton_card.dart    # SkeletonCard loading placeholder
│       ├── empty_state.dart      # EmptyState with icon, title, action
│       ├── error_message.dart    # ErrorMessage with retry button
│       └── search_bar.dart       # SearchBar with clear button
│
├── data/                         # Data layer — implementations
│   ├── models/                   # Freezed data classes with JSON
│   │   ├── user_model.dart       # + user_model.freezed.dart + .g.dart (generated)
│   │   ├── user_profile_model.dart
│   │   ├── skill_model.dart
│   │   ├── match_score_model.dart
│   │   ├── connection_model.dart
│   │   ├── session_model.dart
│   │   ├── message_model.dart
│   │   ├── conversation_model.dart
│   │   ├── review_model.dart
│   │   ├── notification_model.dart
│   │   ├── discussion_post_model.dart
│   │   ├── learning_circle_model.dart
│   │   ├── leaderboard_entry_model.dart
│   │   ├── user_report_model.dart
│   │   ├── platform_stats_model.dart
│   │   ├── search_result_model.dart
│   │   └── api_response_model.dart   # ApiResponse<T>, PaginatedResponse<T>
│   │
│   ├── repositories/             # Repository implementations
│   │   ├── auth_repository_impl.dart
│   │   ├── profile_repository_impl.dart
│   │   ├── matching_repository_impl.dart
│   │   ├── connection_repository_impl.dart
│   │   ├── session_repository_impl.dart
│   │   ├── messaging_repository_impl.dart
│   │   ├── review_repository_impl.dart
│   │   ├── notification_repository_impl.dart
│   │   ├── search_repository_impl.dart
│   │   ├── community_repository_impl.dart
│   │   └── admin_repository_impl.dart
│   │
│   └── sources/
│       ├── remote/               # Dio API clients
│       │   ├── auth_remote_source.dart
│       │   ├── profile_remote_source.dart
│       │   ├── matching_remote_source.dart
│       │   ├── connection_remote_source.dart
│       │   ├── session_remote_source.dart
│       │   ├── messaging_remote_source.dart
│       │   ├── review_remote_source.dart
│       │   ├── notification_remote_source.dart
│       │   ├── search_remote_source.dart
│       │   ├── community_remote_source.dart
│       │   └── admin_remote_source.dart
│       │
│       └── local/                # Local storage wrappers
│           ├── secure_storage_source.dart    # Token read/write
│           └── preferences_source.dart       # Settings, UI prefs
│
├── domain/                       # Domain layer — pure business logic
│   ├── entities/                 # Pure domain objects (no JSON)
│   │   ├── user.dart
│   │   ├── user_profile.dart
│   │   ├── skill.dart
│   │   ├── match_score.dart
│   │   ├── connection.dart
│   │   ├── session.dart
│   │   ├── message.dart
│   │   ├── conversation.dart
│   │   ├── review.dart
│   │   ├── notification.dart
│   │   ├── discussion_post.dart
│   │   ├── learning_circle.dart
│   │   └── leaderboard_entry.dart
│   │
│   └── repositories/            # Abstract repository interfaces
│       ├── auth_repository.dart
│       ├── profile_repository.dart
│       ├── matching_repository.dart
│       ├── connection_repository.dart
│       ├── session_repository.dart
│       ├── messaging_repository.dart
│       ├── review_repository.dart
│       ├── notification_repository.dart
│       ├── search_repository.dart
│       ├── community_repository.dart
│       └── admin_repository.dart
│
├── features/                     # Feature modules (one per feature)
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   │   └── verify_email_screen.dart
│   │   └── widgets/
│   │       ├── google_oauth_button.dart
│   │       └── password_strength_indicator.dart
│   │
│   ├── dashboard/
│   │   ├── providers/
│   │   │   └── dashboard_provider.dart
│   │   ├── screens/
│   │   │   └── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── stats_grid.dart
│   │       ├── top_matches_section.dart
│   │       └── upcoming_sessions_section.dart
│   │
│   ├── profile/
│   │   ├── providers/
│   │   │   └── profile_provider.dart
│   │   ├── screens/
│   │   │   └── profile_screen.dart
│   │   └── widgets/
│   │       ├── profile_view.dart
│   │       ├── profile_edit.dart
│   │       ├── skills_section.dart
│   │       ├── availability_grid.dart
│   │       ├── report_user_sheet.dart
│   │       └── block_user_sheet.dart
│   │
│   ├── matching/
│   │   ├── providers/
│   │   │   └── matching_provider.dart
│   │   ├── screens/
│   │   │   └── matching_screen.dart
│   │   └── widgets/
│   │       ├── match_card.dart
│   │       ├── matching_filters.dart
│   │       └── compatibility_score.dart
│   │
│   ├── connections/
│   │   ├── providers/
│   │   │   └── connections_provider.dart
│   │   ├── screens/
│   │   │   └── connections_screen.dart
│   │   └── widgets/
│   │       ├── connection_list.dart
│   │       ├── pending_requests.dart
│   │       ├── sent_requests.dart
│   │       └── connection_request_sheet.dart
│   │
│   ├── sessions/
│   │   ├── providers/
│   │   │   └── session_provider.dart
│   │   ├── screens/
│   │   │   └── sessions_screen.dart
│   │   └── widgets/
│   │       ├── session_card.dart
│   │       ├── session_booking_sheet.dart
│   │       ├── reschedule_session_sheet.dart
│   │       └── upcoming_sessions.dart
│   │
│   ├── messaging/
│   │   ├── providers/
│   │   │   └── messaging_provider.dart
│   │   ├── screens/
│   │   │   ├── conversations_screen.dart
│   │   │   └── chat_screen.dart
│   │   └── widgets/
│   │       ├── conversation_tile.dart
│   │       ├── message_bubble.dart
│   │       └── message_input.dart
│   │
│   ├── reviews/
│   │   ├── providers/
│   │   │   └── review_provider.dart
│   │   ├── screens/              # Reviews shown on profile, no standalone screen
│   │   └── widgets/
│   │       ├── review_card.dart
│   │       ├── review_sheet.dart
│   │       └── star_rating_input.dart
│   │
│   ├── notifications/
│   │   ├── providers/
│   │   │   └── notification_provider.dart
│   │   ├── screens/
│   │   │   └── notifications_screen.dart
│   │   └── widgets/
│   │       ├── notification_tile.dart
│   │       └── notification_badge.dart
│   │
│   ├── search/
│   │   ├── providers/
│   │   │   └── search_provider.dart
│   │   ├── screens/
│   │   │   └── search_screen.dart
│   │   └── widgets/
│   │       └── search_result_card.dart
│   │
│   ├── community/
│   │   ├── providers/
│   │   │   └── community_provider.dart
│   │   ├── screens/
│   │   │   └── community_screen.dart
│   │   └── widgets/
│   │       ├── discussion_card.dart
│   │       ├── learning_circle_card.dart
│   │       ├── leaderboard_tile.dart
│   │       ├── create_post_sheet.dart
│   │       └── create_circle_sheet.dart
│   │
│   ├── settings/
│   │   ├── providers/
│   │   │   └── settings_provider.dart
│   │   ├── screens/
│   │   │   └── settings_screen.dart
│   │   └── widgets/
│   │       ├── notification_settings.dart
│   │       ├── privacy_settings.dart
│   │       └── account_settings.dart
│   │
│   └── admin/
│       ├── providers/
│       │   └── admin_provider.dart
│       ├── screens/
│       │   ├── admin_dashboard_screen.dart
│       │   ├── user_management_screen.dart
│       │   └── content_moderation_screen.dart
│       └── widgets/
│           ├── admin_stats_grid.dart
│           ├── user_action_sheet.dart
│           └── report_card.dart
│
├── config/
│   ├── router/
│   │   └── app_router.dart       # GoRouter configuration with all routes
│   ├── di/
│   │   └── providers.dart        # Top-level Riverpod providers (Dio, storage, repos)
│   └── env/
│       └── env_config.dart       # Environment configuration (base URL, feature flags)
│
└── main.dart                     # App entry point, ProviderScope, MaterialApp.router
```

**Generated files** (created by `build_runner`, not hand-written):
- `data/models/*.freezed.dart` — Freezed immutable class implementations
- `data/models/*.g.dart` — JSON serialisation factories
- `features/*/providers/*.g.dart` — Riverpod provider implementations

---

## 3. Layer Responsibilities

### Presentation Layer (`features/*/screens/`, `features/*/widgets/`)

- Only UI code: `StatelessWidget` or `ConsumerWidget`
- Reads state from providers via `ref.watch()`
- Calls provider methods for user actions via `ref.read().methodName()`
- Uses `AsyncValue.when()` for loading/error/data states — never manual booleans
- No business logic — no `if/else` on data shapes, no calculations
- No direct API calls — never imports Dio or remote sources
- No direct storage access — never imports secure storage or shared prefs
- All colours and sizes from theme tokens — never hardcoded values

### Provider Layer (`features/*/providers/`)

- Manages UI state using `AsyncNotifier`, `Notifier`, or `FutureProvider`
- Calls repository methods (the abstract interface, not the implementation)
- Transforms domain entities into UI-ready state
- Handles pagination, filtering, sorting logic
- No UI code — never imports Flutter widgets
- No direct API calls — calls repositories only

### Repository Layer (`data/repositories/`)

- Implements abstract interfaces from `domain/repositories/`
- Orchestrates between remote and local data sources
- Caching logic: decides whether to fetch from network or return cached data
- Error mapping: catches exceptions from data sources, returns `Either<Failure, T>`
- No UI code
- No direct Dio usage — delegates to remote sources

### Data Source Layer (`data/sources/`)

- **Remote** (`data/sources/remote/`):
  - Raw API calls via Dio
  - Returns model objects (deserialized JSON) or throws typed exceptions
  - One class per feature group
  - No business logic — just HTTP calls and JSON parsing

- **Local** (`data/sources/local/`):
  - Reads/writes to flutter_secure_storage and shared_preferences
  - Returns typed values
  - Throws typed exceptions on failure
  - No business logic

### Domain Layer (`domain/`)

- **Entities** (`domain/entities/`): Pure Dart objects with no serialisation logic.
  Used in the provider and presentation layers.
- **Repository interfaces** (`domain/repositories/`): Abstract classes defining
  the contract. Data layer implements these. Provider layer depends on these.

### Data Flow

```
Screen (UI) → Provider → Repository Interface → Repository Impl → Remote/Local Source
                                                      ↓
                                              Model (Freezed) → Entity
```

---

## 4. Networking Architecture

### Base Dio Client

```dart
// Configured in config/di/providers.dart as a Riverpod provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: EnvConfig.apiBaseUrl,    // from --dart-define or env_config.dart
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.addAll([
    ref.read(authInterceptorProvider),
    ref.read(errorInterceptorProvider),
    LogInterceptor(requestBody: true, responseBody: true), // debug only
  ]);

  return dio;
});
```

### Environment Configuration

```dart
// config/env/env_config.dart
class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
  static const bool enableMockData = bool.fromEnvironment(
    'ENABLE_MOCK_DATA',
    defaultValue: false,
  );
}
// Usage: flutter run --dart-define=API_BASE_URL=https://api.skillexchange.com
```

### AuthInterceptor

```dart
class AuthInterceptor extends Interceptor {
  final SecureStorageSource _storage;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final newToken = await _refreshToken(refreshToken);
          await _storage.saveAccessToken(newToken);
          // Retry original request with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (_) {
          // Refresh failed — clear tokens, trigger logout
          await _storage.clearTokens();
          // AuthProvider will detect missing token and update state
        }
      }
    }
    handler.next(err);
  }
}
```

### ErrorInterceptor

```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = switch (err.response?.statusCode) {
      400 => ValidationFailure(
        message: err.response?.data['message'] ?? 'Invalid request',
        fieldErrors: _parseFieldErrors(err.response?.data),
      ),
      401 => const AuthFailure(message: 'Authentication required'),
      403 => const PermissionFailure(message: 'Permission denied'),
      404 => const NotFoundFailure(message: 'Resource not found'),
      409 => ConflictFailure(message: err.response?.data['message'] ?? 'Conflict'),
      422 => ValidationFailure(
        message: err.response?.data['message'] ?? 'Validation failed',
        fieldErrors: _parseFieldErrors(err.response?.data),
      ),
      429 => const RateLimitFailure(message: 'Too many requests'),
      500 => const ServerFailure(message: 'Internal server error'),
      503 => const ServerFailure(message: 'Service unavailable'),
      _ => _handleDioExceptionType(err),
    };
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: failure,
      type: err.type,
      response: err.response,
    ));
  }
}
```

### Error Handling Pattern: `Either<Failure, T>` with fpdart

Every repository method returns `Future<Either<Failure, T>>`.
This is chosen over raw `AsyncValue` error handling because:
- Typed failure information is preserved (not just `Object` error)
- Repositories are testable without Riverpod
- Consistent pattern across all features

```dart
// In repository implementation
@override
Future<Either<Failure, UserProfile>> getProfile(String userId) async {
  try {
    final model = await _remoteSource.getProfile(userId);
    return Right(model.toEntity());
  } on DioException catch (e) {
    return Left(e.error as Failure);
  }
}

// In provider
@riverpod
Future<UserProfile> profile(ProfileRef ref, String userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getProfile(userId);
  return result.fold(
    (failure) => throw failure,  // AsyncValue will catch this
    (profile) => profile,
  );
}
```

### Failure Hierarchy

```dart
// core/errors/failures.dart
sealed class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;
  const ValidationFailure({required super.message, this.fieldErrors});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class ConflictFailure extends Failure {
  const ConflictFailure({required super.message});
}

class RateLimitFailure extends Failure {
  const RateLimitFailure({required super.message});
}
```

---

## 5. Authentication Architecture

### Token Storage

| Data | Storage | Key |
|------|---------|-----|
| Access token | `flutter_secure_storage` | `access_token` |
| Refresh token | `flutter_secure_storage` | `refresh_token` |
| User profile (cached) | `shared_preferences` | `cached_user` |
| Remember-me flag | `shared_preferences` | `remember_me` |

### Auth State

```dart
sealed class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
}
```

### App Startup Flow

```
1. App launches
2. Show splash screen
3. AuthProvider initialises:
   a. Read access token from flutter_secure_storage
   b. If no token → AuthUnauthenticated → navigate to /login
   c. If token exists → attempt GET /auth/me
   d. If /auth/me succeeds → AuthAuthenticated → navigate to /dashboard
   e. If /auth/me returns 401 → attempt token refresh
   f. If refresh succeeds → retry /auth/me → AuthAuthenticated
   g. If refresh fails → clear tokens → AuthUnauthenticated → /login
4. Auth state change triggers GoRouter redirect
```

### Route Protection via GoRouter Redirect

```dart
GoRouter(
  redirect: (context, state) {
    final authState = ref.read(authProvider);
    final isAuthenticated = authState is AuthAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/login') ||
                        state.matchedLocation.startsWith('/signup') ||
                        state.matchedLocation.startsWith('/forgot-password') ||
                        state.matchedLocation.startsWith('/verify-email');
    final isPublicRoute = state.matchedLocation == '/';

    if (!isAuthenticated && !isAuthRoute && !isPublicRoute) {
      return '/login?redirect=${state.matchedLocation}';
    }
    if (isAuthenticated && isAuthRoute) {
      return '/dashboard';
    }
    return null; // no redirect
  },
  // ...routes
);
```

### Auth Methods

| Action | API Endpoint | Notes |
|--------|-------------|-------|
| Login (email/password) | `POST /auth/login` | Returns access + refresh tokens |
| Signup | `POST /auth/signup` | Returns access + refresh tokens |
| Google OAuth | `GET /auth/google` | Opens in-app browser, callback returns tokens |
| Forgot password | `POST /auth/forgot-password` | Sends email |
| Reset password | `POST /auth/reset-password` | Token from email link |
| Verify email | `POST /auth/verify-email` | Token from email link / deep link |
| Change password | `POST /auth/change-password` | Requires current password |
| Logout | `POST /auth/logout` | Clears tokens locally + invalidates server-side |
| Get current user | `GET /auth/me` | Returns User object |
| Refresh token | `POST /auth/refresh` | Returns new access token |

---

## 6. Riverpod State Management Patterns

### Data Fetching Pattern (read-only)

```dart
@riverpod
Future<UserProfile> profile(ProfileRef ref, String userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getProfile(userId);
  return result.fold(
    (failure) => throw failure,
    (profile) => profile,
  );
}

// Usage in UI:
final profileAsync = ref.watch(profileProvider(userId));
profileAsync.when(
  loading: () => const ProfileSkeleton(),
  error: (e, _) => ErrorMessage(message: e.toString(), onRetry: () => ref.invalidate(profileProvider(userId))),
  data: (profile) => ProfileView(profile: profile),
);
```

### Notifier Pattern (mutable state)

```dart
@riverpod
class ConnectionsNotifier extends _$ConnectionsNotifier {
  @override
  Future<List<Connection>> build() async {
    final repo = ref.watch(connectionRepositoryProvider);
    final result = await repo.getConnections();
    return result.fold((f) => throw f, (data) => data);
  }

  Future<void> sendRequest(String userId, String message) async {
    final repo = ref.read(connectionRepositoryProvider);
    state = const AsyncLoading();
    final result = await repo.sendRequest(userId, message);
    result.fold(
      (f) => state = AsyncError(f, StackTrace.current),
      (_) => ref.invalidateSelf(), // refetch list
    );
  }

  Future<void> respondToRequest(String connectionId, bool accept) async {
    final repo = ref.read(connectionRepositoryProvider);
    final result = await repo.respondToRequest(connectionId, accept);
    result.fold(
      (f) => state = AsyncError(f, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}
```

### Pagination Pattern

```dart
// Reusable paginated state
@freezed
class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState({
    @Default([]) List<T> items,
    @Default(1) int currentPage,
    @Default(20) int pageSize,
    @Default(0) int totalItems,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedEnd,
  }) = _PaginatedState;
}

// Paginated notifier pattern
@riverpod
class PaginatedMatchesNotifier extends _$PaginatedMatchesNotifier {
  @override
  Future<PaginatedState<MatchScore>> build(MatchingFilters filters) async {
    final repo = ref.watch(matchingRepositoryProvider);
    final result = await repo.getMatches(filters: filters, page: 1);
    return result.fold(
      (f) => throw f,
      (paginated) => PaginatedState(
        items: paginated.data,
        currentPage: 1,
        totalItems: paginated.pagination.totalItems,
        hasReachedEnd: paginated.data.length >= paginated.pagination.totalItems,
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || current.hasReachedEnd) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    final repo = ref.read(matchingRepositoryProvider);
    final result = await repo.getMatches(
      filters: /* from arg */,
      page: current.currentPage + 1,
    );
    result.fold(
      (f) => state = AsyncData(current.copyWith(isLoadingMore: false)),
      (paginated) => state = AsyncData(current.copyWith(
        items: [...current.items, ...paginated.data],
        currentPage: current.currentPage + 1,
        isLoadingMore: false,
        hasReachedEnd: current.items.length + paginated.data.length >= paginated.pagination.totalItems,
      )),
    );
  }
}
```

### Form State Pattern

Forms use `reactive_forms` for state and validation.
The form group is created in the provider or directly in the screen widget.

```dart
// Login form example — created in screen, submitted via provider
final loginForm = FormGroup({
  'email': FormControl<String>(validators: [Validators.required, Validators.email]),
  'password': FormControl<String>(validators: [Validators.required, Validators.minLength(8)]),
  'rememberMe': FormControl<bool>(value: false),
});

// On submit
ref.read(authProvider.notifier).login(
  email: loginForm.control('email').value!,
  password: loginForm.control('password').value!,
);
```

---

## 7. Theme System

Based on the exact CSS variables extracted from the React app's `index.css`.

### AppColors

```dart
class AppColors {
  // === LIGHT MODE ===
  static const Color primary = Color(0xFF2563EB);           // #2563eb (blue-600)
  static const Color primaryForeground = Color(0xFFF9FAFB);
  static const Color secondary = Color(0xFF8B5CF6);         // #8b5cf6 (violet-500)
  static const Color secondaryForeground = Color(0xFFF9FAFB);

  static const Color background = Color(0xFFFAFAFA);        // #fafafa
  static const Color foreground = Color(0xFF09090B);         // #09090b
  static const Color card = Color(0xFFFFFFFF);               // #ffffff
  static const Color cardForeground = Color(0xFF09090B);

  static const Color muted = Color(0xFFF4F4F5);             // #f4f4f5
  static const Color mutedForeground = Color(0xFF71717A);   // #71717a
  static const Color accent = Color(0xFFF4F4F5);
  static const Color accentForeground = Color(0xFF09090B);

  static const Color destructive = Color(0xFFDC2626);       // #dc2626
  static const Color destructiveForeground = Color(0xFFF9FAFB);

  static const Color border = Color(0xFFE4E4E7);            // #e4e4e7
  static const Color input = Color(0xFFE4E4E7);
  static const Color ring = Color(0xFF2563EB);

  // Status colours
  static const Color success = Color(0xFF16A34A);            // green-600
  static const Color warning = Color(0xFFEAB308);            // yellow-500
  static const Color info = Color(0xFF2563EB);               // blue-600 (same as primary)

  // Skill level colours (from SkillTag component)
  static const Color beginnerBg = Color(0xFFDCFCE7);        // green-100
  static const Color beginnerText = Color(0xFF166534);       // green-800
  static const Color intermediateBg = Color(0xFFDBEAFE);    // blue-100
  static const Color intermediateText = Color(0xFF1E40AF);   // blue-800
  static const Color advancedBg = Color(0xFFF3E8FF);        // purple-100
  static const Color advancedText = Color(0xFF6B21A8);       // purple-800
  static const Color expertBg = Color(0xFFFFEDD5);           // orange-100
  static const Color expertText = Color(0xFF9A3412);         // orange-800

  // Star rating
  static const Color starFilled = Color(0xFFFACC15);         // yellow-400
  static const Color starEmpty = Color(0xFFD1D5DB);          // gray-300

  // Compatibility score colours
  static const Color scoreExcellent = Color(0xFF16A34A);     // green >=80
  static const Color scoreGreat = Color(0xFF2563EB);         // blue >=60
  static const Color scoreGood = Color(0xFFEAB308);          // yellow >=40
  static const Color scoreFair = Color(0xFF71717A);          // gray <40

  // === DARK MODE ===
  static const Color darkPrimary = Color(0xFF60A5FA);        // #60a5fa (blue-400)
  static const Color darkPrimaryForeground = Color(0xFF09090B);
  static const Color darkSecondary = Color(0xFFA78BFA);      // #a78bfa (violet-400)
  static const Color darkSecondaryForeground = Color(0xFF09090B);
  static const Color darkBackground = Color(0xFF09090B);     // #09090b
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF18181B);           // #18181b
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF27272A);          // #27272a
  static const Color darkMutedForeground = Color(0xFFA1A1AA);// #a1a1aa
  static const Color darkAccent = Color(0xFF27272A);
  static const Color darkAccentForeground = Color(0xFFFAFAFA);
  static const Color darkDestructive = Color(0xFFEF4444);    // #ef4444
  static const Color darkDestructiveForeground = Color(0xFFFAFAFA);
  static const Color darkBorder = Color(0xFF27272A);
  static const Color darkInput = Color(0xFF27272A);
  static const Color darkRing = Color(0xFF60A5FA);
}
```

### AppTextStyles

```dart
class AppTextStyles {
  static const String fontFamily = 'system';  // System font (San Francisco on iOS, Roboto on Android)

  // Headings
  static const TextStyle h1 = TextStyle(fontSize: 30, fontWeight: FontWeight.w700, height: 1.2);
  static const TextStyle h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.25);
  static const TextStyle h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static const TextStyle h4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35);

  // Body
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // Labels
  static const TextStyle labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4);
  static const TextStyle labelMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.4);

  // Caption
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
}
```

### AppSpacing

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Specific component spacing
  static const double cardPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double sectionGap = 24.0;
  static const double listItemGap = 12.0;
  static const double inputGap = 16.0;
}
```

### AppRadius

```dart
class AppRadius {
  static const double xs = 4.0;        // --radius-sm (0.25rem)
  static const double sm = 6.0;
  static const double md = 8.0;        // --radius-md (0.5rem)
  static const double lg = 12.0;       // --radius-lg (0.75rem)
  static const double xl = 16.0;
  static const double full = 9999.0;   // For circles (avatars)

  // Specific component radii
  static const double button = 8.0;
  static const double card = 12.0;
  static const double input = 8.0;
  static const double chip = 9999.0;
  static const double avatar = 9999.0;
  static const double sheet = 16.0;    // Bottom sheet top corners
}
```

### AppShadows

```dart
class AppShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2)),
  ];
}
```

### ThemeData — Light Mode

```dart
static ThemeData lightTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.primaryForeground,
    secondary: AppColors.secondary,
    onSecondary: AppColors.secondaryForeground,
    surface: AppColors.card,
    onSurface: AppColors.foreground,
    error: AppColors.destructive,
    onError: AppColors.destructiveForeground,
    outline: AppColors.border,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.card,
    foregroundColor: AppColors.foreground,
    elevation: 0,
    scrolledUnderElevation: 1,
  ),
  cardTheme: CardThemeData(
    color: AppColors.card,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      side: const BorderSide(color: AppColors.border),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryForeground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.foreground,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.input),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.input),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.ring, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.destructive),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedForeground),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    labelStyle: AppTextStyles.labelSmall,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.card,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.mutedForeground,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: 1,
  ),
);
```

### ThemeData — Dark Mode

```dart
static ThemeData darkTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkPrimaryForeground,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkSecondaryForeground,
    surface: AppColors.darkCard,
    onSurface: AppColors.darkForeground,
    error: AppColors.darkDestructive,
    onError: AppColors.darkDestructiveForeground,
    outline: AppColors.darkBorder,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkCard,
    foregroundColor: AppColors.darkForeground,
    elevation: 0,
    scrolledUnderElevation: 1,
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkCard,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      side: const BorderSide(color: AppColors.darkBorder),
    ),
  ),
  // ... (mirrors light theme with dark colour references)
);
```

---

## 8. Navigation Architecture

### Route Names

```dart
class RouteNames {
  // Public
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';

  // Authenticated (under shell)
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';           // own profile
  static const String profileById = '/profile/:userId'; // other user's profile
  static const String matching = '/matching';
  static const String connections = '/connections';
  static const String messages = '/messages';
  static const String chat = '/messages/:conversationId';
  static const String search = '/search';
  static const String community = '/community';
  static const String bookings = '/bookings';
  static const String settings = '/settings';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminModeration = '/admin/moderation';
}
```

### GoRouter Configuration

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = [
        RouteNames.login, RouteNames.signup,
        RouteNames.forgotPassword, RouteNames.verifyEmail,
      ].contains(state.matchedLocation);
      final isPublicRoute = state.matchedLocation == RouteNames.home;

      if (!isAuthenticated && !isAuthRoute && !isPublicRoute) {
        return '${RouteNames.login}?redirect=${Uri.encodeComponent(state.matchedLocation)}';
      }
      if (isAuthenticated && isAuthRoute) {
        return RouteNames.dashboard;
      }
      return null;
    },
    routes: [
      // Public routes
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),

      // Authenticated shell (bottom navigation)
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.matching,
            builder: (context, state) => const MatchingScreen(),
          ),
          GoRoute(
            path: RouteNames.connections,
            builder: (context, state) => const ConnectionsScreen(),
          ),
          GoRoute(
            path: RouteNames.messages,
            builder: (context, state) => const ConversationsScreen(),
            routes: [
              GoRoute(
                path: ':conversationId',
                builder: (context, state) => ChatScreen(
                  conversationId: state.pathParameters['conversationId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.search,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: RouteNames.community,
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            path: RouteNames.bookings,
            builder: (context, state) => const SessionsScreen(),
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: ':userId',
                builder: (context, state) => ProfileScreen(
                  userId: state.pathParameters['userId'],
                ),
              ),
            ],
          ),

          // Admin routes
          GoRoute(
            path: RouteNames.adminDashboard,
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.adminUsers,
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: RouteNames.adminModeration,
            builder: (context, state) => const ContentModerationScreen(),
          ),
        ],
      ),
    ],
  );
});
```

### Bottom Navigation Structure

The React app uses a sidebar with these navigation items. On mobile, these map
to bottom navigation (5 primary tabs) + "More" for overflow:

| Tab | Icon | Route | Label |
|-----|------|-------|-------|
| 1 | Home | `/dashboard` | Home |
| 2 | Search | `/matching` | Matches |
| 3 | People | `/connections` | Connects |
| 4 | Chat | `/messages` | Messages |
| 5 | Person | `/profile` | Profile |

Secondary screens (search, community, bookings, settings, admin) are accessible
from the dashboard, profile menu, or deep links — not from the bottom nav.

### Deep Link Patterns

| Pattern | Screen |
|---------|--------|
| `skillexchange://profile/{userId}` | ProfileScreen |
| `skillexchange://messages/{conversationId}` | ChatScreen |
| `skillexchange://verify-email?token={token}` | VerifyEmailScreen |
| `skillexchange://reset-password?token={token}` | ResetPasswordScreen |

---

## 9. Shared Widget Catalogue

Every reusable component from the React app, mapped to a Flutter widget.

### AppButton — `lib/core/widgets/app_button.dart`

```
AppButton.primary({required String label, VoidCallback? onPressed, bool isLoading = false, IconData? icon})
AppButton.secondary({required String label, VoidCallback? onPressed, bool isLoading = false})
AppButton.outline({required String label, VoidCallback? onPressed, bool isLoading = false})
AppButton.text({required String label, VoidCallback? onPressed})
AppButton.destructive({required String label, VoidCallback? onPressed, bool isLoading = false})
AppButton.icon({required IconData icon, VoidCallback? onPressed, String? tooltip})
```
Uses: `AppColors.primary`, `AppTextStyles.labelLarge`, `AppRadius.button`

### AppTextField — `lib/core/widgets/app_text_field.dart`

```
AppTextField({
  String? label, String? hint, String? errorText,
  TextEditingController? controller, bool obscureText = false,
  TextInputType? keyboardType, int maxLines = 1,
  Widget? prefixIcon, Widget? suffixIcon,
  ValueChanged<String>? onChanged, bool enabled = true,
})
```
Uses: Theme's `InputDecorationTheme`

### AppCard — `lib/core/widgets/app_card.dart`

```
AppCard({required Widget child, EdgeInsets? padding, VoidCallback? onTap})
```
Uses: `AppColors.card`, `AppRadius.card`, `AppShadows.sm`

### UserAvatar — `lib/core/widgets/user_avatar.dart`

```
UserAvatar({
  String? imageUrl, required String name,
  double size = 40,  // xs=24, sm=32, md=40, lg=56, xl=80
  bool showOnlineIndicator = false,
})
```
Uses: `AppRadius.avatar`, `cached_network_image`, fallback initials

### SkillTag — `lib/core/widgets/skill_tag.dart`

```
SkillTag({required String name, required String level})
```
Level-based colours: beginner=green, intermediate=blue, advanced=purple, expert=orange
Uses: `AppColors.beginnerBg/Text`, etc., `AppRadius.chip`

### StarRating — `lib/core/widgets/star_rating.dart`

```
StarRating({required double rating, double size = 20, bool interactive = false, ValueChanged<double>? onRatingChanged})
```
Uses: `AppColors.starFilled`, `AppColors.starEmpty`, `flutter_rating_bar`

### LoadingSpinner — `lib/core/widgets/loading_spinner.dart`

```
LoadingSpinner({double size = 24, Color? color})
```
Uses: `AppColors.primary`, `CircularProgressIndicator`

### SkeletonCard — `lib/core/widgets/skeleton_card.dart`

```
SkeletonCard({double? height, double? width})
SkeletonCard.profile()
SkeletonCard.match()
SkeletonCard.session()
SkeletonCard.message()
```
Uses: `shimmer` package, `AppColors.muted`

### EmptyState — `lib/core/widgets/empty_state.dart`

```
EmptyState({required String title, String? description, IconData? icon, String? actionLabel, VoidCallback? onAction})
```
Uses: `AppColors.mutedForeground`, `AppTextStyles.h3`, `AppTextStyles.bodyMedium`

### ErrorMessage — `lib/core/widgets/error_message.dart`

```
ErrorMessage({required String message, VoidCallback? onRetry})
```
Uses: `AppColors.destructive`, `AppButton.outline`

### SearchBar — `lib/core/widgets/search_bar_widget.dart`

```
SearchBarWidget({
  String? hint, TextEditingController? controller,
  ValueChanged<String>? onSubmitted, VoidCallback? onClear,
})
```
Uses: `AppTextField` with search icon prefix, clear button suffix

---

## 10. Feature Modules

### FEATURE: Authentication

**Purpose:** User registration, login, password recovery, email verification.

**Screens:**
- `login_screen.dart` — Email/password form, Google OAuth button, demo credentials, links to signup/forgot password
- `signup_screen.dart` — Name, email, password, confirm password, terms checkbox, password strength indicator
- `forgot_password_screen.dart` — Email input, success state with auto-redirect
- `verify_email_screen.dart` — Token-based verification from deep link, states: verifying/success/error

**Providers:**
- `auth_provider.dart` — `AuthNotifier` managing `AuthState` (sealed class), methods: `login`, `signup`, `logout`, `forgotPassword`, `verifyEmail`, `changePassword`

**Repository:** `AuthRepository` → `AuthRepositoryImpl`

**API endpoints consumed:**
- `POST /auth/login`, `POST /auth/signup`, `POST /auth/logout`
- `POST /auth/refresh`, `GET /auth/me`
- `POST /auth/forgot-password`, `POST /auth/reset-password`, `POST /auth/verify-email`
- `POST /auth/change-password`, `GET /auth/google`

**Local data:** Access token, refresh token in `flutter_secure_storage`. Cached user in `shared_preferences`.

**Navigation:** Login → Dashboard (on success). Signup → Dashboard. Forgot password → Login (after success).

**Dependencies:** None (foundation feature).

**Mobile-specific:** Biometric authentication could be added later. Google OAuth uses in-app browser. Deep links for email verification and password reset.

---

### FEATURE: Dashboard

**Purpose:** Landing page after login. Shows stats overview, top matches, upcoming sessions, quick action links.

**Screens:**
- `dashboard_screen.dart` — Welcome message, stats grid, top matches, upcoming sessions, quick actions

**Widgets:**
- `stats_grid.dart` — 4-card grid: Connections, Sessions, Reviews, Rating
- `top_matches_section.dart` — Up to 5 match cards with compatibility scores
- `upcoming_sessions_section.dart` — Up to 3 session cards

**Providers:**
- `dashboard_provider.dart` — Aggregates data from profile, matching, and session providers

**Repository:** Uses `ProfileRepository`, `MatchingRepository`, `SessionRepository`

**API endpoints consumed:**
- `GET /profiles/me`, `GET /matching/suggestions` (limit=5), `GET /sessions/upcoming` (limit=3)

**Local data:** None (always fetches fresh).

**Navigation:** Navigate to /matching, /search, /community from quick actions. Navigate to /profile/:id from match cards. Navigate to /bookings from session cards.

**Dependencies:** Auth, Profile, Matching, Sessions.

**Mobile-specific:** Pull-to-refresh to reload all dashboard data.

---

### FEATURE: Profile

**Purpose:** View and edit user profiles. View other users' profiles with actions (book, connect, report, block).

**Screens:**
- `profile_screen.dart` — Own profile view/edit toggle. Other user's profile with action buttons.

**Widgets:**
- `profile_view.dart` — Avatar, verification badge, stats, skills to teach/learn, languages, interests, availability grid, learning style, reviews
- `profile_edit.dart` — Tabbed form: Basic Info, Skills, Interests, Availability
- `skills_section.dart` — Add/remove skills with name, category (11 categories), level (4 levels)
- `availability_grid.dart` — 7-day toggle switches
- `report_user_sheet.dart` — Bottom sheet with reason select and description
- `block_user_sheet.dart` — Bottom sheet for blocking/unblocking

**Providers:**
- `profile_provider.dart` — `currentProfileProvider`, `profileProvider(userId)`, `updateProfileNotifier`

**Repository:** `ProfileRepository` → `ProfileRepositoryImpl`

**API endpoints consumed:**
- `GET /profiles/me`, `GET /profiles/:id`, `PUT /profiles/me`
- `POST /reports`, `GET /skills`, `GET /skills/categories`

**Local data:** Blocked users list in `shared_preferences`.

**Navigation:** Navigate to /messages/:id for messaging. Navigate to /bookings for booking. Back navigation from other users' profiles.

**Dependencies:** Auth, Reviews (for review display).

**Mobile-specific:** Bottom sheets instead of dialogs for report/block. Image picker for avatar upload. Pull-to-refresh.

---

### FEATURE: Skill Matching

**Purpose:** Find compatible skill exchange partners based on a weighted algorithm. Filter, sort, and browse matches.

**Screens:**
- `matching_screen.dart` — Filter sidebar (collapsible), match grid, sort dropdown, view toggle (grid/list)

**Widgets:**
- `match_card.dart` — Avatar, name, location, rating, compatibility score (colour-coded), matched skills, action buttons
- `matching_filters.dart` — Skill name, category, location, min rating slider, learning style, availability checkboxes
- `compatibility_score.dart` — Large coloured percentage with label

**Providers:**
- `matching_provider.dart` — `PaginatedMatchesNotifier` with filters, `matchingFiltersProvider`, `matchingSortProvider`

**Repository:** `MatchingRepository` → `MatchingRepositoryImpl`

**API endpoints consumed:**
- `GET /matching` (with query params for filters, sort, page)
- `GET /matching/:userId` (single match detail)

**Local data:** Filter state persisted in provider (not storage).

**Navigation:** Navigate to /profile/:id from match cards. Trigger SessionBookingSheet and ConnectionRequestSheet from cards.

**Dependencies:** Auth, Profile.

**Mobile-specific:** Bottom sheet for filters (instead of sidebar). Infinite scroll instead of pagination buttons. Pull-to-refresh.

---

### FEATURE: Connections

**Purpose:** Manage connections with other users. Send, accept, reject requests. Remove connections.

**Screens:**
- `connections_screen.dart` — Three tabs: Connections, Requests, Sent

**Widgets:**
- `connection_list.dart` — Grid of accepted connection cards with message/book/remove actions
- `pending_requests.dart` — List of incoming requests with accept/decline/view actions
- `sent_requests.dart` — List of sent requests with status
- `connection_request_sheet.dart` — Bottom sheet with message textarea (500 char limit)

**Providers:**
- `connections_provider.dart` — `ConnectionsNotifier` with methods: `sendRequest`, `respondToRequest`, `removeConnection`

**Repository:** `ConnectionRepository` → `ConnectionRepositoryImpl`

**API endpoints consumed:**
- `GET /connections`, `POST /connections/request`, `GET /connections/pending`, `GET /connections/sent`
- `PUT /connections/:id/respond`, `DELETE /connections/:id`
- `GET /connections/:userId/status`

**Local data:** None.

**Navigation:** Navigate to /messages/:userId from connection card. Navigate to /bookings from connection card. Navigate to /profile/:id from request card.

**Dependencies:** Auth, Profile.

**Mobile-specific:** Swipe-to-dismiss for removing connections. Bottom sheet for connection request.

---

### FEATURE: Session Booking

**Purpose:** Book, manage, cancel, reschedule, and complete learning sessions.

**Screens:**
- `sessions_screen.dart` — List of upcoming sessions with "New Booking" FAB

**Widgets:**
- `session_card.dart` — Title, host/participant, skill badges, date/time/duration, status badge, action buttons
- `session_booking_sheet.dart` — Multi-field form: partner, skill, title, description, mode (online/offline), platform, link/location, date, time, duration
- `reschedule_session_sheet.dart` — New date, time, duration, reason
- `upcoming_sessions.dart` — Session list with inline actions

**Providers:**
- `session_provider.dart` — `SessionsNotifier` with methods: `createSession`, `cancelSession`, `completeSession`, `rescheduleSession`

**Repository:** `SessionRepository` → `SessionRepositoryImpl`

**API endpoints consumed:**
- `GET /sessions`, `GET /sessions/upcoming`, `GET /sessions/:id`
- `POST /sessions`, `PUT /sessions/:id`, `PUT /sessions/:id/cancel`
- `PUT /sessions/:id/complete`, `PUT /sessions/:id/reschedule`

**Local data:** None.

**Navigation:** Opens meeting link via `url_launcher`. Triggers ReviewSheet on complete. Navigate to /profile/:id for partner.

**Dependencies:** Auth, Connections (for partner selection), Reviews (on complete).

**Mobile-specific:** Bottom sheets for booking/reschedule (instead of dialogs). Date/time pickers use native platform pickers. Pull-to-refresh.

---

### FEATURE: Messaging

**Purpose:** Real-time messaging between connected users. Conversation list and individual chat.

**Screens:**
- `conversations_screen.dart` — List of conversations with avatar, name, last message, time, unread badge
- `chat_screen.dart` — Message bubbles, auto-scroll, text input with send button

**Widgets:**
- `conversation_tile.dart` — Avatar, name, last message preview, time, unread badge
- `message_bubble.dart` — Own messages (right, primary colour) vs other (left, muted)
- `message_input.dart` — Text field with send button

**Providers:**
- `messaging_provider.dart` — `ConversationsNotifier`, `MessagesNotifier(conversationId)` with optimistic message sending

**Repository:** `MessagingRepository` → `MessagingRepositoryImpl`

**API endpoints consumed:**
- `GET /messages/conversations`, `GET /messages/conversations/:id`
- `POST /messages`, `PUT /messages/:id/read`

**Local data:** None (messages fetched from server).

**Navigation:** From conversations list → chat screen. Chat screen navigates back to conversations.

**Dependencies:** Auth, Connections.

**Mobile-specific:** On mobile, conversations and chat are separate screens (not split view like web). Keyboard handling for message input. Push notifications for new messages. WebSocket for real-time message delivery.

---

### FEATURE: Reviews & Ratings

**Purpose:** Leave and view reviews for completed sessions. Star ratings with comments.

**Screens:** No standalone screen — reviews are displayed on profile screens and triggered from session completion.

**Widgets:**
- `review_card.dart` — Reviewer avatar, name, date, star rating, comment, skill badges
- `review_sheet.dart` — Bottom sheet: star rating input, skill checkboxes, comment textarea (10-1000 chars)
- `star_rating_input.dart` — Interactive 5-star input with label (Poor/Fair/Good/Very Good/Excellent)

**Providers:**
- `review_provider.dart` — `reviewsProvider(userId)`, `reviewStatsProvider(userId)`, `createReviewNotifier`

**Repository:** `ReviewRepository` → `ReviewRepositoryImpl`

**API endpoints consumed:**
- `GET /reviews/user/:userId`, `GET /reviews/user/:userId/stats`, `POST /reviews`

**Local data:** None.

**Navigation:** Review sheet triggered from session completion. Reviews visible on profile screen.

**Dependencies:** Auth, Sessions (triggered from session completion).

**Mobile-specific:** Bottom sheet for review creation. Haptic feedback on star selection.

---

### FEATURE: Notifications

**Purpose:** Display and manage in-app notifications. 7 notification types.

**Screens:**
- `notifications_screen.dart` — Full-screen notification list (on mobile, replaces dropdown from web)

**Widgets:**
- `notification_tile.dart` — Title, message, time, read/unread state, delete action
- `notification_badge.dart` — Bell icon with unread count overlay (for app bar)

**Providers:**
- `notification_provider.dart` — `NotificationsNotifier` with methods: `markAsRead`, `markAllAsRead`, `deleteNotification`

**Repository:** `NotificationRepository` → `NotificationRepositoryImpl`

**API endpoints consumed:**
- `GET /notifications`, `GET /notifications/unread-count`
- `PUT /notifications/:id/read`, `PUT /notifications/read-all`
- `DELETE /notifications/:id`

**Local data:** None.

**Navigation:** Tapping a notification navigates to its `actionUrl` (profile, messages, session, etc.).

**Dependencies:** Auth.

**Mobile-specific:** Full-screen list instead of dropdown. Push notifications via `firebase_messaging`. Local notifications for reminders. Swipe-to-dismiss to delete.

---

### FEATURE: Search & Discovery

**Purpose:** Search for users by name, skills, and filters.

**Screens:**
- `search_screen.dart` — Search bar with results grid

**Widgets:**
- `search_result_card.dart` — Avatar, name (link to profile), bio, top skills

**Providers:**
- `search_provider.dart` — `SearchNotifier` with debounced search, paginated results

**Repository:** `SearchRepository` → `SearchRepositoryImpl`

**API endpoints consumed:**
- `GET /search/users` (with query params)

**Local data:** Recent searches in `shared_preferences` (optional enhancement).

**Navigation:** Navigate to /profile/:id from search results.

**Dependencies:** Auth.

**Mobile-specific:** Keyboard auto-focus on screen entry. Debounced search as user types.

---

### FEATURE: Community

**Purpose:** Discussion forum, learning circles, and leaderboard.

**Screens:**
- `community_screen.dart` — Three tabs: Discussions, Learning Circles, Leaderboard

**Widgets:**
- `discussion_card.dart` — Author, title, content (3-line clamp), category badge, tags, like button, reply count
- `learning_circle_card.dart` — Name, category, description, members count/max, join/leave button
- `leaderboard_tile.dart` — Rank (with trophy for top 3), avatar, name, stats, score
- `create_post_sheet.dart` — Title, category select (5 categories), content, tags input (1-5)
- `create_circle_sheet.dart` — Name, category, description, max members (2-100)

**Providers:**
- `community_provider.dart` — `DiscussionPostsNotifier`, `LearningCirclesNotifier`, `leaderboardProvider`

**Repository:** `CommunityRepository` → `CommunityRepositoryImpl`

**API endpoints consumed:**
- `GET /community/posts`, `POST /community/posts`, `PUT /community/posts/:id`, `DELETE /community/posts/:id`
- `POST /community/posts/:id/like`, `DELETE /community/posts/:id/like`
- `GET /community/posts/:id/replies`, `POST /community/posts/:id/replies`
- `GET /community/circles`, `POST /community/circles`, `PUT /community/circles/:id`, `DELETE /community/circles/:id`
- `POST /community/circles/:id/join`, `DELETE /community/circles/:id/leave`
- `GET /community/leaderboard`

**Local data:** None.

**Navigation:** Navigate to post detail (expanded replies) — could be a new screen or bottom sheet. Navigate to /profile/:id from author name.

**Dependencies:** Auth, Profile.

**Mobile-specific:** Bottom sheets for create post/circle. Pull-to-refresh on all tabs. Infinite scroll for discussion posts.

---

### FEATURE: Settings

**Purpose:** Manage notification preferences, privacy settings, and account settings.

**Screens:**
- `settings_screen.dart` — Three sections: Notifications, Privacy, Account

**Widgets:**
- `notification_settings.dart` — Toggle switches for 7 notification categories
- `privacy_settings.dart` — Profile visibility select, show email/location/online status toggles, message permission select
- `account_settings.dart` — Change email form, change password form, delete account danger zone

**Providers:**
- `settings_provider.dart` — `NotificationSettingsNotifier`, `PrivacySettingsNotifier`, `AccountSettingsNotifier`

**Repository:** Uses `AuthRepository` (for password change, delete account) + local storage for preferences.

**API endpoints consumed:**
- `POST /auth/change-password` (for password change)
- `DELETE /profiles/me` (for account deletion — implied)

**Local data:** Notification preferences in `shared_preferences`. Privacy settings in `shared_preferences`.

**Navigation:** Navigates back on save. Navigates to /login on account deletion.

**Dependencies:** Auth.

**Mobile-specific:** Native switch widgets for toggles. Confirmation dialogs for destructive actions.

---

### FEATURE: Admin

**Purpose:** Platform administration. User management, content moderation, stats dashboard.

**Screens:**
- `admin_dashboard_screen.dart` — 6-card stats grid, quick actions, platform health
- `user_management_screen.dart` — User search, user cards with admin actions (warn, suspend, ban, delete)
- `content_moderation_screen.dart` — Report stats, tabbed report list, report review actions

**Widgets:**
- `admin_stats_grid.dart` — Stats cards for users, sessions, connections, reviews, posts, reports
- `user_action_sheet.dart` — Bottom sheet for admin action (reason textarea, suspend duration)
- `report_card.dart` — Report details with resolve/dismiss actions

**Providers:**
- `admin_provider.dart` — `AdminStatsProvider`, `UserManagementNotifier`, `ContentModerationNotifier`

**Repository:** `AdminRepository` → `AdminRepositoryImpl`

**API endpoints consumed:**
- `GET /profiles` (all users), `PUT /profiles/:id` (admin actions)
- `GET /reports`, `PUT /reports/:id` (resolve/dismiss)

**Local data:** None.

**Navigation:** From admin dashboard to user management and content moderation.

**Dependencies:** Auth (admin role required).

**Mobile-specific:** Role gate — only admin users can access these screens. GoRouter redirect for non-admin.

---

### FEATURE: Landing

**Purpose:** Landing page for unauthenticated users. Showcases the platform value proposition and directs to signup/login.

**Screens:**
- `home_screen.dart` — Hero section, "How It Works" 3-step, value propositions, testimonials, CTAs

**Providers:**
- `auth_provider.dart` — Only reads auth state to redirect authenticated users to /dashboard

**Repository:** None (static content).

**API endpoints consumed:** None.

**Local data:** None.

**Navigation:** "Get Started" → /signup. "Login" → /login. Redirects to /dashboard if already authenticated.

**Dependencies:** Auth (for redirect check only).

**Mobile-specific:** Responsive layout. CTA buttons prominent at top and bottom.
