# Full Port: Flutter Skill Exchange — Design Spec

> Align the Flutter app with the React frontend and Node.js backend for full feature parity.

## Scope Overview

The Flutter app has solid architecture (268 files, clean layers) but runs entirely on mock data. This spec covers every gap between the current Flutter app and the production React+Node system.

---

## Sub-Project 1: Design Token Alignment

### Problem
Flutter uses blue (`#2563EB`) as primary — React uses emerald green (`#059669`). Multiple colors, radii, and semantic tokens are wrong or missing.

### Changes Required

**`app_colors.dart`** — Replace ALL color values:

| Token | Flutter Current | React Correct (Light) | React Correct (Dark) |
|-------|----------------|----------------------|---------------------|
| primary | `#2563EB` | `#059669` | `#10B981` |
| primaryForeground | `#F9FAFB` | `#FFFFFF` | `#FFFFFF` |
| secondary | `#8B5CF6` | `#8B5CF6` | `#8B5CF6` (same) |
| background | `#FAFAFA` | `#FAFAFA` (same) | `#0F0F0F` |
| foreground | `#09090B` | `#111827` | `#F9FAFB` |
| card | `#FFFFFF` | `#FFFFFF` (same) | `#1A1A1A` |
| cardForeground | `#09090B` | `#111827` | `#F9FAFB` |
| muted | `#F4F4F5` | `#F5F5F5` | `#141414` |
| mutedForeground | `#71717A` | `#6B7280` | `#9CA3AF` |
| accent | `#F4F4F5` | `#F3F4F6` | `#1F1F1F` |
| accentForeground | `#09090B` | `#111827` | `#F9FAFB` |
| border | `#E4E4E7` | `#E5E7EB` | `#2A2A2A` |
| input | `#E4E4E7` | transparent | `#1A1A1A` |
| ring | `#2563EB` | `#10B981` | `#34D399` |
| destructive | `#DC2626` | `#EF4444` | `#F87171` |
| darkBackground | `#09090B` | `#0F0F0F` | — |
| darkCard | `#18181B` | `#1A1A1A` | — |
| darkBorder | `#27272A` | `#2A2A2A` | — |
| darkPrimary | `#60A5FA` | `#10B981` | — |
| darkRing | `#60A5FA` | `#34D399` | — |

**New tokens to add** (in both `app_colors.dart` and `AppColorsExtension`):
- `primaryHover`: `#047857` / `#059669`
- `primarySubtle`: `#D1FAE5` / `#064E3B`
- `primaryMuted`: `#6EE7B7` / `#065F46`
- `secondaryHover`: `#7C3AED` / `#7C3AED`
- `secondarySubtle`: `#EDE9FE` / `#2E1065`
- `accentSubtle`: `#E5E7EB` / `#FEF3C7`
- `highlight`: `#F59E0B` / `#FBBF24`
- `highlightForeground`: `#FFFFFF` / `#0A0F0D`
- `highlightSubtle`: `#FEF3C7` / `#78350F`
- `surface`: `#F5F5F5` / `#141414`
- `surfaceForeground`: `#111827` / `#F9FAFB`
- `popover`: `#FFFFFF` / `#1A1A1A`
- `popoverForeground`: `#111827` / `#F9FAFB`

**`app_radius.dart`** — Fix values to match React:
- `sm`: 8 (was 6)
- `2xl`: 32 (new)
- `button`: 12 (was 8, matches base radius)
- `input`: 12 (was 8)

**`app_shadows.dart`** — Add matching shadow definitions:
- `cardShadow` (light): `0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.04)`
- `cardShadow` (dark): `0 1px 3px rgba(0,0,0,0.4), 0 1px 2px rgba(0,0,0,0.3)`
- `glowShadow` (light): `0 4px 20px rgba(0,0,0,0.12)`
- `glowShadow` (dark): `0 4px 20px rgba(0,0,0,0.5)`

**`app_text_styles.dart`** — Verify font family is Urbanist. Add to pubspec.yaml fonts or use google_fonts package.

