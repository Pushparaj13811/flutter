# Skill Exchange — API Reference

> Complete API reference for the Flutter app.
> Organised by feature. Every endpoint documents its Dart request/response models,
> Dio client method, repository method, and triggering provider.

---

## Base Configuration

| Setting | Value |
|---------|-------|
| Base URL (dev) | `http://localhost:3000/api` |
| Base URL (prod) | Configured via `--dart-define=API_BASE_URL=<url>` |
| Content-Type | `application/json` |
| Auth header | `Authorization: Bearer <access_token>` |
| Timeout | 30 seconds (connect, receive, send) |

---

## Standard Response Wrappers

**Success:**
```dart
ApiResponseModel<T> {
  T data;
  String? message;
  bool success;  // always true
}
```

**Paginated:**
```dart
PaginatedResponseModel<T> {
  List<T> data;
  PaginationModel pagination;  // page, pageSize, totalItems, totalPages, hasNextPage, hasPreviousPage
}
```

**Error:**
```json
{
  "message": "Error description",
  "code": "ERROR_CODE",
  "statusCode": 400,
  "details": { "field": ["error message"] }
}
```

---

## 1. Authentication

### POST /auth/login

**Purpose:** Authenticate user with email and password.

| Item | Value |
|------|-------|
| Request body | `LoginDto { email, password }` |
| Response | `ApiResponseModel<AuthTokensModel>` containing `{ accessToken, refreshToken, user }` |
| Dio method | `_dio.post('/auth/login', data: dto.toJson())` |
| Remote source | `AuthRemoteSource.login(LoginDto dto)` |
| Repository | `AuthRepository.login(String email, String password) → Future<Either<Failure, AuthTokensModel>>` |
| Provider | `AuthNotifier.login(email, password)` |
| Used by | LoginScreen |

---

### POST /auth/signup

**Purpose:** Register a new user.

| Item | Value |
|------|-------|
| Request body | `SignupDto { name, email, password }` |
| Response | `ApiResponseModel<AuthTokensModel>` |
| Dio method | `_dio.post('/auth/signup', data: dto.toJson())` |
| Remote source | `AuthRemoteSource.signup(SignupDto dto)` |
| Repository | `AuthRepository.signup(String name, String email, String password) → Future<Either<Failure, AuthTokensModel>>` |
| Provider | `AuthNotifier.signup(name, email, password)` |
| Used by | SignupScreen |

---

### POST /auth/logout

**Purpose:** Invalidate the current session server-side.

| Item | Value |
|------|-------|
| Request body | None |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/auth/logout')` |
| Remote source | `AuthRemoteSource.logout()` |
| Repository | `AuthRepository.logout() → Future<Either<Failure, void>>` |
| Provider | `AuthNotifier.logout()` |
| Used by | Header user menu, SettingsScreen |

---

### POST /auth/refresh

**Purpose:** Refresh an expired access token using the refresh token.

| Item | Value |
|------|-------|
| Request body | `{ "refreshToken": "<token>" }` |
| Response | `ApiResponseModel<{ accessToken: string }>` |
| Dio method | `_dio.post('/auth/refresh', data: { 'refreshToken': token })` |
| Remote source | `AuthRemoteSource.refreshToken(String refreshToken)` |
| Repository | Called by `AuthInterceptor` on 401 |
| Provider | N/A (handled by interceptor) |
| Used by | AuthInterceptor |

---

### GET /auth/me

**Purpose:** Get the currently authenticated user's basic info.

| Item | Value |
|------|-------|
| Query params | None |
| Response | `ApiResponseModel<UserModel>` |
| Dio method | `_dio.get('/auth/me')` |
| Remote source | `AuthRemoteSource.getCurrentUser()` |
| Repository | `AuthRepository.getCurrentUser() → Future<Either<Failure, UserModel>>` |
| Provider | `AuthNotifier` (on app startup) |
| Used by | App startup flow |

---

### POST /auth/forgot-password

**Purpose:** Send a password reset email.

| Item | Value |
|------|-------|
| Request body | `{ "email": "<email>" }` |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/auth/forgot-password', data: { 'email': email })` |
| Remote source | `AuthRemoteSource.forgotPassword(String email)` |
| Repository | `AuthRepository.forgotPassword(String email) → Future<Either<Failure, void>>` |
| Provider | `AuthNotifier.forgotPassword(email)` |
| Used by | ForgotPasswordScreen |

