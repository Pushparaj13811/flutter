# Skill Exchange — Flutter Conventions

> Coding rules for this project.
> Every future implementation must follow these conventions.
> Reference this file in every Claude Code prompt.

---

## 1. File Naming

All files use `snake_case.dart`. No exceptions.

```
✅ login_screen.dart
✅ user_profile_model.dart
✅ auth_repository_impl.dart
❌ LoginScreen.dart
❌ userProfileModel.dart
```

---

## 2. Widget Naming

Widgets use PascalCase with a descriptive suffix:

| Suffix | Usage |
|--------|-------|
| `Screen` | Full-page widgets tied to a route (e.g., `LoginScreen`, `DashboardScreen`) |
| `Widget` | Generic reusable widgets (e.g., `StatsGrid` — no suffix needed if name is clear) |
| `Card` | Card-style display components (e.g., `MatchCard`, `SessionCard`) |
| `Tile` | List tile components (e.g., `ConversationTile`, `LeaderboardTile`) |
| `Sheet` | Bottom sheet content (e.g., `SessionBookingSheet`, `ReviewSheet`) |
| `Dialog` | Alert/confirmation dialogs (e.g., — prefer sheets on mobile) |

---

## 3. Screen Widget Structure

Every screen follows this pattern:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Feature')),
      body: state.when(
        loading: () => const _LoadingSkeleton(),
        error: (e, _) => ErrorMessage(
          message: e.toString(),
          onRetry: () => ref.invalidate(featureProvider),
        ),
        data: (data) => _Content(data: data),
      ),
    );
  }
}

// Private widgets for this screen — in the same file if small,
// or in features/[feature]/widgets/ if large.
class _Content extends StatelessWidget { ... }
class _LoadingSkeleton extends StatelessWidget { ... }
```

**Rules:**
- Use `ConsumerWidget` (not `ConsumerStatefulWidget`) unless local animation controllers are needed
- `const` constructors wherever possible
- `AsyncValue.when()` for all async data — never manual `isLoading` booleans
- Private widgets prefixed with `_` in the same file
- Extract to separate widget files in `widgets/` when a private widget exceeds ~50 lines

---

## 4. Provider Conventions

Always use code generation:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_provider.g.dart';

// Simple data fetch
@riverpod
Future<List<Skill>> skills(SkillsRef ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getAllSkills();
  return result.fold((f) => throw f, (data) => data);
}

// Parameterised fetch
@riverpod
Future<UserProfile> profile(ProfileRef ref, String userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getProfile(userId);
  return result.fold((f) => throw f, (data) => data);
}

// Mutable state
@riverpod
class ConnectionsNotifier extends _$ConnectionsNotifier {
  @override
  Future<List<Connection>> build() async {
    final repo = ref.watch(connectionRepositoryProvider);
    final result = await repo.getConnections();
    return result.fold((f) => throw f, (data) => data);
  }

  Future<void> sendRequest(String userId, String message) async {
    state = const AsyncLoading();
    final result = await ref.read(connectionRepositoryProvider).sendRequest(userId, message);
    result.fold(
      (f) => state = AsyncError(f, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}
```

**Rules:**
- Always annotate with `@riverpod` — never manually write `Provider()`
- Always add `part '[filename].g.dart';`
- Notifier methods return `Future<void>` — they update `state` internally
- Use `ref.invalidateSelf()` to refetch after mutations
- Use `ref.invalidate(otherProvider)` to invalidate dependent providers
- Never read providers inside `build()` — use `ref.watch()` for dependencies

---

## 5. Repository Conventions

Interface in `domain/repositories/`, implementation in `data/repositories/`:

```dart
// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}

// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final SecureStorageSource _storage;

  AuthRepositoryImpl(this._remoteSource, this._storage);

  @override
  Future<Either<Failure, AuthTokens>> login(String email, String password) async {
    try {
      final model = await _remoteSource.login(LoginDto(email: email, password: password));
      await _storage.saveAccessToken(model.accessToken);
      if (model.refreshToken != null) {
        await _storage.saveRefreshToken(model.refreshToken!);
      }
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

**Rules:**
- Every method returns `Future<Either<Failure, T>>`
- Never throw from a repository — always return `Left(Failure)`
- Catch `DioException` (error is already a `Failure` from ErrorInterceptor)
- Catch generic exceptions as fallback
- Repository impl is registered as a Riverpod `Provider`

---

## 6. Dio Data Source Conventions

One class per feature group:

```dart
class AuthRemoteSource {
  final Dio _dio;