**Gradients** — Add `AppGradients` class:
- `primary`: `LinearGradient(135deg, #059669 → #047857)`
- `secondary`: `LinearGradient(135deg, #8B5CF6 → #7C3AED)`
- `hero`: `LinearGradient(135deg, #0A0F0D → #0D2818 → #1A0A2E)`
- `card`: `LinearGradient(135deg, #1E293B → #0F172A)`
- `surface` (light): `LinearGradient(180deg, #F5F5F5 → #FAFAFA)`
- `surface` (dark): `LinearGradient(180deg, #141414 → #0F0F0F)`
- `text`: `LinearGradient(135deg, #10B981 → #8B5CF6)` (for gradient text shader)

---

## Sub-Project 2: API Endpoint Alignment

### Problem
Flutter endpoints don't match the actual backend routes. Several endpoints use wrong paths/methods.

### Endpoint Mismatches (Flutter → Backend Correct)

| Feature | Flutter Endpoint | Backend Actual | Issue |
|---------|-----------------|----------------|-------|
| Auth signup | `/auth/signup` | `/auth/register` | Wrong path |
| Auth current user | `/auth/me` | `/users/me` | Wrong route group |
| Connections accept | `PUT /connections/:id/respond` | `POST /connections/:id/accept` | Wrong method + path |
| Connections reject | (combined in respond) | `POST /connections/:id/reject` | Missing separate endpoint |
| Sessions list | `GET /sessions/upcoming` | `GET /sessions` (returns `{upcoming, past}`) | Missing past sessions |
| Sessions create | `POST /sessions` | `POST /sessions/book` | Wrong path |
| Sessions cancel | `PUT /sessions/:id/cancel` | `POST /sessions/:id/cancel` | Wrong method |
| Sessions complete | `PUT /sessions/:id/complete` | `POST /sessions/:id/complete` | Wrong method |
| Messages threads | `GET /messages/conversations` | `GET /messages/threads` | Wrong path |
| Messages by thread | `GET /messages/conversations/:id` | `GET /messages/threads/:threadId` | Wrong path |
| Messages send | `POST /messages` | `POST /messages/send` | Wrong path |
| Messages mark read | `PUT /messages/:id/read` | `POST /messages/threads/:threadId/read` | Wrong method + path |
| Messages unread count | (missing) | `GET /messages/unread-count` | Missing endpoint |

### Missing Endpoints in Flutter

**Auth:**
- `PATCH /auth/change-email` — change email (needs password + newEmail)

**Profile:**
- `POST /profiles/me/cover` — upload cover image
- `DELETE /profiles/me/cover` — remove cover image
- `GET /profiles/me/preferences` — get privacy/notification preferences
- `PATCH /profiles/me/preferences` — update preferences
- `GET /profiles/by-username/:username` — lookup by username
- `GET /profiles/:id/posts` — get user's community posts

**Sessions:**
- `POST /sessions/request` — request a session (vs booking)
- `GET /sessions/available-slots/:userId` — get available time slots
- `GET /sessions/:id` — get single session detail

**Community:**
- `POST /community/posts/upload-media` — upload images for post
- `POST /community/posts/upload-video` — upload video for post
- `PUT /community/posts/:postId` — update post
- `GET /community/posts/:postId/liked` — check if user liked post
- `GET /community/posts/:postId/replies` — get post replies
- `POST /community/posts/:postId/replies` — create reply
- `GET /community/circles/:circleId/membership` — check membership
- `GET /community/circles/:circleId/posts` — get circle posts
- `POST /community/circles/:circleId/posts` — create circle post
- `PUT /community/circles/:circleId` — update circle (admin)
- `DELETE /community/circles/:circleId` — delete circle (admin)

**Reviews:**
- `GET /reviews/by/:userId` — reviews written BY a user (vs FOR a user)

**Admin (many missing):**
- `GET /admin/users` — list users
- `GET /admin/users/:id` — user detail
- `PATCH /admin/users/:id/role` — change role
- `PATCH /admin/users/:id/ban` — ban user
- `PATCH /admin/users/:id/unban` — unban user
- `DELETE /admin/users/:id` — delete user
- `PATCH /admin/users/:userId/verify-skill/:skillIndex` — verify skill
- `GET /admin/circles` — list circles
- `GET /admin/circles/:id` — circle detail
- `POST /admin/circles` — create circle
- `PUT /admin/circles/:id` — update circle
- `DELETE /admin/circles/:id` — delete circle
- `GET /admin/posts` — list posts
- `DELETE /admin/posts/:id` — delete post
- `PATCH /admin/posts/:id/moderate` — moderate post (hide/remove)
- `GET /admin/sessions` — list sessions
- `PATCH /admin/sessions/:id/cancel` — admin cancel session
- `GET /admin/connections` — list connections
- `DELETE /admin/connections/:id` — delete connection
- `GET /admin/reviews` — list reviews
- `DELETE /admin/reviews/:reviewId` — delete review
- `PATCH /admin/reviews/:reviewId/status` — update review status
- `GET /admin/reports` — list reports
- `GET /admin/reports/:id` — report detail
- `PATCH /admin/reports/:id` — update report