---

### POST /auth/reset-password

**Purpose:** Reset password using token from email link.

| Item | Value |
|------|-------|
| Request body | `{ "token": "<token>", "newPassword": "<password>" }` |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/auth/reset-password', data: { 'token': token, 'newPassword': password })` |
| Remote source | `AuthRemoteSource.resetPassword(String token, String newPassword)` |
| Repository | `AuthRepository.resetPassword(String token, String newPassword) → Future<Either<Failure, void>>` |
| Provider | `AuthNotifier.resetPassword(token, newPassword)` |
| Used by | Deep link from email |

---

### POST /auth/verify-email

**Purpose:** Verify email address using token.

| Item | Value |
|------|-------|
| Request body | `{ "token": "<token>" }` |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/auth/verify-email', data: { 'token': token })` |
| Remote source | `AuthRemoteSource.verifyEmail(String token)` |
| Repository | `AuthRepository.verifyEmail(String token) → Future<Either<Failure, void>>` |
| Provider | `AuthNotifier.verifyEmail(token)` |
| Used by | VerifyEmailScreen |

---

### POST /auth/change-password

**Purpose:** Change password for authenticated user.

| Item | Value |
|------|-------|
| Request body | `ChangePasswordDto { currentPassword, newPassword }` |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/auth/change-password', data: dto.toJson())` |
| Remote source | `AuthRemoteSource.changePassword(ChangePasswordDto dto)` |
| Repository | `AuthRepository.changePassword(String current, String newPw) → Future<Either<Failure, void>>` |
| Provider | `AccountSettingsNotifier.changePassword(current, newPw)` |
| Used by | SettingsScreen (Account tab) |

---

### GET /auth/google

**Purpose:** Initiate Google OAuth flow.

| Item | Value |
|------|-------|
| Flow | Opens in-app browser to this URL. Server redirects to Google. After auth, server redirects back with tokens. |
| Response | Redirect with query params: `?accessToken=<token>&refreshToken=<token>` |
| Used by | GoogleOAuthButton widget |

---

## 2. Profiles

### GET /profiles/me

**Purpose:** Get the current user's full profile.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<UserProfileModel>` |
| Dio method | `_dio.get('/profiles/me')` |
| Remote source | `ProfileRemoteSource.getCurrentProfile()` |
| Repository | `ProfileRepository.getCurrentProfile() → Future<Either<Failure, UserProfileModel>>` |
| Provider | `currentProfileProvider` |
| Used by | ProfileScreen (own), DashboardScreen |

---

### GET /profiles/:id

**Purpose:** Get a specific user's profile.

| Item | Value |
|------|-------|
| Path params | `id` — user ID |
| Response | `ApiResponseModel<UserProfileModel>` |
| Dio method | `_dio.get('/profiles/$id')` |
| Remote source | `ProfileRemoteSource.getProfile(String id)` |
| Repository | `ProfileRepository.getProfile(String id) → Future<Either<Failure, UserProfileModel>>` |
| Provider | `profileProvider(userId)` |
| Used by | ProfileScreen (other user) |

---

### PUT /profiles/me

**Purpose:** Update the current user's profile.

| Item | Value |
|------|-------|
| Request body | `UpdateProfileDto` (all fields optional) |
| Response | `ApiResponseModel<UserProfileModel>` |
| Dio method | `_dio.put('/profiles/me', data: dto.toJson())` |
| Remote source | `ProfileRemoteSource.updateProfile(UpdateProfileDto dto)` |
| Repository | `ProfileRepository.updateProfile(UpdateProfileDto dto) → Future<Either<Failure, UserProfileModel>>` |
| Provider | `ProfileNotifier.updateProfile(dto)` |
| Used by | ProfileScreen (edit mode) |

---

### GET /profiles

**Purpose:** List all user profiles (admin use).

| Item | Value |
|------|-------|
| Query params | `page`, `pageSize`, `search` |
| Response | `PaginatedResponseModel<UserProfileModel>` |
| Dio method | `_dio.get('/profiles', queryParameters: params)` |
| Remote source | `ProfileRemoteSource.getAllProfiles({int page, String? search})` |
| Repository | `ProfileRepository.getAllProfiles(...) → Future<Either<Failure, PaginatedResponseModel<UserProfileModel>>>` |
| Provider | `adminUsersProvider` |
| Used by | UserManagementScreen |

