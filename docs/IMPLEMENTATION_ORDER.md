# Skill Exchange — Implementation Order

> Step-by-step implementation plan, ordered by dependency.
> Foundations first, then features in dependency order.
> Do not skip steps — each depends on the previous.

---

## STEP 1 — PROJECT SETUP

**Goal:** Working project with all packages resolved and build_runner configured.

- [ ] Replace `pubspec.yaml` with the final version from ARCHITECTURE.md
- [ ] Run `flutter pub get` — resolve all dependencies
- [ ] Verify `flutter pub run build_runner build --delete-conflicting-outputs` runs without error
- [ ] Create the complete folder structure from ARCHITECTURE.md (empty `.dart` files with placeholder comments)
- [ ] Set up `analysis_options.yaml` with strict lint rules
- [ ] Create `config/env/env_config.dart` with environment configuration
- [ ] Verify `flutter run` launches successfully on a simulator/emulator

**Deliverable:** Project builds. Folder structure visible. No runtime code yet.

---

## STEP 2 — CORE LAYER

**Goal:** All shared infrastructure in place before any features.

### 2A. Theme System
- [ ] `core/theme/app_colors.dart` — All colour constants (light + dark)
- [ ] `core/theme/app_text_styles.dart` — All TextStyle definitions
- [ ] `core/theme/app_spacing.dart` — Spacing constants
- [ ] `core/theme/app_radius.dart` — BorderRadius constants
- [ ] `core/theme/app_shadows.dart` — BoxShadow definitions
- [ ] `core/theme/app_theme.dart` — `ThemeData` for light mode and dark mode
- [ ] Update `main.dart` to use `AppTheme.lightTheme()` and `AppTheme.darkTheme()`

### 2B. Error Handling
- [ ] `core/errors/failures.dart` — Sealed `Failure` class hierarchy (ServerFailure, AuthFailure, ValidationFailure, NetworkFailure, etc.)
- [ ] `core/errors/exceptions.dart` — Typed exception classes for data sources

### 2C. Constants
- [ ] `core/constants/app_constants.dart` — App name, version, default page size
- [ ] `core/constants/api_endpoints.dart` — All 56+ API path constants (from apiConfig.ts)
- [ ] `core/constants/storage_keys.dart` — All storage key strings

### 2D. Extensions
- [ ] `core/extensions/context_extensions.dart` — Theme, MediaQuery, Navigator shortcuts
- [ ] `core/extensions/string_extensions.dart` — Capitalise, truncate, initials
- [ ] `core/extensions/date_extensions.dart` — Relative time, formatted dates

### 2E. Utilities
- [ ] `core/utils/validators.dart` — Email, password strength, required field validators
- [ ] `core/utils/formatters.dart` — Date, number, duration formatters

### 2F. Networking
- [ ] `data/sources/remote/` — Dio client setup as Riverpod provider
- [ ] Auth interceptor (token injection, 401 handling, refresh)
- [ ] Error interceptor (status code → Failure mapping)
- [ ] Logging interceptor (debug only)
- [ ] `config/di/providers.dart` — Top-level providers for Dio, storage, etc.

### 2G. Local Storage
- [ ] `data/sources/local/secure_storage_source.dart` — Token CRUD
- [ ] `data/sources/local/preferences_source.dart` — Settings, cached user

### 2H. Shared Widgets
- [ ] `core/widgets/app_button.dart` — All variants (primary, secondary, outline, text, destructive, icon)
- [ ] `core/widgets/app_text_field.dart` — Themed input field
- [ ] `core/widgets/app_card.dart` — Themed card wrapper
- [ ] `core/widgets/user_avatar.dart` — Avatar with size variants and fallback
- [ ] `core/widgets/skill_tag.dart` — Level-coloured skill badges
- [ ] `core/widgets/star_rating.dart` — Read-only and interactive star rating
- [ ] `core/widgets/loading_spinner.dart` — Spinner with size variants
- [ ] `core/widgets/skeleton_card.dart` — Shimmer loading placeholders
- [ ] `core/widgets/empty_state.dart` — Empty state with icon, message, action
- [ ] `core/widgets/error_message.dart` — Error display with retry button
- [ ] `core/widgets/search_bar_widget.dart` — Search input with clear