**Reports:**
- `POST /reports` — submit user report

**Public (no auth):**
- `GET /public/stats` — platform stats (users, sessions, reviews count)
- `GET /public/testimonials` — featured testimonials

**User:**
- `PATCH /users/me` — update user (name)
- `DELETE /users/me` — delete account

---

## Sub-Project 3: Data Model Alignment

### Models needing updates to match backend response shapes

**UserModel** — Verify fields match `User.model.js`:
- `name`, `email`, `role` (user/admin), `isVerified`, `isActive`, `lastLogin`

**UserProfileModel** — Must match backend's `normalizeProfile` output:
- Add `userId` field (separate from profile `id`)
- Add `coverImage` field
- Verify `availability` is day-based booleans
- Verify `stats` shape: `connectionsCount`, `sessionsCompleted`, `reviewsReceived`, `averageRating`
- Add `privacyPreferences` and `notificationPreferences`

**ConnectionModel** — Backend returns different shapes for list vs pending:
- Connected: `{id, user: ProfileShape, status, connectedAt}`
- Pending: `{id, user: ProfileShape, message, requestedAt}`

**SessionModel** — Must match backend:
- `host`, `participant` (user refs), `title`, `description`, `skillsToCover`
- `scheduledAt`, `duration`, `status` (scheduled/completed/cancelled)
- `sessionMode` (online/offline), `meetingPlatform`, `meetingLink`, `location`
- `notes`, `isRequest`

**MessageModel** — Must match backend:
- `sender`, `receiver`, `content`, `isRead`, `createdAt`

**ConversationModel (thread)** — Backend returns threads with:
- `participant` (profile shape), `lastMessage`, `unreadCount`, `updatedAt`

**PostModel** — Must match `Post.model.js`:
- `author`, `title`, `content`, `category`, `circle`, `tags`
- `images[]` ({url, publicId}), `videoUrl`, `mediaType` (text/image/video)
- `likesCount`, `repliesCount`, `moderationStatus`, `moderationReason`

**CircleModel** — Must match `Circle.model.js`:
- `name`, `description`, `category`, `members[]`, `maxMembers`, `createdBy`, `imageUrl`

**ReviewModel** — Must match `Review.model.js`:
- `fromUser`, `toUser`, `session`, `rating`, `comment`, `skillsReviewed[]`
- `status` (pending/approved/rejected), `isFeatured`

**NotificationModel** — Must match backend:
- `user`, `type` (enum of 7 types), `title`, `message`, `isRead`, `actionUrl`, `metadata`

**ReportModel** — New model needed:
- `reporter`, `reportedUser`, `reason` (enum), `description`
- `status` (pending/reviewed/resolved/dismissed), `resolutionNote`, `reviewedBy`, `reviewedAt`

---

## Sub-Project 4: Repository & Provider Wiring

### Problem
All feature providers exist but are wired to `MockInterceptor`. The DI container (`providers.dart`) only registers `authRemoteSource` and `authRepository`. All other features need real DI wiring.

### Changes Required

**`providers.dart`** — Register all remote sources and repositories:
- `profileRemoteSourceProvider` + `profileRepositoryProvider`
- `connectionRemoteSourceProvider` + `connectionRepositoryProvider`
- `sessionRemoteSourceProvider` + `sessionRepositoryProvider`
- `messagingRemoteSourceProvider` + `messagingRepositoryProvider`
- `reviewRemoteSourceProvider` + `reviewRepositoryProvider`
- `notificationRemoteSourceProvider` + `notificationRepositoryProvider`
- `matchingRemoteSourceProvider` + `matchingRepositoryProvider`
- `searchRemoteSourceProvider` + `searchRepositoryProvider`
- `communityRemoteSourceProvider` + `communityRepositoryProvider`
- `adminRemoteSourceProvider` + `adminRepositoryProvider`
- `reportRemoteSourceProvider`