---

## 3. Skills

### GET /skills

**Purpose:** Get all available skills.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<SkillModel>>` |
| Dio method | `_dio.get('/skills')` |
| Remote source | `ProfileRemoteSource.getAllSkills()` |
| Repository | `ProfileRepository.getAllSkills() → Future<Either<Failure, List<SkillModel>>>` |
| Provider | `allSkillsProvider` |
| Used by | ProfileScreen (edit mode), SkillsSection widget |

---

### GET /skills/categories

**Purpose:** Get all skill categories.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<String>>` |
| Dio method | `_dio.get('/skills/categories')` |
| Remote source | `ProfileRemoteSource.getSkillCategories()` |
| Repository | `ProfileRepository.getSkillCategories() → Future<Either<Failure, List<String>>>` |
| Provider | `skillCategoriesProvider` |
| Used by | MatchingFilters, SkillsSection |

---

## 4. Matching

### GET /matching

**Purpose:** Get skill matches for the current user with filtering and pagination.

| Item | Value |
|------|-------|
| Query params | `skillCategory`, `skillName`, `location`, `minRating`, `maxRating`, `availability[]`, `learningStyle`, `sortBy`, `page`, `pageSize` |
| Response | `PaginatedResponseModel<MatchScoreModel>` |
| Dio method | `_dio.get('/matching', queryParameters: params)` |
| Remote source | `MatchingRemoteSource.getMatches({MatchingFiltersModel? filters, String? sortBy, int page})` |
| Repository | `MatchingRepository.getMatches(...) → Future<Either<Failure, PaginatedResponseModel<MatchScoreModel>>>` |
| Provider | `paginatedMatchesProvider(filters)` |
| Used by | MatchingScreen |

---

### GET /matching/suggestions

**Purpose:** Get top N match suggestions (for dashboard).

| Item | Value |
|------|-------|
| Query params | `limit` |
| Response | `ApiResponseModel<List<MatchScoreModel>>` |
| Dio method | `_dio.get('/matching/suggestions', queryParameters: { 'limit': limit })` |
| Remote source | `MatchingRemoteSource.getTopMatches(int limit)` |
| Repository | `MatchingRepository.getTopMatches(int limit) → Future<Either<Failure, List<MatchScoreModel>>>` |
| Provider | `topMatchesProvider(limit)` |
| Used by | DashboardScreen |

---

## 5. Connections

### GET /connections

**Purpose:** List accepted connections.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<ConnectionModel>>` |
| Dio method | `_dio.get('/connections')` |
| Remote source | `ConnectionRemoteSource.getConnections()` |
| Repository | `ConnectionRepository.getConnections() → Future<Either<Failure, List<ConnectionModel>>>` |
| Provider | `connectionsProvider` |
| Used by | ConnectionsScreen (Connections tab) |

---

### POST /connections/request

**Purpose:** Send a connection request.

| Item | Value |
|------|-------|
| Request body | `{ "toUserId": "<id>", "message": "<optional message>" }` |
| Response | `ApiResponseModel<ConnectionModel>` |
| Dio method | `_dio.post('/connections/request', data: body)` |
| Remote source | `ConnectionRemoteSource.sendRequest(String toUserId, String? message)` |
| Repository | `ConnectionRepository.sendRequest(String userId, String? message) → Future<Either<Failure, ConnectionModel>>` |
| Provider | `ConnectionsNotifier.sendRequest(userId, message)` |
| Used by | ConnectionRequestSheet, MatchCard |

---

### GET /connections/pending

**Purpose:** List incoming pending connection requests.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<ConnectionModel>>` |
| Dio method | `_dio.get('/connections/pending')` |
| Remote source | `ConnectionRemoteSource.getPendingRequests()` |
| Repository | `ConnectionRepository.getPendingRequests() → Future<Either<Failure, List<ConnectionModel>>>` |
| Provider | `pendingRequestsProvider` |
| Used by | ConnectionsScreen (Requests tab) |

---

### GET /connections/sent