**Deliverable:** All core infrastructure tested and working. App displays with correct theme.

---

## STEP 3 — AUTHENTICATION FEATURE

**Goal:** Login works end-to-end. Token stored. Route protection active.

**Dependencies:** Core layer (Step 2)

### 3A. Data Layer
- [ ] `data/models/user_model.dart` — Freezed model + run build_runner
- [ ] `data/models/auth_dto.dart` — LoginDto, SignupDto, AuthTokensModel, ChangePasswordDto + run build_runner
- [ ] `data/sources/remote/auth_remote_source.dart` — All auth API calls via Dio
- [ ] `domain/entities/user.dart` — Pure User entity
- [ ] `domain/repositories/auth_repository.dart` — Abstract interface
- [ ] `data/repositories/auth_repository_impl.dart` — Implementation with Either<Failure, T>

### 3B. Provider Layer
- [ ] `features/auth/providers/auth_provider.dart` — AuthNotifier with AuthState (sealed class)
- [ ] Auth state: unauthenticated, authenticating, authenticated, error

### 3C. Screens
- [ ] `features/auth/screens/login_screen.dart` — Email/password form, Google OAuth, demo creds
- [ ] `features/auth/screens/signup_screen.dart` — Registration form with password strength
- [ ] `features/auth/screens/forgot_password_screen.dart` — Email input with success state
- [ ] `features/auth/screens/verify_email_screen.dart` — Token verification with states
- [ ] `features/auth/widgets/google_oauth_button.dart` — OAuth button
- [ ] `features/auth/widgets/password_strength_indicator.dart` — Strength meter

### 3D. Integration
- [ ] Wire auth interceptor to read token from secure storage
- [ ] Test login → token stored → API calls include token
- [ ] Test logout → token cleared → redirected to login
- [ ] Test 401 → refresh attempted → success or logout

**Deliverable:** Login, signup, forgot password, email verification all working. Tokens persisted.

---

## STEP 4 — NAVIGATION SHELL

**Goal:** GoRouter fully configured. Bottom navigation working. All routes defined.

**Dependencies:** Authentication (Step 3)

- [ ] `config/router/app_router.dart` — Complete GoRouter with all routes
- [ ] `RouteNames` class with all path constants
- [ ] Auth redirect logic (unauthenticated → login, authenticated auth pages → dashboard)
- [ ] Admin route guard (role check)
- [ ] `ShellRoute` for bottom navigation with 5 tabs (Home, Matches, Connects, Messages, Profile)
- [ ] AppShell widget with `NavigationBar` (bottom nav)
- [ ] Placeholder screens for all routes (just title text)
- [ ] Update `main.dart` to use `MaterialApp.router` with GoRouter
- [ ] Notification badge widget in AppBar
- [ ] Deep link configuration in iOS (Info.plist) and Android (AndroidManifest.xml)

**Deliverable:** All routes navigable. Bottom nav working. Auth-protected routes redirect correctly.

---

## STEP 5 — PROFILE FEATURE

**Goal:** View and edit own profile. View other users' profiles.

**Dependencies:** Auth (Step 3), Navigation (Step 4)

### 5A. Data Layer
- [ ] `data/models/user_profile_model.dart` — Full profile Freezed model + build_runner
- [ ] `data/models/skill_model.dart` — Skill model + enums + build_runner
- [ ] `data/models/update_profile_dto.dart` — Update DTO + build_runner
- [ ] `data/sources/remote/profile_remote_source.dart` — Profile API calls
- [ ] `domain/entities/user_profile.dart`, `domain/entities/skill.dart`
- [ ] `domain/repositories/profile_repository.dart`
- [ ] `data/repositories/profile_repository_impl.dart`

### 5B. Provider Layer
- [ ] `features/profile/providers/profile_provider.dart` — currentProfileProvider, profileProvider(id), updateProfileNotifier

