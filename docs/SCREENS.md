# Skill Exchange — Flutter Screen Inventory

> Complete screen inventory for the Flutter app.
> Every screen, its route, widgets, providers, states, and interactions.

---

## 1. HomeScreen (Landing)

**File:** `lib/features/auth/screens/home_screen.dart`
**Route:** `/` (public)

**Purpose:** Landing page for unauthenticated users. Showcases the platform's value proposition.

**Widgets composed:**
- Hero section with title, description, CTA buttons (Get Started → /signup, Login → /login)
- "How It Works" section (3 steps: Create Profile, Find Matches, Start Learning)
- Value proposition cards
- Testimonials section (3 testimonials with star ratings)
- Bottom CTA section

**Providers consumed:** `authProvider` (to redirect to /dashboard if already authenticated)

**User interactions:**
- Tap "Get Started" → navigates to /signup
- Tap "Login" → navigates to /login

**Navigation actions:** → /signup, → /login, → /dashboard (if authenticated)

**Loading state:** None (static content)
**Empty state:** N/A
**Error state:** N/A
**Pull-to-refresh:** No

---

## 2. LoginScreen

**File:** `lib/features/auth/screens/login_screen.dart`
**Route:** `/login` (public)

**Purpose:** Email/password authentication with Google OAuth option.