**Purpose:** List outgoing sent connection requests.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<ConnectionModel>>` |
| Dio method | `_dio.get('/connections/sent')` |
| Remote source | `ConnectionRemoteSource.getSentRequests()` |
| Repository | `ConnectionRepository.getSentRequests() → Future<Either<Failure, List<ConnectionModel>>>` |
| Provider | `sentRequestsProvider` |
| Used by | ConnectionsScreen (Sent tab) |

---

### PUT /connections/:id/respond

**Purpose:** Accept or reject a connection request.

| Item | Value |
|------|-------|
| Path params | `id` — connection ID |
| Request body | `{ "accept": true/false }` |
| Response | `ApiResponseModel<ConnectionModel>` |
| Dio method | `_dio.put('/connections/$id/respond', data: { 'accept': accept })` |
| Remote source | `ConnectionRemoteSource.respondToRequest(String id, bool accept)` |
| Repository | `ConnectionRepository.respondToRequest(String id, bool accept) → Future<Either<Failure, ConnectionModel>>` |
| Provider | `ConnectionsNotifier.respondToRequest(id, accept)` |
| Used by | PendingRequests widget |

---

### DELETE /connections/:id

**Purpose:** Remove an accepted connection.

| Item | Value |
|------|-------|
| Path params | `id` — connection ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.delete('/connections/$id')` |
| Remote source | `ConnectionRemoteSource.removeConnection(String id)` |
| Repository | `ConnectionRepository.removeConnection(String id) → Future<Either<Failure, void>>` |
| Provider | `ConnectionsNotifier.removeConnection(id)` |
| Used by | ConnectionList widget |

---

### GET /connections/:userId/status

**Purpose:** Check connection status with a specific user.

| Item | Value |
|------|-------|
| Path params | `userId` |
| Response | `ApiResponseModel<{ status: string }>` — 'none', 'pending', 'accepted' |
| Dio method | `_dio.get('/connections/$userId/status')` |
| Remote source | `ConnectionRemoteSource.getConnectionStatus(String userId)` |
| Repository | `ConnectionRepository.getConnectionStatus(String userId) → Future<Either<Failure, String>>` |
| Provider | `connectionStatusProvider(userId)` |
| Used by | ProfileScreen (other user), MatchCard |

---

## 6. Sessions

### GET /sessions/upcoming

**Purpose:** List upcoming (scheduled) sessions.

| Item | Value |
|------|-------|
| Query params | `limit` (optional) |
| Response | `ApiResponseModel<List<SessionModel>>` |
| Dio method | `_dio.get('/sessions/upcoming', queryParameters: params)` |
| Remote source | `SessionRemoteSource.getUpcomingSessions({int? limit})` |
| Repository | `SessionRepository.getUpcomingSessions({int? limit}) → Future<Either<Failure, List<SessionModel>>>` |
| Provider | `upcomingSessionsProvider` |
| Used by | SessionsScreen, DashboardScreen |

---

### POST /sessions

**Purpose:** Book a new session.

| Item | Value |
|------|-------|
| Request body | `CreateSessionDto` |
| Response | `ApiResponseModel<SessionModel>` |
| Dio method | `_dio.post('/sessions', data: dto.toJson())` |
| Remote source | `SessionRemoteSource.createSession(CreateSessionDto dto)` |
| Repository | `SessionRepository.createSession(CreateSessionDto dto) → Future<Either<Failure, SessionModel>>` |
| Provider | `SessionsNotifier.createSession(dto)` |
| Used by | SessionBookingSheet |

---

### PUT /sessions/:id/cancel

**Purpose:** Cancel a scheduled session.

| Item | Value |
|------|-------|
| Path params | `id` — session ID |
| Request body | `{ "reason": "<optional>" }` |
| Response | `ApiResponseModel<SessionModel>` |
| Dio method | `_dio.put('/sessions/$id/cancel', data: body)` |
| Remote source | `SessionRemoteSource.cancelSession(String id, {String? reason})` |
| Repository | `SessionRepository.cancelSession(String id, {String? reason}) → Future<Either<Failure, SessionModel>>` |
| Provider | `SessionsNotifier.cancelSession(id)` |
| Used by | SessionCard |

---

### PUT /sessions/:id/complete

**Purpose:** Mark a session as completed.