### 5C. Screens & Widgets
- [ ] `features/profile/screens/profile_screen.dart` — View/edit toggle for own, view-only for others
- [ ] `features/profile/widgets/profile_view.dart` — Full profile display
- [ ] `features/profile/widgets/profile_edit.dart` — Tabbed edit form
- [ ] `features/profile/widgets/skills_section.dart` — Add/remove skills
- [ ] `features/profile/widgets/availability_grid.dart` — 7-day toggle
- [ ] `features/profile/widgets/report_user_sheet.dart` — Report bottom sheet
- [ ] `features/profile/widgets/block_user_sheet.dart` — Block bottom sheet

**Deliverable:** Own profile viewable and editable. Other profiles viewable with action buttons.

---

## STEP 6 — DASHBOARD FEATURE

**Goal:** Dashboard screen with real data from profile, matching, and sessions.

**Dependencies:** Profile (Step 5)

- [ ] `features/dashboard/providers/dashboard_provider.dart` — Aggregates profile, top matches, upcoming sessions
- [ ] `features/dashboard/screens/dashboard_screen.dart` — Welcome, stats, matches, sessions, quick actions
- [ ] `features/dashboard/widgets/stats_grid.dart` — 4-card stats
- [ ] `features/dashboard/widgets/top_matches_section.dart` — Mini match cards
- [ ] `features/dashboard/widgets/upcoming_sessions_section.dart` — Mini session cards

**Deliverable:** Dashboard shows real user stats. Quick action navigation works. Pull-to-refresh works.

---

## STEP 7 — SKILL MATCHING FEATURE

**Goal:** Browse matches with filtering, sorting, and pagination.

**Dependencies:** Profile (Step 5)

### 7A. Data Layer
- [ ] `data/models/match_score_model.dart` + `matching_filters_model.dart` + build_runner
- [ ] `data/sources/remote/matching_remote_source.dart`
- [ ] `domain/entities/match_score.dart`
- [ ] `domain/repositories/matching_repository.dart`
- [ ] `data/repositories/matching_repository_impl.dart`

### 7B. Provider & Screens
- [ ] `features/matching/providers/matching_provider.dart` — Paginated matches, filters, sort
- [ ] `features/matching/screens/matching_screen.dart` — Filter + grid + sort
- [ ] `features/matching/widgets/match_card.dart` — Compatibility score, skills, actions
- [ ] `features/matching/widgets/matching_filters.dart` — Filter bottom sheet
- [ ] `features/matching/widgets/compatibility_score.dart` — Colour-coded score display

**Deliverable:** Matching screen with filters, sorting, infinite scroll, and navigation to profiles.

---

## STEP 8 — CONNECTIONS FEATURE

**Goal:** Send, accept, decline, remove connections. Three-tab interface.

**Dependencies:** Profile (Step 5)

### 8A. Data Layer
- [ ] `data/models/connection_model.dart` + build_runner
- [ ] `data/sources/remote/connection_remote_source.dart`
- [ ] `domain/entities/connection.dart`
- [ ] `domain/repositories/connection_repository.dart`
- [ ] `data/repositories/connection_repository_impl.dart`

### 8B. Provider & Screens
- [ ] `features/connections/providers/connections_provider.dart` — Connections, pending, sent, actions
- [ ] `features/connections/screens/connections_screen.dart` — 3-tab layout
- [ ] `features/connections/widgets/connection_list.dart`
- [ ] `features/connections/widgets/pending_requests.dart`
- [ ] `features/connections/widgets/sent_requests.dart`
- [ ] `features/connections/widgets/connection_request_sheet.dart`

**Deliverable:** Full connection management. Accept/decline. Remove with confirmation.

---

## STEP 9 — SESSION BOOKING FEATURE

**Goal:** Book, cancel, reschedule, and complete sessions.

**Dependencies:** Connections (Step 8) — for partner selection