### Repository implementations to verify
Each `*_repository_impl.dart` must:
1. Call the correct remote source methods
2. Map responses through Freezed models
3. Return `Either<Failure, T>` via fpdart
4. Handle all error cases

---

## Sub-Project 5: Real-Time Messaging (Socket.IO)

### Problem
Flutter uses `web_socket_channel` but the backend uses Socket.IO. These are incompatible protocols.

### Solution
Add `socket_io_client` package. Create a `SocketService` that:

1. Connects on auth with `withCredentials: true` + auth token
2. Handles events:
   - **Messaging**: `send_message`, `new_message`, `mark_read`, `messages_read`, `typing`
   - **Video Call**: `call_user`, `incoming_call`, `answer_call`, `call_answered`, `webrtc_offer`, `webrtc_answer`, `ice_candidate`, `webrtc_ready`, `end_call`
3. Integrates with messaging provider for real-time updates
4. Auto-reconnects with backoff

### Package change
- Remove: `web_socket_channel`
- Add: `socket_io_client: ^3.0.2`

---

## Sub-Project 6: Feature Screen Parity

### Screens needing implementation/update

**Auth:**
- `ResetPasswordScreen` — exists in React, missing in Flutter router (token + new password form)
- `BannedScreen` — show banned message, missing in Flutter

**Profile:**
- Cover image upload/remove
- User posts tab on profile view
- Block/report user dialogs
- Username-based profile lookup

**Sessions:**
- Session request flow (not just booking)
- Available slots picker
- Session detail view
- Video call room (WebRTC) — complex, may defer
- Reschedule dialog with reason

**Community:**
- Media upload (images/video) for posts
- Post editing and deleting
- Post replies/comments thread
- Circle posts (posts within a circle)
- Circle membership check
- Like/unlike toggle with optimistic update

**Settings:**
- Appearance settings (theme toggle — already partially done)
- Privacy settings (profile visibility, show email, show location, allow messages)
- Notification preferences (email, push, per-type toggles)
- Account: change email, delete account

**Admin:**
- User management: list, ban/unban, role change, skill verification, delete
- Content moderation: reports list, review reports, moderate posts
- Session management: list sessions, admin cancel
- Review management: list, delete, change status
- Connection management: list, delete
- Post management: list, moderate (hide/remove/activate)
- Community management: circles CRUD

---

## Sub-Project 7: Missing Utilities & Infrastructure

1. **Urbanist font** — add to pubspec.yaml or use google_fonts
2. **Gradient text widget** — shader mask for gradient text effect
3. **Image/video upload service** — FormData multipart for Cloudinary
4. **Auth cookie handling** — backend uses httpOnly cookies; Flutter mobile needs to handle tokens via Authorization header (Bearer) since cookies don't work the same in mobile. Verify `auth_interceptor.dart` uses secure storage tokens.
5. **Token refresh flow** — Verify 401 → refresh → retry logic in `auth_interceptor.dart`
6. **`enableMockData` default** — Change from `true` to `false` for production

---

## Implementation Order (Recommended)

This is a large project. Recommended decomposition into 7 sequential sub-projects:

1. **Design Tokens** (~1 session) — Fix all colors, radii, shadows, gradients, font
2. **API Endpoints + Models** (~2 sessions) — Fix all endpoint paths, update/create models
3. **DI + Repository Wiring** (~1 session) — Wire all providers, remote sources, repositories
4. **Core Features** (~3 sessions) — Auth, Profile, Connections, Sessions, Reviews, Search, Matching, Notifications
5. **Community + Messaging** (~2 sessions) — Posts, circles, real-time messaging with Socket.IO
6. **Admin Panel** (~2 sessions) — All admin screens with real API calls
7. **Polish** (~1 session) — Reset password, banned page, video call scaffolding, settings parity

Each sub-project should be its own implementation plan → execution cycle.

---

## Out of Scope (Defer)

- WebRTC video calling (requires flutter_webrtc, TURN/STUN servers, significant mobile-specific work)
- Google OAuth (requires Firebase or platform-specific setup)
- Push notifications (requires Firebase Cloud Messaging setup)
- Unit/integration tests (separate effort)