| Item | Value |
|------|-------|
| Path params | `id` — session ID |
| Response | `ApiResponseModel<SessionModel>` |
| Dio method | `_dio.put('/sessions/$id/complete')` |
| Remote source | `SessionRemoteSource.completeSession(String id)` |
| Repository | `SessionRepository.completeSession(String id) → Future<Either<Failure, SessionModel>>` |
| Provider | `SessionsNotifier.completeSession(id)` |
| Used by | SessionCard (triggers ReviewSheet after) |

---

### PUT /sessions/:id/reschedule

**Purpose:** Reschedule a session.

| Item | Value |
|------|-------|
| Path params | `id` — session ID |
| Request body | `RescheduleSessionDto { newScheduledAt, newDuration, reason? }` |
| Response | `ApiResponseModel<SessionModel>` |
| Dio method | `_dio.put('/sessions/$id/reschedule', data: dto.toJson())` |
| Remote source | `SessionRemoteSource.rescheduleSession(String id, RescheduleSessionDto dto)` |
| Repository | `SessionRepository.rescheduleSession(String id, RescheduleSessionDto dto) → Future<Either<Failure, SessionModel>>` |
| Provider | `SessionsNotifier.rescheduleSession(id, dto)` |
| Used by | RescheduleSessionSheet |

---

## 7. Messages

### GET /messages/conversations

**Purpose:** List all conversations for the current user.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<ConversationModel>>` |
| Dio method | `_dio.get('/messages/conversations')` |
| Remote source | `MessagingRemoteSource.getConversations()` |
| Repository | `MessagingRepository.getConversations() → Future<Either<Failure, List<ConversationModel>>>` |
| Provider | `conversationsProvider` |
| Used by | ConversationsScreen |

---

### GET /messages/conversations/:id

**Purpose:** Get messages for a specific conversation.

| Item | Value |
|------|-------|
| Path params | `id` — conversation ID |
| Query params | `page`, `pageSize` (optional) |
| Response | `ApiResponseModel<List<MessageModel>>` |
| Dio method | `_dio.get('/messages/conversations/$id', queryParameters: params)` |
| Remote source | `MessagingRemoteSource.getMessages(String conversationId, {int? page})` |
| Repository | `MessagingRepository.getMessages(String conversationId, {int? page}) → Future<Either<Failure, List<MessageModel>>>` |
| Provider | `messagesProvider(conversationId)` |
| Used by | ChatScreen |

---

### POST /messages

**Purpose:** Send a new message.

| Item | Value |
|------|-------|
| Request body | `{ "conversationId": "<id>", "content": "<text>" }` |
| Response | `ApiResponseModel<MessageModel>` |
| Dio method | `_dio.post('/messages', data: body)` |
| Remote source | `MessagingRemoteSource.sendMessage(String conversationId, String content)` |
| Repository | `MessagingRepository.sendMessage(String conversationId, String content) → Future<Either<Failure, MessageModel>>` |
| Provider | `MessagingNotifier.sendMessage(conversationId, content)` (with optimistic update) |
| Used by | ChatScreen (MessageInput) |

---

### PUT /messages/:id/read

**Purpose:** Mark a message as read.

| Item | Value |
|------|-------|
| Path params | `id` — message/conversation ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.put('/messages/$id/read')` |
| Remote source | `MessagingRemoteSource.markAsRead(String id)` |
| Repository | `MessagingRepository.markAsRead(String id) → Future<Either<Failure, void>>` |
| Provider | `MessagingNotifier.markAsRead(id)` |
| Used by | ChatScreen (on open) |

---

## 8. Reviews

### GET /reviews/user/:userId

**Purpose:** Get all reviews for a user.

| Item | Value |
|------|-------|
| Path params | `userId` |
| Response | `ApiResponseModel<List<ReviewModel>>` |
| Dio method | `_dio.get('/reviews/user/$userId')` |
| Remote source | `ReviewRemoteSource.getReviews(String userId)` |
| Repository | `ReviewRepository.getReviews(String userId) → Future<Either<Failure, List<ReviewModel>>>` |
| Provider | `reviewsProvider(userId)` |
| Used by | ProfileScreen (reviews section) |

---

### GET /reviews/user/:userId/stats

**Purpose:** Get review statistics for a user.