  AuthRemoteSource(this._dio);

  Future<AuthTokensModel> login(LoginDto dto) async {
    final response = await _dio.post(ApiEndpoints.auth.login, data: dto.toJson());
    return AuthTokensModel.fromJson(response.data['data']);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.auth.me);
    return UserModel.fromJson(response.data['data']);
  }
}
```

**Rules:**
- Methods return model objects (deserialized JSON) or throw
- No `try/catch` — let exceptions propagate to repository
- No business logic — just HTTP calls and parsing
- Use `ApiEndpoints` constants for all paths — never hardcode strings

---

## 7. Error Handling

**NEVER catch and ignore errors:**

```dart
// ❌ NEVER
try {
  await something();
} catch (_) {}

// ✅ ALWAYS map to Failure
try {
  await something();
} on DioException catch (e) {
  return Left(e.error as Failure);
} catch (e) {
  return Left(ServerFailure(message: e.toString()));
}
```

**Error flow:**
1. Dio makes HTTP call → fails
2. ErrorInterceptor maps status code to `Failure`, attaches to `DioException.error`
3. Repository catches `DioException`, returns `Left(failure)`
4. Provider calls `result.fold((f) => throw f, (data) => data)` — throws into `AsyncValue`
5. Screen uses `AsyncValue.when(error: (e, _) => ErrorMessage(...))` to display

---

## 8. Theme Usage

**NEVER hardcode colours, sizes, or text styles:**

```dart
// ❌ NEVER
Text('Hello', style: TextStyle(color: Colors.blue, fontSize: 16))
Container(color: Color(0xFF2563EB), padding: EdgeInsets.all(16))

// ✅ ALWAYS use theme tokens
Text('Hello', style: AppTextStyles.bodyLarge)
Container(
  color: AppColors.primary,
  padding: const EdgeInsets.all(AppSpacing.lg),
)

// ✅ Or use Theme.of(context) for dynamic theme
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
```

**Rules:**
- Colors: `AppColors.*`
- Text styles: `AppTextStyles.*`
- Spacing: `AppSpacing.*`
- Border radius: `AppRadius.*`
- Shadows: `AppShadows.*`
- The only exception: colors that are semantically tied to data (e.g., skill levels use `AppColors.beginnerBg`)

---

## 9. Responsive Layouts

```dart
// Use LayoutBuilder for widget-level responsiveness
LayoutBuilder(builder: (context, constraints) {
  if (constraints.maxWidth > 600) {
    return _WideLayout();
  }
  return _NarrowLayout();
})

// Use MediaQuery for screen-level decisions
final screenWidth = MediaQuery.of(context).size.width;
```

**Breakpoints (consistent across the app):**
- Compact (phone): `< 600`
- Medium (large phone/small tablet): `600 – 840`
- Expanded (tablet): `> 840`

---

## 10. Loading States

**Always use `AsyncValue.when()`:**

```dart
// ✅ Standard pattern
final dataAsync = ref.watch(dataProvider);
dataAsync.when(
  loading: () => const ShimmerSkeleton(),
  error: (e, _) => ErrorMessage(
    message: e.toString(),
    onRetry: () => ref.invalidate(dataProvider),
  ),
  data: (data) => DataContent(data: data),
)

