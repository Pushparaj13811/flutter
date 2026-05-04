# Design Spec: Session-Based Reviews, Agora Video Call & UI/UX Overhaul

**Date:** 2026-05-04
**Status:** Approved

---

## 1. Session-Based Review System

### Rules
- Users can only review someone after completing at least one session with them
- One review per completed session (not per person)
- `sessionId` in `CreateReviewDto` is **required**
- Validation: session must be `completed` and user must be a participant

### Flow
1. User taps "Complete" on session -> confirmation -> session marked complete -> review bottom sheet auto-appears
2. Review sheet: star rating (1-5), comment (10-1000 chars), skills reviewed (pre-populated from session's `skillsToCover`)
3. "Skip" button dismisses sheet
4. Completed sessions without a review show "Leave Review" button on the session card
5. Reviews visible on user profiles (existing review card + stats)

### Data Changes
- Add `isReviewed: bool` to `SessionModel` — tracks whether the current user has left a review for this session
- `sessionId` in `CreateReviewDto` becomes required (currently optional)
- Review creation validates: session exists, session is completed, user is host or participant, no duplicate review for same session+user combo

### No New Screens
- Reuses existing `ReviewSheet` widget
- Wired into session completion flow in `SessionsNotifier`
- "Leave Review" button added to completed session cards

---

## 2. In-App Video Call (Agora SDK)

### Dependencies
- `agora_rtc_engine` — Agora RTC SDK for Flutter
- `permission_handler` — Camera/microphone permissions

### Architecture
- Agora RTC SDK handles media streaming
- Existing Firestore `calls` collection for signaling (caller/callee status tracking)
- Call state managed via Riverpod StateNotifier
- Channel name = Firestore call document ID
- App ID stored in environment config

### Screens & UI

#### Call Screen (full screen, rootNavigator)
- Remote video fills the entire screen background
- Local video in small draggable picture-in-picture corner (top-right, ~120x160)
- Bottom control bar (semi-transparent): mic toggle, camera toggle, switch camera, end call (red)
- Top bar: caller/callee name, call duration timer (MM:SS)
- Connection status indicator: "Connecting...", "Connected", "Reconnecting..."
- Starts as video call; user can toggle camera off (becomes voice-only with avatar)

#### Incoming Call Overlay (full screen)
- Caller avatar (large, centered), caller name
- Accept button (green, camera icon) and Decline button (red, phone-down icon)
- Shown when Firestore stream detects incoming call with status `ringing`

#### Call Initiation Points
- Video call icon button on chat screen app bar
- Video call button on connection profile
- "Join Meeting" button on online session cards triggers in-app Agora call

### Call Flow
1. Caller taps video call -> request camera+mic permissions -> create Firestore call doc (status: `ringing`) -> navigate to call screen -> initialize Agora engine -> join channel
2. Callee: Firestore stream detects incoming call -> show incoming call overlay
3. Callee accepts -> update Firestore status to `active` -> navigate to call screen -> join same Agora channel
4. Either party ends call -> update Firestore status to `ended` -> leave Agora channel -> navigate back
5. Callee declines -> update Firestore status to `declined` -> caller sees "Call Declined" -> navigate back

### Agora Configuration
- App ID in environment/config (no hardcoding)
- For development: no token authentication (testing mode)
- For production: token server needed (cloud function) — out of scope for now, noted as TODO
- Channel name = call document ID for uniqueness

### Permissions
- Camera and microphone permissions requested before initiating/accepting call
- Graceful handling if denied (show settings prompt)

---

## 3. UI/UX Overhaul

### Principles (from reference app)
- Compact, tight spacing — mobile-first, not web-like
- Clean cards with subtle borders, minimal shadows
- Consistent section headers with "View All" action links
- Gradient headers for profile/account areas
- Floating action button in bottom nav center
- Brand colors preserved (emerald green #059669)

### Global Design Token Changes

| Token | Current | New |
|-------|---------|-----|
| screenPadding | 16px | 12px |
| cardPadding | 16px | 12px |
| sectionGap | 24px | 16px |
| itemSpacing | 12-16px | 8-10px |
| Card border radius | 12px | 10px |
| Button border radius | 12px | 10px |
| Input border radius | 12px | 8px |
| Body text (large/medium/small) | 16/14/12 | 15/13/11 |
| AppBar | default | compact (no excess padding) |

### Bottom Navigation Overhaul
- Center floating action button (emerald green "+" icon, like reference app)
- 4 nav items around FAB: Home, Discover, Connects, Profile
- Community accessible from home/discover, not a separate tab
- Settings accessible from profile screen, not a separate tab
- Cleaner icons, smaller label text
- No elevation shadow on nav bar — use top border line instead

### Screen-by-Screen Polish

#### Dashboard (Home)
- Compact header: avatar (36px) + greeting + notification bell
- Search bar below header
- Horizontal scrollable category chips/cards
- Compact session reminder cards
- Tighter vertical spacing between sections

#### Matching (Discover)
- Compact match cards with less whitespace
- Tighter padding inside cards
- Smaller skill chips

#### Connections
- Tighter list items: 40px avatars, single-line subtitle
- Compact padding (8px vertical per item)
- Thin dividers

#### Profile
- Gradient header (emerald gradient) with avatar, name, stats
- Stats in a 2x2 grid (like reference: sessions, reviews, skills, connections)
- Below: clean list items for Edit Profile, My Reviews, Settings, etc.
- Thin dividers, icon + label + chevron pattern

#### Sessions (/bookings)
- Compact session cards: tighter padding, smaller text
- Status badge inline with title (not separate row)
- Action buttons as compact row

#### Settings (redesigned — accessed from Profile)
- No heavy section cards — simple list items
- Each item: leading icon (in circle bg) + title + trailing chevron
- Thin dividers between items
- Sections: Account, Notifications, Privacy, Appearance, Support
- Logout at bottom (red text)
- Version info as subtle footer text

#### Chat / Messaging
- Tighter message bubbles (8px padding instead of 12px)
- Compact input bar
- Smaller timestamps

#### Community
- Compact post cards
- Tighter comment spacing
- Inline action bar (like, comment, share) with smaller icons

#### Search
- Clean search bar (no heavy borders)
- Compact result items

#### Auth Screens (Login, Signup, etc.)
- Tighter form spacing (12px between fields instead of 16px)
- Compact buttons
- Less vertical padding around logo/header

### Widget Updates
- `AppCard` — reduce default padding to 12px, thinner border
- `AppButton` — reduce vertical padding, slightly smaller text
- `AppTextField` — reduce content padding, smaller label text
- `UserAvatar` — default size 40px (down from 48px)
- `SkillTag` — smaller padding, smaller font
- Section headers — bold title left + "View All" text button right

---

## 4. File Changes Summary

### New Files
- `lib/features/sessions/widgets/video_call_screen.dart` — Agora video call UI
- `lib/features/sessions/widgets/incoming_call_overlay.dart` — Incoming call UI
- `lib/features/sessions/providers/call_provider.dart` — Call state management
- `lib/core/services/agora_service.dart` — Agora engine wrapper

### Modified Files
- `pubspec.yaml` — Add agora_rtc_engine, permission_handler
- `lib/core/theme/app_spacing.dart` — Tighten spacing tokens
- `lib/core/theme/app_radius.dart` — Adjust radius tokens
- `lib/core/theme/app_typography.dart` — Adjust font sizes
- `lib/core/theme/app_theme.dart` — Update component themes
- `lib/core/widgets/app_card.dart` — Reduce padding
- `lib/core/widgets/app_button.dart` — Compact sizing
- `lib/core/widgets/app_text_field.dart` — Compact sizing
- `lib/core/widgets/user_avatar.dart` — Default 40px
- `lib/core/widgets/skill_tag.dart` — Compact sizing
- `lib/config/router/app_shell.dart` — FAB + 4-tab nav
- `lib/config/router/app_router.dart` — Remove community/settings tabs, add call route
- `lib/data/models/session_model.dart` — Add isReviewed field
- `lib/data/models/review_model.dart` — sessionId required
- `lib/features/sessions/providers/session_provider.dart` — Wire review prompt on completion
- `lib/features/sessions/screens/sessions_screen.dart` — Add "Leave Review" button
- `lib/features/sessions/widgets/session_card.dart` — Compact layout + review button
- `lib/features/settings/screens/settings_screen.dart` — Redesign to clean list style
- `lib/features/profile/screens/profile_screen.dart` — Gradient header + settings access
- `lib/features/dashboard/screens/dashboard_screen.dart` — Compact layout
- `lib/features/matching/screens/matching_screen.dart` — Compact cards
- `lib/features/connections/screens/connections_screen.dart` — Tight list
- `lib/features/messaging/screens/chat_screen.dart` — Compact bubbles + call button
- `lib/features/community/screens/community_screen.dart` — Compact posts
- `lib/features/search/screens/search_screen.dart` — Compact results
- All auth screens — Tighter form spacing