### 9A. Data Layer
- [ ] `data/models/session_model.dart` + `create_session_dto.dart` + `reschedule_session_dto.dart` + build_runner
- [ ] `data/sources/remote/session_remote_source.dart`
- [ ] `domain/entities/session.dart`
- [ ] `domain/repositories/session_repository.dart`
- [ ] `data/repositories/session_repository_impl.dart`

### 9B. Provider & Screens
- [ ] `features/sessions/providers/session_provider.dart` — Sessions, upcoming, create, cancel, complete, reschedule
- [ ] `features/sessions/screens/sessions_screen.dart` — Session list with FAB
- [ ] `features/sessions/widgets/session_card.dart`
- [ ] `features/sessions/widgets/session_booking_sheet.dart`
- [ ] `features/sessions/widgets/reschedule_session_sheet.dart`
- [ ] `features/sessions/widgets/upcoming_sessions.dart`

**Deliverable:** Session booking with all fields. Cancel/complete/reschedule. Meeting link launch.

---

## STEP 10 — REVIEWS & RATINGS FEATURE

**Goal:** Leave reviews after session completion. View reviews on profiles.

**Dependencies:** Sessions (Step 9) — triggered on completion

### 10A. Data Layer
- [ ] `data/models/review_model.dart` + `create_review_dto.dart` + build_runner
- [ ] `data/sources/remote/review_remote_source.dart`
- [ ] `domain/entities/review.dart`
- [ ] `domain/repositories/review_repository.dart`
- [ ] `data/repositories/review_repository_impl.dart`

### 10B. Provider & Widgets
- [ ] `features/reviews/providers/review_provider.dart` — Reviews per user, stats, create
- [ ] `features/reviews/widgets/review_card.dart`
- [ ] `features/reviews/widgets/review_sheet.dart`
- [ ] `features/reviews/widgets/star_rating_input.dart`
- [ ] Wire review sheet to session completion flow

**Deliverable:** Reviews displayed on profiles. Review sheet works after session completion.

---

## STEP 11 — MESSAGING FEATURE

**Goal:** Real-time messaging between connected users.

**Dependencies:** Connections (Step 8)

### 11A. Data Layer
- [ ] `data/models/message_model.dart` + `conversation_model.dart` + build_runner
- [ ] `data/sources/remote/messaging_remote_source.dart`
- [ ] `domain/entities/message.dart`, `conversation.dart`
- [ ] `domain/repositories/messaging_repository.dart`
- [ ] `data/repositories/messaging_repository_impl.dart`

### 11B. Provider & Screens
- [ ] `features/messaging/providers/messaging_provider.dart` — Conversations, messages, send (optimistic), mark read
- [ ] `features/messaging/screens/conversations_screen.dart` — Conversation list
- [ ] `features/messaging/screens/chat_screen.dart` — Message bubbles + input
- [ ] `features/messaging/widgets/conversation_tile.dart`
- [ ] `features/messaging/widgets/message_bubble.dart`
- [ ] `features/messaging/widgets/message_input.dart`

### 11C. WebSocket Integration (if backend supports)
- [ ] WebSocket connection for real-time message delivery
- [ ] Message received → update conversation list + active chat

**Deliverable:** Conversations list. Chat with real-time messages. Optimistic send. Mark as read.

---

## STEP 12 — NOTIFICATIONS FEATURE

**Goal:** In-app and push notification support.

**Dependencies:** Auth (Step 3)

### 12A. Data Layer
- [ ] `data/models/notification_model.dart` + build_runner
- [ ] `data/sources/remote/notification_remote_source.dart`
- [ ] `domain/entities/notification.dart`
- [ ] `domain/repositories/notification_repository.dart`
- [ ] `data/repositories/notification_repository_impl.dart`

### 12B. Provider & Screens
- [ ] `features/notifications/providers/notification_provider.dart`
- [ ] `features/notifications/screens/notifications_screen.dart`
- [ ] `features/notifications/widgets/notification_tile.dart`
- [ ] `features/notifications/widgets/notification_badge.dart` — Wire to AppBar