// ❌ NEVER
if (isLoading) return CircularProgressIndicator();
if (error != null) return Text(error!);
return DataContent(data: data!);
```

---

## 11. Adding a New Feature Checklist

When adding a new feature, create these files in order:

1. **Model** — `data/models/[feature]_model.dart`
   - Freezed class with all fields
   - `fromJson` factory
   - Run `flutter pub run build_runner build --delete-conflicting-outputs`

2. **Remote source** — `data/sources/remote/[feature]_remote_source.dart`
   - Dio API calls for this feature
   - Uses `ApiEndpoints` constants

3. **Entity** — `domain/entities/[feature].dart`
   - Pure domain object (optional if model is simple enough)

4. **Repository interface** — `domain/repositories/[feature]_repository.dart`
   - Abstract class with `Either<Failure, T>` methods

5. **Repository impl** — `data/repositories/[feature]_repository_impl.dart`
   - Implements interface
   - Wraps remote source calls in try/catch

6. **Provider** — `features/[feature]/providers/[feature]_provider.dart`
   - `@riverpod` annotated
   - Uses repository via `ref.watch()`
   - Run `build_runner` again

7. **Screen** — `features/[feature]/screens/[feature]_screen.dart`
   - `ConsumerWidget` using `AsyncValue.when()`

8. **Widgets** — `features/[feature]/widgets/*.dart`
   - Feature-specific display widgets

9. **Route** — Add to `config/router/app_router.dart`
   - Path, builder, any guards

10. **Test** — `test/features/[feature]/` (if adding tests)

---

## 12. Code Generation

Run this command after any changes to Freezed models or Riverpod providers:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or for continuous watching during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

**Files that require code generation:**
- `data/models/*.dart` → generates `*.freezed.dart` and `*.g.dart`
- `features/*/providers/*.dart` → generates `*.g.dart`

**Never edit generated files manually.** They are overwritten on every build.

Add to `.gitignore` (optional — some teams commit generated files):
```
# *.freezed.dart
# *.g.dart
```

---

## 13. Anti-Patterns — What NOT to Do

| Anti-Pattern | Why It's Wrong | What to Do Instead |
|--------------|---------------|-------------------|
| Hardcoded colours/sizes | Breaks theme consistency | Use `AppColors`, `AppSpacing`, etc. |
| `setState()` for data state | Doesn't scale, no caching | Use Riverpod providers |
| Manual `isLoading` booleans | Error-prone, duplicates AsyncValue | Use `AsyncValue.when()` |
| Catching and ignoring errors | Hides bugs | Return `Left(Failure)` |
| Business logic in widgets | Untestable, unmaintainable | Put logic in providers/repositories |
| Direct Dio calls in widgets | Bypasses error handling | Go through repository → provider |
| `Navigator.push()` directly | Bypasses route guards | Use `context.go()` / `context.push()` |
| Writing providers without `@riverpod` | Inconsistent, more boilerplate | Always use code generation |
| String concatenation for API paths | Typos, no centralisation | Use `ApiEndpoints` constants |
| Storing tokens in SharedPreferences | Security vulnerability | Use `flutter_secure_storage` |
| Creating widgets inside `build()` | Performance penalty (rebuilds) | Extract to separate widgets/methods |
| Using `late` unnecessarily | NullPointerException risk | Use nullable types or factory constructors |
| Using `dynamic` types | Loses type safety | Always use explicit types |
| Importing implementation classes directly | Breaks dependency inversion | Import interfaces, use DI |

---

## 14. Dart Style

- Use `const` constructors wherever possible
- Use trailing commas for better git diffs and auto-formatting
- Use `final` for all local variables that aren't reassigned
- Use `switch` expressions (Dart 3) for pattern matching
- Use sealed classes for state enums
- Use records for simple tuple returns
- Use named parameters for functions with 2+ parameters
- Run `dart fix --apply` periodically to apply automated fixes

---

## 15. Import Order

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. External packages (alphabetical)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports — core
import 'package:skill_exchange/core/theme/app_colors.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';

// 5. Project imports — feature
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';

// 6. Relative imports (only within the same feature)
import '../widgets/login_form.dart';
```

Use package imports (`package:skill_exchange/...`) for cross-feature imports.
Use relative imports (`../`, `./`) only within the same feature directory.

---

## 16. Git Commit Messages

Follow conventional commits:

```
feat(auth): add login screen with form validation
fix(matching): correct compatibility score calculation
refactor(core): extract shared button variants
chore(deps): update riverpod to 2.6.1
docs(arch): add messaging feature specification
```

Prefix with feature area. Keep subject line under 72 characters.