| Item | Value |
|------|-------|
| Path params | `userId` |
| Response | `ApiResponseModel<ReviewStatsModel>` |
| Dio method | `_dio.get('/reviews/user/$userId/stats')` |
| Remote source | `ReviewRemoteSource.getReviewStats(String userId)` |
| Repository | `ReviewRepository.getReviewStats(String userId) → Future<Either<Failure, ReviewStatsModel>>` |
| Provider | `reviewStatsProvider(userId)` |
| Used by | ProfileScreen (rating display) |

---

### POST /reviews

**Purpose:** Create a new review.

| Item | Value |
|------|-------|
| Request body | `CreateReviewDto { toUserId, rating, comment, skillsReviewed, sessionId? }` |
| Response | `ApiResponseModel<ReviewModel>` |
| Dio method | `_dio.post('/reviews', data: dto.toJson())` |
| Remote source | `ReviewRemoteSource.createReview(CreateReviewDto dto)` |
| Repository | `ReviewRepository.createReview(CreateReviewDto dto) → Future<Either<Failure, ReviewModel>>` |
| Provider | `ReviewNotifier.createReview(dto)` |
| Used by | ReviewSheet |

---

## 9. Notifications

### GET /notifications

**Purpose:** List all notifications for the current user.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<NotificationModel>>` |
| Dio method | `_dio.get('/notifications')` |
| Remote source | `NotificationRemoteSource.getNotifications()` |
| Repository | `NotificationRepository.getNotifications() → Future<Either<Failure, List<NotificationModel>>>` |
| Provider | `notificationsProvider` |
| Used by | NotificationsScreen |

---

### GET /notifications/unread-count

**Purpose:** Get unread notification count (for badge).

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<{ count: int }>` |
| Dio method | `_dio.get('/notifications/unread-count')` |
| Remote source | `NotificationRemoteSource.getUnreadCount()` |
| Repository | `NotificationRepository.getUnreadCount() → Future<Either<Failure, int>>` |
| Provider | `unreadNotificationCountProvider` |
| Used by | NotificationBadge widget (AppBar) |

---

### PUT /notifications/:id/read

**Purpose:** Mark a single notification as read.

| Item | Value |
|------|-------|
| Path params | `id` — notification ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.put('/notifications/$id/read')` |
| Remote source | `NotificationRemoteSource.markAsRead(String id)` |
| Repository | `NotificationRepository.markAsRead(String id) → Future<Either<Failure, void>>` |
| Provider | `NotificationNotifier.markAsRead(id)` |
| Used by | NotificationsScreen (on tap) |

---

### PUT /notifications/read-all

**Purpose:** Mark all notifications as read.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.put('/notifications/read-all')` |
| Remote source | `NotificationRemoteSource.markAllAsRead()` |
| Repository | `NotificationRepository.markAllAsRead() → Future<Either<Failure, void>>` |
| Provider | `NotificationNotifier.markAllAsRead()` |
| Used by | NotificationsScreen ("Mark all read" button) |

---

### DELETE /notifications/:id

**Purpose:** Delete a notification.

