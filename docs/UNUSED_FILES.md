# Unused Files Tracker

These files currently exist in the codebase but are not imported anywhere.
They are kept for future use when backend integration is complete.

Last audited: 2026-03-07

## Empty / Stub Files (3)

| File | Notes |
|------|-------|
| `lib/data/models/api_response_model.dart` | Empty — will be needed for generic API response wrapper |
| `lib/domain/entities/notification.dart` | Empty — duplicate of notification_entity.dart |
| `lib/features/dashboard/providers/dashboard_provider.dart` | Comment-only stub — providers live in matching/session providers |

## Domain Entities (12)

The codebase currently uses `data/models/` (Freezed) directly.
These entity files will be needed if a clean architecture domain layer is introduced.

| File |
|------|
| `lib/domain/entities/connection.dart` |
| `lib/domain/entities/conversation.dart` |
| `lib/domain/entities/discussion_post.dart` |
| `lib/domain/entities/leaderboard_entry.dart` |
| `lib/domain/entities/learning_circle.dart` |
| `lib/domain/entities/match_score.dart` |
| `lib/domain/entities/message.dart` |
| `lib/domain/entities/notification_entity.dart` |
| `lib/domain/entities/review.dart` |
| `lib/domain/entities/session.dart` |
| `lib/domain/entities/skill.dart` |
| `lib/domain/entities/user_profile.dart` |

Note: `lib/domain/entities/user.dart` IS used (by auth layer).

## Core Utilities (5)

| File | Notes |
|------|-------|
| `lib/core/constants/app_constants.dart` | App-wide constants — wire up as needed |
| `lib/core/errors/exceptions.dart` | Exception classes — use when implementing error handling in remote sources |
| `lib/core/extensions/context_extensions.dart` | BuildContext helpers — use in screens as needed |
| `lib/core/extensions/string_extensions.dart` | String helpers — use in formatters/validators |
| `lib/core/widgets/search_bar_widget.dart` | Custom search bar — SearchScreen uses TextField directly instead |

## Feature Files Not Yet Wired (7)

| File | Notes |
|------|-------|
| `lib/features/connections/widgets/connection_request_sheet.dart` | Bottom sheet for connection requests — wire to pending_requests.dart |
| `lib/features/notifications/screens/notifications_screen.dart` | Not in router — add route when notifications feature is complete |
| `lib/features/notifications/widgets/notification_badge.dart` | Badge widget — add to app_shell or dashboard when ready |
| `lib/features/reviews/widgets/review_card.dart` | Review display — wire to sessions/profile when reviews are implemented |
| `lib/features/reviews/widgets/review_sheet.dart` | Review form — wire to session completion flow |
| `lib/features/sessions/widgets/session_booking_sheet.dart` | Booking form — wire to match_card/profile "Book Session" buttons |
| `lib/features/sessions/widgets/upcoming_sessions.dart` | Widget — dashboard uses upcoming_sessions_section.dart instead |

## Removed Files

| File | Reason | Date |
|------|--------|------|
| `lib/features/auth/screens/home_screen.dart` | Landing page not needed in mobile app — login is the entry point | 2026-03-07 |