### 12C. Push Notifications
- [ ] Firebase Messaging setup (iOS + Android)
- [ ] `flutter_local_notifications` configuration
- [ ] Background message handling
- [ ] Notification tap → navigate to actionUrl

**Deliverable:** Notification list. Unread badge. Push notifications. Tap-to-navigate.

---

## STEP 13 — SEARCH & DISCOVERY FEATURE

**Goal:** Search users by name, skills, filters.

**Dependencies:** Profile (Step 5)

- [ ] `data/models/search_result_model.dart` + build_runner
- [ ] `data/sources/remote/search_remote_source.dart`
- [ ] `domain/repositories/search_repository.dart`
- [ ] `data/repositories/search_repository_impl.dart`
- [ ] `features/search/providers/search_provider.dart` — Debounced search
- [ ] `features/search/screens/search_screen.dart`
- [ ] `features/search/widgets/search_result_card.dart`

**Deliverable:** Search with debounce. Results navigate to profiles.

---

## STEP 14 — COMMUNITY FEATURE

**Goal:** Discussion forum, learning circles, leaderboard.

**Dependencies:** Profile (Step 5)

### 14A. Data Layer
- [ ] `data/models/discussion_post_model.dart` + `learning_circle_model.dart` + `leaderboard_entry_model.dart` + build_runner
- [ ] `data/sources/remote/community_remote_source.dart`
- [ ] Domain entities + repository interface + implementation

### 14B. Provider & Screens
- [ ] `features/community/providers/community_provider.dart`
- [ ] `features/community/screens/community_screen.dart` — 3 tabs
- [ ] `features/community/widgets/discussion_card.dart`
- [ ] `features/community/widgets/learning_circle_card.dart`
- [ ] `features/community/widgets/leaderboard_tile.dart`
- [ ] `features/community/widgets/create_post_sheet.dart`
- [ ] `features/community/widgets/create_circle_sheet.dart`

**Deliverable:** All three community tabs working. Create, like, join/leave.

---

## STEP 15 — SETTINGS FEATURE

**Goal:** Notification prefs, privacy settings, account management.

**Dependencies:** Auth (Step 3)

- [ ] `features/settings/providers/settings_provider.dart` — Notification, privacy, account settings
- [ ] `features/settings/screens/settings_screen.dart`
- [ ] `features/settings/widgets/notification_settings.dart`
- [ ] `features/settings/widgets/privacy_settings.dart`
- [ ] `features/settings/widgets/account_settings.dart`

**Deliverable:** All settings read/write. Password change. Account deletion.

---

## STEP 16 — ADMIN FEATURE

**Goal:** Platform administration for admin-role users.

**Dependencies:** All features (admin views aggregate data from all features)

### 16A. Data Layer
- [ ] `data/models/user_report_model.dart` + `platform_stats_model.dart` + build_runner
- [ ] `data/sources/remote/admin_remote_source.dart`
- [ ] `domain/repositories/admin_repository.dart`
- [ ] `data/repositories/admin_repository_impl.dart`

### 16B. Provider & Screens
- [ ] `features/admin/providers/admin_provider.dart`
- [ ] `features/admin/screens/admin_dashboard_screen.dart`
- [ ] `features/admin/screens/user_management_screen.dart`
- [ ] `features/admin/screens/content_moderation_screen.dart`
- [ ] `features/admin/widgets/admin_stats_grid.dart`
- [ ] `features/admin/widgets/user_action_sheet.dart`
- [ ] `features/admin/widgets/report_card.dart`

**Deliverable:** Admin dashboard, user management, content moderation.

---

## STEP 17 — LANDING PAGE

**Goal:** Home screen for unauthenticated users.

**Dependencies:** Navigation (Step 4)

- [ ] `features/auth/screens/home_screen.dart` — Hero, how-it-works, testimonials, CTAs
- [ ] Responsive layout

**Deliverable:** Landing page with navigation to login/signup.

---

## STEP 18 — POLISH

**Goal:** Production-quality UX across the entire app.