| Item | Value |
|------|-------|
| Path params | `id` — notification ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.delete('/notifications/$id')` |
| Remote source | `NotificationRemoteSource.deleteNotification(String id)` |
| Repository | `NotificationRepository.deleteNotification(String id) → Future<Either<Failure, void>>` |
| Provider | `NotificationNotifier.deleteNotification(id)` |
| Used by | NotificationsScreen (swipe to delete) |

---

## 10. Search

### GET /search/users

**Purpose:** Search users by query, skills, and filters.

| Item | Value |
|------|-------|
| Query params | `query`, `skillCategory`, `skillName`, `location`, `minRating`, `maxRating`, `availability[]`, `learningStyle`, `page`, `pageSize` |
| Response | `PaginatedResponseModel<UserProfileModel>` (or `SearchResultModel`) |
| Dio method | `_dio.get('/search/users', queryParameters: params)` |
| Remote source | `SearchRemoteSource.searchUsers(SearchFiltersModel filters, {int page})` |
| Repository | `SearchRepository.searchUsers(SearchFiltersModel filters, {int page}) → Future<Either<Failure, SearchResultModel>>` |
| Provider | `searchProvider` |
| Used by | SearchScreen |

---

## 11. Community

### GET /community/posts

**Purpose:** List discussion posts.

| Item | Value |
|------|-------|
| Query params | `page`, `pageSize`, `category` (optional) |
| Response | `PaginatedResponseModel<DiscussionPostModel>` |
| Dio method | `_dio.get('/community/posts', queryParameters: params)` |
| Remote source | `CommunityRemoteSource.getPosts({int? page, String? category})` |
| Repository | `CommunityRepository.getPosts(...) → Future<Either<Failure, PaginatedResponseModel<DiscussionPostModel>>>` |
| Provider | `discussionPostsProvider` |
| Used by | CommunityScreen (Discussions tab) |

---

### POST /community/posts

**Purpose:** Create a new discussion post.

| Item | Value |
|------|-------|
| Request body | `CreatePostDto { title, category, content, tags }` |
| Response | `ApiResponseModel<DiscussionPostModel>` |
| Dio method | `_dio.post('/community/posts', data: dto.toJson())` |
| Remote source | `CommunityRemoteSource.createPost(CreatePostDto dto)` |
| Repository | `CommunityRepository.createPost(CreatePostDto dto) → Future<Either<Failure, DiscussionPostModel>>` |
| Provider | `CommunityNotifier.createPost(dto)` |
| Used by | CreatePostSheet |

---

### POST /community/posts/:id/like

**Purpose:** Like a discussion post.

| Item | Value |
|------|-------|
| Path params | `id` — post ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/community/posts/$id/like')` |
| Remote source | `CommunityRemoteSource.likePost(String id)` |
| Repository | `CommunityRepository.likePost(String id) → Future<Either<Failure, void>>` |
| Provider | `CommunityNotifier.likePost(id)` |
| Used by | DiscussionCard (like button) |

---

### DELETE /community/posts/:id/like

**Purpose:** Unlike a discussion post.

| Item | Value |
|------|-------|
| Path params | `id` — post ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.delete('/community/posts/$id/like')` |
| Remote source | `CommunityRemoteSource.unlikePost(String id)` |
| Repository | `CommunityRepository.unlikePost(String id) → Future<Either<Failure, void>>` |
| Provider | `CommunityNotifier.unlikePost(id)` |
| Used by | DiscussionCard (unlike button) |

---

### GET /community/circles

**Purpose:** List learning circles.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<LearningCircleModel>>` |
| Dio method | `_dio.get('/community/circles')` |
| Remote source | `CommunityRemoteSource.getCircles()` |
| Repository | `CommunityRepository.getCircles() → Future<Either<Failure, List<LearningCircleModel>>>` |
| Provider | `learningCirclesProvider` |
| Used by | CommunityScreen (Learning Circles tab) |

---

### POST /community/circles

**Purpose:** Create a new learning circle.

| Item | Value |
|------|-------|
| Request body | `CreateCircleDto { name, category, description, maxMembers }` |
| Response | `ApiResponseModel<LearningCircleModel>` |
| Dio method | `_dio.post('/community/circles', data: dto.toJson())` |
| Remote source | `CommunityRemoteSource.createCircle(CreateCircleDto dto)` |
| Repository | `CommunityRepository.createCircle(CreateCircleDto dto) → Future<Either<Failure, LearningCircleModel>>` |
| Provider | `CommunityNotifier.createCircle(dto)` |
| Used by | CreateCircleSheet |

---

### POST /community/circles/:id/join

**Purpose:** Join a learning circle.