**Widgets composed:**
- App logo
- Email text field (validated: required, email format)
- Password text field (validated: required, min 8 chars)
- "Remember Me" checkbox
- Login button (primary, shows loading spinner)
- GoogleOAuthButton widget
- "Forgot Password?" link
- "Don't have an account? Sign up" link
- Demo credentials display card (demo@skillexchange.com / Demo123!@#)

**Providers consumed:** `authProvider` (for login action and state)

**User interactions:**
- Submit login form → calls `authProvider.login(email, password)`
- Tap Google button → initiates Google OAuth flow
- Tap "Forgot Password?" → navigates to /forgot-password
- Tap "Sign up" → navigates to /signup

**Navigation actions:** → /dashboard (on success), → /forgot-password, → /signup

**Loading state:** Login button shows `LoadingSpinner` while `AuthAuthenticating`
**Empty state:** N/A
**Error state:** Inline error text below form fields for validation. Snackbar for server errors.
**Pull-to-refresh:** No

---

## 3. SignupScreen

**File:** `lib/features/auth/screens/signup_screen.dart`
**Route:** `/signup` (public)

**Purpose:** New user registration.

**Widgets composed:**
- App logo
- Full name text field
- Email text field
- Password text field with PasswordStrengthIndicator widget
- Confirm password text field
- Terms & conditions checkbox with link
- Sign up button (primary, loading state)
- GoogleOAuthButton widget
- "Already have an account? Login" link

**Providers consumed:** `authProvider` (for signup action and state)

**User interactions:**
- Submit signup form → calls `authProvider.signup(name, email, password)`
- Tap Google button → Google OAuth
- Tap "Login" link → navigates to /login

**Navigation actions:** → /dashboard (on success), → /login

**Loading state:** Signup button shows spinner during registration
**Empty state:** N/A
**Error state:** Inline field errors. Snackbar for duplicate email or server errors.
**Pull-to-refresh:** No

---

## 4. ForgotPasswordScreen

**File:** `lib/features/auth/screens/forgot_password_screen.dart`
**Route:** `/forgot-password` (public)

**Purpose:** Request password reset email.

**Widgets composed:**
- Back button
- Title and description text
- Email text field
- Submit button
- Success state: confirmation message with auto-redirect timer

**Providers consumed:** `authProvider` (for forgotPassword action)

**User interactions:**
- Submit email → calls `authProvider.forgotPassword(email)`
- On success → shows confirmation, auto-redirects to /login after 3 seconds

**Navigation actions:** → /login (on success or back)

**Loading state:** Submit button shows spinner
**Empty state:** N/A
**Error state:** Inline error for invalid email. Snackbar for server errors.
**Pull-to-refresh:** No

---

## 5. VerifyEmailScreen

**File:** `lib/features/auth/screens/verify_email_screen.dart`
**Route:** `/verify-email` (public, receives token via query param or deep link)

**Purpose:** Verify email address using token from email link.

**Widgets composed:**
- Loading state: spinner with "Verifying your email..." text
- Success state: checkmark icon, "Email verified!" text, auto-redirect to /login
- Error state: error icon, message, "Resend verification" button

**Providers consumed:** `authProvider` (for verifyEmail action)

**User interactions:**
- Automatic verification on screen load using token from URL
- Tap "Resend" on error → resends verification email

**Navigation actions:** → /login (auto-redirect after 3s on success)

**Loading state:** Full-screen centered spinner
**Empty state:** N/A
**Error state:** Full-screen centered error with retry button
**Pull-to-refresh:** No

---

## 6. DashboardScreen

**File:** `lib/features/dashboard/screens/dashboard_screen.dart`
**Route:** `/dashboard` (authenticated)

**Purpose:** Main landing page after login. Overview of user activity and quick actions.

**Widgets composed:**
- Welcome message with user's first name
- StatsGrid (4 cards): Connections count, Sessions completed, Reviews received, Average rating
- TopMatchesSection: Up to 5 mini MatchCards with compatibility scores, "View All" button
- UpcomingSessionsSection: Up to 3 SessionCards, "View All" button
- Quick action buttons: Find Matches, Browse Skills, Community

**Providers consumed:**
- `currentProfileProvider` (for user stats and name)
- `topMatchesProvider(limit: 5)` (for match suggestions)
- `upcomingSessionsProvider` (for upcoming sessions, limited to 3)

**User interactions:**
- Tap stats card → navigates to respective full list
- Tap match card → navigates to /profile/:userId
- Tap session card → navigates to /bookings
- Tap "View All Matches" → navigates to /matching
- Tap "View All Sessions" → navigates to /bookings
- Tap quick action → navigates to /matching, /search, /community

**Navigation actions:** → /matching, → /bookings, → /profile/:id, → /search, → /community

**Loading state:** `SkeletonCard` placeholders for stats, matches, and sessions sections
**Empty state:** Each section has its own empty state (e.g., "No upcoming sessions")
**Error state:** `ErrorMessage` with retry for each section independently
**Pull-to-refresh:** Yes — refreshes all dashboard data

---

## 7. ProfileScreen

**File:** `lib/features/profile/screens/profile_screen.dart`
**Route:** `/profile` (own) or `/profile/:userId` (other user) (authenticated)

**Purpose:** View user profile. Own profile supports editing. Other profiles show action buttons.

**Widgets composed:**
- **Own profile — View mode:** ProfileView widget
  - Avatar (xl size), name, username, verification badge
  - Stats row: connections, sessions, reviews, rating
  - Bio section
  - Skills to Teach (SkillTag badges)
  - Skills to Learn (SkillTag badges)
  - Languages (outline badges)
  - Interests (chips)
  - Availability grid (7 days with availability indicators)
  - Preferred learning style
  - Reviews section (ReviewCard list)
  - Edit button (FAB or AppBar action)

- **Own profile — Edit mode:** ProfileEdit widget
  - Tabbed form: Basic Info / Skills / Interests / Availability
  - Basic Info: fullName, bio, location, timezone, preferredLearningStyle
  - Skills: Two SkillsSection widgets (teach and learn)
  - Interests: Add/remove interest chips
  - Availability: Day-of-week toggle switches
  - Save button, Cancel button

- **Other user's profile:** ProfileView widget + action bar
  - Book Session button → opens SessionBookingSheet
  - Connect button → opens ConnectionRequestSheet
  - More menu: Block, Report

**Providers consumed:**
- `currentProfileProvider` (own profile)
- `profileProvider(userId)` (other user)
- `updateProfileNotifier` (for editing)
- `reviewsProvider(userId)` (for reviews section)
- `connectionStatusProvider(userId)` (for connect button state)

**User interactions:**
- Tap Edit → toggles to edit mode
- Tap Save → submits profile update
- Tap Book Session → opens SessionBookingSheet
- Tap Connect → opens ConnectionRequestSheet
- Tap Block → opens BlockUserSheet
- Tap Report → opens ReportUserSheet

**Navigation actions:** → /messages/:id (from message button), back to previous screen

**Loading state:** `SkeletonCard.profile()` while loading
**Empty state:** "No skills added yet" for empty skill sections. "No reviews yet" for reviews.
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes

**Bottom sheet flows:**
- SessionBookingSheet (triggered from "Book Session")
- ConnectionRequestSheet (triggered from "Connect")
- BlockUserSheet (triggered from menu)
- ReportUserSheet (triggered from menu)

---

## 8. MatchingScreen

**File:** `lib/features/matching/screens/matching_screen.dart`
**Route:** `/matching` (authenticated)

**Purpose:** Browse and filter skill matches. Main discovery interface.

**Widgets composed:**
- AppBar with title and match count
- Filter icon button → opens MatchingFilters as bottom sheet
- Sort dropdown (Best Match, Highest Rated, Most Sessions, Recently Active)
- Match list/grid: MatchCard widgets
- MatchingFilters bottom sheet: skill name, category, location, min rating, learning style, availability

**Providers consumed:**
- `paginatedMatchesProvider(filters)` (paginated match list)
- `matchingFiltersProvider` (current filter state)
- `matchingSortProvider` (current sort)
- `skillCategoriesProvider` (for filter dropdowns)

**User interactions:**
- Tap filter icon → opens MatchingFilters bottom sheet
- Adjust filters → updates matchingFiltersProvider → refetches matches
- Tap sort → changes sort order
- Scroll to bottom → loads next page (infinite scroll)
- Tap MatchCard → navigates to /profile/:userId
- Tap "Book" on card → opens SessionBookingSheet
- Tap "Connect" on card → opens ConnectionRequestSheet

**Navigation actions:** → /profile/:id, opens SessionBookingSheet, opens ConnectionRequestSheet

**Loading state:** `SkeletonCard.match()` grid while loading. Spinner at bottom while loading more.
**Empty state:** `EmptyState` with "No matches found" message and "Adjust Filters" action
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes — resets pagination and refetches

**Bottom sheet flows:**
- MatchingFilters (filter configuration)
- SessionBookingSheet (from match card)
- ConnectionRequestSheet (from match card)

---

## 9. ConnectionsScreen

**File:** `lib/features/connections/screens/connections_screen.dart`
**Route:** `/connections` (authenticated)

**Purpose:** Manage connections. Three tabs: active connections, incoming requests, sent requests.

**Widgets composed:**
- TabBar with 3 tabs: Connections, Requests (with badge count), Sent
- **Connections tab:** ConnectionList — grid of connection cards
  - Each card: avatar, name, username, top skills, connected date
  - Actions: Message, Book, Remove (with confirmation dialog)
- **Requests tab:** PendingRequests — list of incoming requests
  - Each card: avatar, name, username, skills, message preview, time
  - Actions: Accept, Decline, View Profile
- **Sent tab:** SentRequests — list of sent requests with status

**Providers consumed:**
- `connectionsProvider` (accepted connections)
- `pendingRequestsProvider` (incoming requests with count for badge)
- `sentRequestsProvider` (sent requests)
- `connectionsNotifier` (for actions: respond, remove)

**User interactions:**
- Tap "Message" → navigates to /messages/:userId
- Tap "Book" → navigates to /bookings
- Tap "Remove" → shows confirmation dialog → removes connection
- Tap "Accept" → accepts request → refreshes lists
- Tap "Decline" → declines request → refreshes lists
- Tap "View Profile" → navigates to /profile/:userId

**Navigation actions:** → /messages/:id, → /bookings, → /profile/:id

**Loading state:** `SkeletonCard` grid per tab
**Empty state:** Per tab: "No connections yet", "No pending requests", "No sent requests"
**Error state:** `ErrorMessage` with retry per tab
**Pull-to-refresh:** Yes, per active tab

---

## 10. SessionsScreen

**File:** `lib/features/sessions/screens/sessions_screen.dart`
**Route:** `/bookings` (authenticated)

**Purpose:** View and manage learning sessions. Book new sessions.

**Widgets composed:**
- AppBar with title
- FAB or AppBar action: "New Booking" → opens SessionBookingSheet
- Session list: SessionCard widgets
- Each SessionCard: title, host/participant avatar, teaching/learning label, description, skill badges, date/time/duration, status badge, action buttons

**Providers consumed:**
- `upcomingSessionsProvider` (session list)
- `sessionsNotifier` (for actions: cancel, complete, reschedule)

**User interactions:**
- Tap "New Booking" → opens SessionBookingSheet
- Tap "Join Meeting" → opens meeting link via url_launcher
- Tap "Complete" → shows confirmation → triggers ReviewSheet
- Tap "Reschedule" → opens RescheduleSessionSheet
- Tap "Cancel" → shows confirmation dialog → cancels session

**Navigation actions:** Opens external meeting link. Opens ReviewSheet on complete.

**Loading state:** `SkeletonCard.session()` list
**Empty state:** `EmptyState` with "No sessions scheduled" and "Book a Session" action
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes

**Bottom sheet flows:**
- SessionBookingSheet (new booking)
- RescheduleSessionSheet (reschedule existing)
- ReviewSheet (triggered after completing a session)

---

## 11. ConversationsScreen

**File:** `lib/features/messaging/screens/conversations_screen.dart`
**Route:** `/messages` (authenticated)

**Purpose:** List of all message conversations.

**Widgets composed:**
- AppBar with title
- Conversation list: ConversationTile widgets
- Each tile: avatar (with unread badge), name, last message preview, relative time, bold if unread

**Providers consumed:**
- `conversationsProvider` (conversation list)

**User interactions:**
- Tap conversation → navigates to /messages/:conversationId

**Navigation actions:** → /messages/:conversationId

**Loading state:** `SkeletonCard.message()` list
**Empty state:** `EmptyState` with "No conversations yet" and "Find Matches" action
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes

---

## 12. ChatScreen

**File:** `lib/features/messaging/screens/chat_screen.dart`
**Route:** `/messages/:conversationId` (authenticated)

**Purpose:** Individual chat with a user. Real-time messaging.

**Widgets composed:**
- AppBar with avatar, user name, "Active now" status
- Scrollable message list: MessageBubble widgets
  - Own messages: right-aligned, primary colour background
  - Other's messages: left-aligned, muted colour background
  - Timestamps shown for each message
- MessageInput at bottom: text field with send button

**Providers consumed:**
- `messagesProvider(conversationId)` (message list)
- `messagingNotifier` (for sending messages with optimistic updates)

**User interactions:**
- Type message + tap send or press Enter → sends message
- Scroll up → loads older messages (if paginated)
- Screen opens → marks conversation as read

**Navigation actions:** ← back to /messages

**Loading state:** `SkeletonCard.message()` bubbles while loading
**Empty state:** "Start a conversation" centered message
**Error state:** `ErrorMessage` with retry. Failed sends show retry icon on message.
**Pull-to-refresh:** No (scroll up to load older messages)

---

## 13. SearchScreen

**File:** `lib/features/search/screens/search_screen.dart`
**Route:** `/search` (authenticated)

**Purpose:** Search for users by name, skills, or criteria.

**Widgets composed:**
- SearchBarWidget (auto-focused on entry)
- Result count text
- Results grid: SearchResultCard widgets
- Each card: avatar, name (tappable to profile), bio preview, top 2 skill badges

**Providers consumed:**
- `searchProvider` (debounced search results)

**User interactions:**
- Type in search bar → debounced search (300ms) → results update
- Tap result card → navigates to /profile/:userId
- Tap clear → clears search and results

**Navigation actions:** → /profile/:id

**Loading state:** `SkeletonCard` grid while searching
**Empty state:** "No users found" with suggestion to adjust search
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** No

---

## 14. CommunityScreen

**File:** `lib/features/community/screens/community_screen.dart`
**Route:** `/community` (authenticated)

**Purpose:** Community features: discussions, learning circles, leaderboard.

**Widgets composed:**
- TabBar with 3 tabs: Discussions, Learning Circles, Leaderboard

- **Discussions tab:**
  - FAB: "New Post" → opens CreatePostSheet
  - DiscussionCard list: author, title, content (3-line clamp), category badge, tags, like button, reply count
  - Tap card → expands to show replies (or navigates to detail)

- **Learning Circles tab:**
  - FAB: "Create Circle" → opens CreateCircleSheet
  - LearningCircleCard grid: name, category, description, member count/max, join/leave button

- **Leaderboard tab:**
  - LeaderboardTile list: rank (trophy for top 3), avatar, name, stats, score badge

**Providers consumed:**
- `discussionPostsProvider` (post list)
- `learningCirclesProvider` (circle list)
- `leaderboardProvider` (leaderboard entries)
- `communityNotifier` (for actions: like, unlike, join, leave, create)

**User interactions:**
- Tap like → toggles like (optimistic update)
- Tap "Join" circle → joins circle
- Tap "Leave" circle → leaves circle
- Tap "New Post" → opens CreatePostSheet
- Tap "Create Circle" → opens CreateCircleSheet
- Tap author name → navigates to /profile/:id

**Navigation actions:** → /profile/:id, opens CreatePostSheet, opens CreateCircleSheet

**Loading state:** `SkeletonCard` per tab
**Empty state:** Per tab: "No discussions yet", "No learning circles", "No leaderboard data"
**Error state:** `ErrorMessage` with retry per tab
**Pull-to-refresh:** Yes, per active tab

**Bottom sheet flows:**
- CreatePostSheet (new discussion post)
- CreateCircleSheet (new learning circle)

---

## 15. SettingsScreen

**File:** `lib/features/settings/screens/settings_screen.dart`
**Route:** `/settings` (authenticated)

**Purpose:** User settings for notifications, privacy, and account management.

**Widgets composed:**
- ListView with 3 sections:

- **Notification Settings section:**
  - Toggle switches: email notifications, push notifications, connection requests, session reminders, new messages, reviews, marketing emails

- **Privacy Settings section:**
  - Profile Visibility dropdown (Public/Connections Only/Private)
  - Show Email toggle
  - Show Location toggle
  - Show Online Status toggle
  - Who Can Message dropdown (Everyone/Connections Only/No One)

- **Account Settings section:**
  - Change Email card with form
  - Change Password card with form (current + new + confirm)
  - Danger Zone: Delete Account button (with typed "DELETE" confirmation)

**Providers consumed:**
- `notificationSettingsProvider` (read/write notification prefs)
- `privacySettingsProvider` (read/write privacy prefs)
- `accountSettingsNotifier` (for email change, password change, account deletion)

**User interactions:**
- Toggle any switch → saves immediately to shared_preferences
- Submit change email form → API call
- Submit change password form → API call
- Tap "Delete Account" → confirmation dialog (type "DELETE") → API call → logout

**Navigation actions:** → /login (on account deletion)

**Loading state:** None (settings loaded from local storage instantly)
**Empty state:** N/A
**Error state:** Snackbar for save errors
**Pull-to-refresh:** No

---

## 16. NotificationsScreen

**File:** `lib/features/notifications/screens/notifications_screen.dart`
**Route:** Accessed from notification bell icon in AppBar (push navigation, not in bottom nav)

**Purpose:** Full-screen notification list.

**Widgets composed:**
- AppBar with "Mark all read" action button
- NotificationTile list: title, message, relative time, read/unread indicator, delete action
- Unread notifications have accented background

**Providers consumed:**
- `notificationsProvider` (notification list)
- `notificationNotifier` (for markAsRead, markAllAsRead, delete)

**User interactions:**
- Tap notification → marks as read + navigates to actionUrl
- Swipe notification → deletes it
- Tap "Mark all read" → marks all as read

**Navigation actions:** → actionUrl target (profile, messages, sessions, etc.)

**Loading state:** `SkeletonCard` list
**Empty state:** `EmptyState` with "No notifications" message
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes

---

## 17. AdminDashboardScreen

**File:** `lib/features/admin/screens/admin_dashboard_screen.dart`
**Route:** `/admin` (authenticated + admin role)

**Purpose:** Admin overview with platform statistics and quick actions.

**Widgets composed:**
- AdminStatsGrid: 6 cards — Total Users (active), Sessions (completed), Connections, Reviews (avg rating), Posts (circles), Pending Reports
- Quick Actions: Manage Users, Content Moderation, Platform Settings
- Platform Health section: progress bars for engagement, completion rate, rating

**Providers consumed:**
- `adminStatsProvider` (platform statistics)

**User interactions:**
- Tap "Manage Users" → navigates to /admin/users
- Tap "Content Moderation" → navigates to /admin/moderation

**Navigation actions:** → /admin/users, → /admin/moderation

**Loading state:** `SkeletonCard` grid
**Empty state:** N/A
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes

---

## 18. UserManagementScreen

**File:** `lib/features/admin/screens/user_management_screen.dart`
**Route:** `/admin/users` (authenticated + admin role)

**Purpose:** Admin user management. Search, view, and take actions on users.

**Widgets composed:**
- SearchBarWidget for filtering users
- User list: cards with avatar, name, username, email, stats (connections, sessions, rating, location)
- Each card has admin action menu: Warn, Suspend, Ban, Delete

**Providers consumed:**
- `adminUsersProvider` (paginated user list with search)
- `adminNotifier` (for admin actions)

**User interactions:**
- Search users by name/email/username
- Tap action → opens UserActionSheet with reason textarea and duration (for suspend)
- Confirm action → executes admin action

**Navigation actions:** Opens UserActionSheet

**Loading state:** `SkeletonCard` list
**Empty state:** "No users found"
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes

**Bottom sheet flows:**
- UserActionSheet (admin action with reason)

---

## 19. ContentModerationScreen

**File:** `lib/features/admin/screens/content_moderation_screen.dart`
**Route:** `/admin/moderation` (authenticated + admin role)

**Purpose:** Review and resolve user reports.

**Widgets composed:**
- Stats row: Pending, Resolved, Dismissed counts
- TabBar: Pending, Reviewed, Dismissed
- ReportCard list per tab: report icon, reported user, reason badge (colour-coded), description, report ID, dates
- Report detail view with full information
- Action buttons: Resolve (with note), Dismiss (with note)

**Providers consumed:**
- `contentModerationProvider` (reports list with stats)
- `adminNotifier` (for resolve/dismiss actions)

**User interactions:**
- Tap report → shows detail view
- Tap "Resolve" → opens note input → resolves report
- Tap "Dismiss" → opens note input → dismisses report

**Navigation actions:** None (actions within screen)

**Loading state:** `SkeletonCard` list per tab
**Empty state:** Per tab: "No pending reports", "No reviewed reports", etc.
**Error state:** `ErrorMessage` with retry
**Pull-to-refresh:** Yes, per tab

---

## Screen Summary Table

| # | Screen | Route | Auth | Admin | Pull-to-refresh |
|---|--------|-------|------|-------|----------------|
| 1 | HomeScreen | `/` | No | No | No |
| 2 | LoginScreen | `/login` | No | No | No |
| 3 | SignupScreen | `/signup` | No | No | No |
| 4 | ForgotPasswordScreen | `/forgot-password` | No | No | No |
| 5 | VerifyEmailScreen | `/verify-email` | No | No | No |
| 6 | DashboardScreen | `/dashboard` | Yes | No | Yes |
| 7 | ProfileScreen | `/profile/:userId?` | Yes | No | Yes |
| 8 | MatchingScreen | `/matching` | Yes | No | Yes |
| 9 | ConnectionsScreen | `/connections` | Yes | No | Yes |
| 10 | SessionsScreen | `/bookings` | Yes | No | Yes |
| 11 | ConversationsScreen | `/messages` | Yes | No | Yes |
| 12 | ChatScreen | `/messages/:conversationId` | Yes | No | No |
| 13 | SearchScreen | `/search` | Yes | No | No |
| 14 | CommunityScreen | `/community` | Yes | No | Yes |
| 15 | SettingsScreen | `/settings` | Yes | No | No |
| 16 | NotificationsScreen | (push nav) | Yes | No | Yes |
| 17 | AdminDashboardScreen | `/admin` | Yes | Yes | Yes |
| 18 | UserManagementScreen | `/admin/users` | Yes | Yes | Yes |
| 19 | ContentModerationScreen | `/admin/moderation` | Yes | Yes | Yes |