### 18A. Animations & Transitions
- [ ] Page transitions (fade, slide) via GoRouter
- [ ] Hero animations for avatars between screens
- [ ] Bottom sheet entry/exit animations
- [ ] Button press feedback (ink well, scale)
- [ ] List item entry animations (staggered fade-in)

### 18B. Loading States
- [ ] Audit every screen — ensure shimmer skeletons are used, not plain spinners
- [ ] Ensure pull-to-refresh works on every data screen
- [ ] Ensure infinite scroll has a loading indicator at the bottom

### 18C. Error States
- [ ] Audit every screen — ensure ErrorMessage with retry is shown on failure
- [ ] Ensure snackbar errors for mutation failures
- [ ] Ensure validation errors display inline on form fields
- [ ] Network connectivity overlay when offline

### 18D. Empty States
- [ ] Audit every list screen — ensure EmptyState with appropriate message and action
- [ ] Match empty states to the web app's patterns

### 18E. Platform-Specific
- [ ] iOS: test with SafeArea, keyboard dismissal, native date pickers
- [ ] Android: test with back button behavior, material date pickers
- [ ] Test on multiple screen sizes (phone, tablet)

### 18F. Accessibility
- [ ] Semantic labels on all interactive elements
- [ ] Sufficient colour contrast
- [ ] Touch target sizes (minimum 48x48)
- [ ] Screen reader testing

**Deliverable:** Production-ready app. All states handled. Smooth UX.

---

## Dependency Graph

```
Step 1 (Setup)
  └── Step 2 (Core)
       └── Step 3 (Auth) ←── ALL OTHER FEATURES DEPEND ON THIS
            └── Step 4 (Navigation)
                 ├── Step 5 (Profile) ←── MOST FEATURES DEPEND ON THIS
                 │    ├── Step 6 (Dashboard) — needs profile + matching + sessions
                 │    ├── Step 7 (Matching) — needs profile
                 │    ├── Step 8 (Connections) — needs profile
                 │    │    ├── Step 9 (Sessions) — needs connections
                 │    │    │    └── Step 10 (Reviews) — needs sessions
                 │    │    └── Step 11 (Messaging) — needs connections
                 │    ├── Step 13 (Search) — needs profile
                 │    └── Step 14 (Community) — needs profile
                 ├── Step 12 (Notifications) — needs auth only
                 ├── Step 15 (Settings) — needs auth only
                 └── Step 16 (Admin) — needs all features
Step 17 (Landing) — independent of data features
Step 18 (Polish) — after all features
```

---

## Estimated Feature Count

| Step | Feature | Screens | Widgets | Models | Providers | API Calls |
|------|---------|---------|---------|--------|-----------|-----------|
| 3 | Auth | 4 | 2 | 4 | 1 | 10 |
| 5 | Profile | 1 | 6 | 3 | 1 | 4 |
| 6 | Dashboard | 1 | 3 | 0 | 1 | 3 |
| 7 | Matching | 1 | 3 | 2 | 1 | 2 |
| 8 | Connections | 1 | 4 | 1 | 1 | 7 |
| 9 | Sessions | 1 | 4 | 3 | 1 | 5 |
| 10 | Reviews | 0 | 3 | 2 | 1 | 3 |
| 11 | Messaging | 2 | 3 | 2 | 1 | 4 |
| 12 | Notifications | 1 | 2 | 1 | 1 | 5 |
| 13 | Search | 1 | 1 | 1 | 1 | 1 |
| 14 | Community | 1 | 5 | 3 | 1 | 9 |
| 15 | Settings | 1 | 3 | 0 | 1 | 2 |
| 16 | Admin | 3 | 3 | 2 | 1 | 3 |
| 17 | Landing | 1 | 0 | 0 | 0 | 0 |
| **Total** | | **19** | **42** | **24** | **13** | **56*** |

*\* 56 unique API endpoints (see API.md). Per-feature counts above include shared endpoints consumed by multiple features (e.g., Dashboard calls endpoints owned by Profile, Matching, and Sessions).*