| Item | Value |
|------|-------|
| Path params | `id` — circle ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.post('/community/circles/$id/join')` |
| Remote source | `CommunityRemoteSource.joinCircle(String id)` |
| Repository | `CommunityRepository.joinCircle(String id) → Future<Either<Failure, void>>` |
| Provider | `CommunityNotifier.joinCircle(id)` |
| Used by | LearningCircleCard |

---

### DELETE /community/circles/:id/leave

**Purpose:** Leave a learning circle.

| Item | Value |
|------|-------|
| Path params | `id` — circle ID |
| Response | `ApiResponseModel<void>` |
| Dio method | `_dio.delete('/community/circles/$id/leave')` |
| Remote source | `CommunityRemoteSource.leaveCircle(String id)` |
| Repository | `CommunityRepository.leaveCircle(String id) → Future<Either<Failure, void>>` |
| Provider | `CommunityNotifier.leaveCircle(id)` |
| Used by | LearningCircleCard |

---

### GET /community/leaderboard

**Purpose:** Get the community leaderboard.

| Item | Value |
|------|-------|
| Response | `ApiResponseModel<List<LeaderboardEntryModel>>` |
| Dio method | `_dio.get('/community/leaderboard')` |
| Remote source | `CommunityRemoteSource.getLeaderboard()` |
| Repository | `CommunityRepository.getLeaderboard() → Future<Either<Failure, List<LeaderboardEntryModel>>>` |
| Provider | `leaderboardProvider` |
| Used by | CommunityScreen (Leaderboard tab) |

---

## 12. Reports

### POST /reports

**Purpose:** Report a user.

| Item | Value |
|------|-------|
| Request body | `{ "reportedUserId": "<id>", "reason": "<reason>", "description": "<text>" }` |
| Response | `ApiResponseModel<UserReportModel>` |
| Dio method | `_dio.post('/reports', data: body)` |
| Remote source | `AdminRemoteSource.createReport(String userId, String reason, String description)` |
| Repository | `AdminRepository.createReport(...) → Future<Either<Failure, UserReportModel>>` |
| Provider | `ProfileNotifier.reportUser(userId, reason, description)` |
| Used by | ReportUserSheet |

---

### GET /reports

**Purpose:** List all reports (admin).

| Item | Value |
|------|-------|
| Query params | `status` (pending, resolved, dismissed), `page`, `pageSize` |
| Response | `PaginatedResponseModel<UserReportModel>` |
| Dio method | `_dio.get('/reports', queryParameters: params)` |
| Remote source | `AdminRemoteSource.getReports({String? status, int? page})` |
| Repository | `AdminRepository.getReports(...) → Future<Either<Failure, PaginatedResponseModel<UserReportModel>>>` |
| Provider | `contentModerationProvider` |
| Used by | ContentModerationScreen |

---

### PUT /reports/:id

**Purpose:** Update report status (resolve/dismiss).

| Item | Value |
|------|-------|
| Path params | `id` — report ID |
| Request body | `{ "status": "resolved"|"dismissed", "note": "<optional>" }` |
| Response | `ApiResponseModel<UserReportModel>` |
| Dio method | `_dio.put('/reports/$id', data: body)` |
| Remote source | `AdminRemoteSource.updateReport(String id, String status, {String? note})` |
| Repository | `AdminRepository.updateReport(...) → Future<Either<Failure, UserReportModel>>` |
| Provider | `AdminNotifier.resolveReport(id, status, note)` |
| Used by | ContentModerationScreen |

---

## 13. Uploads

### POST /uploads/avatar

**Purpose:** Upload a user avatar image.

| Item | Value |
|------|-------|
| Request body | `FormData` with file field `avatar` |
| Content-Type | `multipart/form-data` |
| Response | `ApiResponseModel<{ url: string }>` |
| Dio method | `_dio.post('/uploads/avatar', data: formData)` |
| Remote source | `ProfileRemoteSource.uploadAvatar(File file)` |
| Repository | `ProfileRepository.uploadAvatar(File file) → Future<Either<Failure, String>>` (returns URL) |
| Provider | `ProfileNotifier.uploadAvatar(file)` |
| Used by | ProfileScreen (edit mode, avatar tap) |

---

## Endpoint Summary

| Feature | Endpoints | Count |
|---------|-----------|-------|
| Auth | login, signup, logout, refresh, me, forgot-pw, reset-pw, verify-email, change-pw, google | 10 |
| Profiles | me, :id, update, list | 4 |
| Skills | list, categories | 2 |
| Matching | list, suggestions | 2 |
| Connections | list, request, pending, sent, respond, remove, status | 7 |
| Sessions | upcoming, create, cancel, complete, reschedule | 5 |
| Messages | conversations, messages, send, read | 4 |
| Reviews | user reviews, user stats, create | 3 |
| Notifications | list, unread-count, read, read-all, delete | 5 |
| Search | users | 1 |
| Community | posts (CRUD, like/unlike), circles (CRUD, join/leave), leaderboard | 9 |
| Reports | create, list, update | 3 |
| Uploads | avatar | 1 |
| **Total** | | **56** |
