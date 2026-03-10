# Skill Exchange — Dart Data Models

> Complete Freezed model definitions for every data entity.
> All models live in `lib/data/models/`.
> Generated files: `*.freezed.dart` (immutable classes) and `*.g.dart` (JSON serialisation).

---

## 1. User (Auth)

**File:** `lib/data/models/user_model.dart`

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,  // 'user' | 'admin'
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Unique user identifier |
| email | String | No | User email address |
| name | String | No | Display name |
| avatar | String? | Yes | Avatar image URL |
| role | String | No | User role: 'user' or 'admin' (default: 'user') |

---

## 2. Skill

**File:** `lib/data/models/skill_model.dart`

```dart
@freezed
class SkillModel with _$SkillModel {
  const factory SkillModel({
    required String id,
    required String name,
    required String category,
    required SkillLevel level,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) => _$SkillModelFromJson(json);
}

enum SkillLevel {
  @JsonValue('beginner') beginner,
  @JsonValue('intermediate') intermediate,
  @JsonValue('advanced') advanced,
  @JsonValue('expert') expert,
}

enum SkillCategory {
  @JsonValue('Frontend') frontend,
  @JsonValue('Backend') backend,
  @JsonValue('Programming') programming,
  @JsonValue('Data Science') dataScience,
  @JsonValue('DevOps') devOps,
  @JsonValue('Cloud') cloud,
  @JsonValue('Design') design,
  @JsonValue('Blockchain') blockchain,
  @JsonValue('Security') security,
  @JsonValue('Mobile') mobile,
  @JsonValue('Other') other,
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Unique skill identifier |
| name | String | No | Skill name (e.g., "Flutter", "React") |
| category | String | No | Category from SkillCategory enum |
| level | SkillLevel | No | Proficiency level |

---

## 3. UserProfile

**File:** `lib/data/models/user_profile_model.dart`

```dart
@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String username,
    required String email,
    required String fullName,
    String? avatar,
    String? bio,
    String? location,
    String? timezone,
    @Default([]) List<String> languages,
    @Default([]) List<SkillModel> skillsToTeach,
    @Default([]) List<SkillModel> skillsToLearn,
    @Default([]) List<String> interests,
    required AvailabilityModel availability,
    @Default('visual') String preferredLearningStyle,  // visual | auditory | kinesthetic | reading
    required String joinedAt,
    required String lastActive,
    required UserStatsModel stats,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
class AvailabilityModel with _$AvailabilityModel {
  const factory AvailabilityModel({
    @Default(false) bool monday,
    @Default(false) bool tuesday,
    @Default(false) bool wednesday,
    @Default(false) bool thursday,
    @Default(false) bool friday,
    @Default(false) bool saturday,
    @Default(false) bool sunday,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);
}

@freezed
class UserStatsModel with _$UserStatsModel {
  const factory UserStatsModel({
    @Default(0) int connectionsCount,
    @Default(0) int sessionsCompleted,
    @Default(0) int reviewsReceived,
    @Default(0.0) double averageRating,
  }) = _UserStatsModel;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);
}
```

**Fields (UserProfileModel):**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Unique user ID |
| username | String | No | Unique username |
| email | String | No | Email address |
| fullName | String | No | Full display name |
| avatar | String? | Yes | Avatar URL |
| bio | String? | Yes | User biography |
| location | String? | Yes | User location |
| timezone | String? | Yes | User timezone |
| languages | List\<String\> | No | Languages spoken (default: []) |
| skillsToTeach | List\<SkillModel\> | No | Skills the user can teach |
| skillsToLearn | List\<SkillModel\> | No | Skills the user wants to learn |
| interests | List\<String\> | No | User interests |
| availability | AvailabilityModel | No | Weekly availability (7 days) |
| preferredLearningStyle | String | No | Learning style preference |
| joinedAt | String | No | ISO 8601 date string |
| lastActive | String | No | ISO 8601 date string |
| stats | UserStatsModel | No | User statistics |

---

## 4. UpdateProfileDto

**File:** `lib/data/models/update_profile_dto.dart`

```dart
@freezed
class UpdateProfileDto with _$UpdateProfileDto {
  const factory UpdateProfileDto({
    String? fullName,
    String? bio,
    String? location,
    String? timezone,
    List<String>? languages,
    List<SkillModel>? skillsToTeach,
    List<SkillModel>? skillsToLearn,
    List<String>? interests,
    AvailabilityModel? availability,
    String? preferredLearningStyle,
  }) = _UpdateProfileDto;

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);
}
```

---

## 5. MatchScore

**File:** `lib/data/models/match_score_model.dart`

```dart
@freezed
class MatchScoreModel with _$MatchScoreModel {
  const factory MatchScoreModel({
    required String userId,
    required UserProfileModel profile,
    required double compatibilityScore,
    required double skillOverlapScore,
    required double availabilityScore,
    required double locationScore,
    required double languageScore,
    required MatchedSkillsModel matchedSkills,
  }) = _MatchScoreModel;

  factory MatchScoreModel.fromJson(Map<String, dynamic> json) =>
      _$MatchScoreModelFromJson(json);
}

@freezed
class MatchedSkillsModel with _$MatchedSkillsModel {
  const factory MatchedSkillsModel({
    @Default([]) List<String> theyTeach,
    @Default([]) List<String> youTeach,
  }) = _MatchedSkillsModel;

  factory MatchedSkillsModel.fromJson(Map<String, dynamic> json) =>
      _$MatchedSkillsModelFromJson(json);
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| userId | String | No | Matched user's ID |
| profile | UserProfileModel | No | Full profile of matched user |
| compatibilityScore | double | No | Overall score (0-100) |
| skillOverlapScore | double | No | Skill overlap component (50% weight) |
| availabilityScore | double | No | Availability component (20% weight) |
| locationScore | double | No | Location component (10% weight) |
| languageScore | double | No | Language component (15% weight) |
| matchedSkills | MatchedSkillsModel | No | Skills they teach you / you teach them |

---

## 6. MatchingFilters

**File:** `lib/data/models/matching_filters_model.dart`

```dart
@freezed
class MatchingFiltersModel with _$MatchingFiltersModel {
  const factory MatchingFiltersModel({
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    List<String>? availability,
    String? learningStyle,
    List<String>? languages,
  }) = _MatchingFiltersModel;

  factory MatchingFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingFiltersModelFromJson(json);
}
```

---

## 7. Connection

**File:** `lib/data/models/connection_model.dart`

```dart
@freezed
class ConnectionModel with _$ConnectionModel {
  const factory ConnectionModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    required ConnectionStatus status,
    String? message,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  }) = _ConnectionModel;

  factory ConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectionModelFromJson(json);
}

enum ConnectionStatus {
  @JsonValue('pending') pending,
  @JsonValue('accepted') accepted,
  @JsonValue('rejected') rejected,
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Connection ID |
| fromUserId | String | No | ID of user who sent the request |
| toUserId | String | No | ID of user who received the request |
| status | ConnectionStatus | No | pending, accepted, or rejected |
| message | String? | Yes | Optional connection request message |
| createdAt | String | No | ISO 8601 date string |
| updatedAt | String | No | ISO 8601 date string |
| fromUser | UserProfileModel? | Yes | Sender's profile (populated by API) |
| toUser | UserProfileModel? | Yes | Receiver's profile (populated by API) |

---

## 8. Session

**File:** `lib/data/models/session_model.dart`

```dart
@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String hostId,
    required String participantId,
    required String title,
    @Default('') String description,
    @Default([]) List<String> skillsToCover,
    required String scheduledAt,
    required int duration,  // in minutes
    required SessionStatus status,
    @Default('online') String sessionMode,  // 'online' | 'offline'
    String? meetingPlatform,
    String? meetingLink,
    String? location,
    String? notes,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? host,
    UserProfileModel? participant,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

enum SessionStatus {
  @JsonValue('scheduled') scheduled,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled,
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Session ID |
| hostId | String | No | User who hosts the session |
| participantId | String | No | User who participates |
| title | String | No | Session title |
| description | String | No | Session description (default: '') |
| skillsToCover | List\<String\> | No | Skills to be covered |
| scheduledAt | String | No | ISO 8601 date string |
| duration | int | No | Duration in minutes (30/60/90/120/180) |
| status | SessionStatus | No | scheduled, completed, or cancelled |
| sessionMode | String | No | 'online' or 'offline' |
| meetingPlatform | String? | Yes | Google Meet, Zoom, Teams, Skype, Discord, Custom |
| meetingLink | String? | Yes | URL for online sessions |
| location | String? | Yes | Physical location for offline sessions |
| notes | String? | Yes | Session notes |
| createdAt | String | No | ISO 8601 date string |
| updatedAt | String | No | ISO 8601 date string |
| host | UserProfileModel? | Yes | Host profile (populated by API) |
| participant | UserProfileModel? | Yes | Participant profile (populated by API) |

---

## 9. CreateSessionDto

**File:** `lib/data/models/create_session_dto.dart`

```dart
@freezed
class CreateSessionDto with _$CreateSessionDto {
  const factory CreateSessionDto({
    required String participantId,
    required String title,
    String? description,
    @Default([]) List<String> skillsToCover,
    required String scheduledAt,
    required int duration,
    @Default('online') String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
  }) = _CreateSessionDto;

  factory CreateSessionDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionDtoFromJson(json);
}
```

---

## 10. RescheduleSessionDto

**File:** `lib/data/models/reschedule_session_dto.dart`

```dart
@freezed
class RescheduleSessionDto with _$RescheduleSessionDto {
  const factory RescheduleSessionDto({
    required String newScheduledAt,
    required int newDuration,
    String? reason,
  }) = _RescheduleSessionDto;

  factory RescheduleSessionDto.fromJson(Map<String, dynamic> json) =>
      _$RescheduleSessionDtoFromJson(json);
}
```

---

## 11. Message

**File:** `lib/data/models/message_model.dart`

```dart
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required String createdAt,
    @Default(false) bool read,
    UserProfileModel? sender,
    @Default(false) bool isFromMe,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Message ID |
| conversationId | String | No | Parent conversation ID |
| senderId | String | No | Sender's user ID |
| receiverId | String | No | Receiver's user ID |
| content | String | No | Message text |
| createdAt | String | No | ISO 8601 date string |
| read | bool | No | Whether message has been read (default: false) |
| sender | UserProfileModel? | Yes | Sender profile (populated by API) |
| isFromMe | bool | No | Whether current user sent this (default: false) |

---

## 12. Conversation

**File:** `lib/data/models/conversation_model.dart`

```dart
@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    @Default([]) List<String> participants,
    String? lastMessage,
    String? lastMessageAt,
    @Default(0) int unreadCount,
    required String updatedAt,
    @Default([]) List<UserProfileModel> participantProfiles,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Conversation ID |
| participants | List\<String\> | No | List of participant user IDs |
| lastMessage | String? | Yes | Preview of last message |
| lastMessageAt | String? | Yes | ISO 8601 date of last message |
| unreadCount | int | No | Number of unread messages (default: 0) |
| updatedAt | String | No | ISO 8601 date string |
| participantProfiles | List\<UserProfileModel\> | No | Participant profiles |

---

## 13. Review

**File:** `lib/data/models/review_model.dart`

```dart
@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    required int rating,  // 1-5
    required String comment,
    @Default([]) List<String> skillsReviewed,
    String? sessionId,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

@freezed
class ReviewStatsModel with _$ReviewStatsModel {
  const factory ReviewStatsModel({
    @Default(0.0) double averageRating,
    @Default(0) int totalReviews,
    @Default({}) Map<String, int> ratingDistribution,  // {"1": 0, "2": 1, ...}
  }) = _ReviewStatsModel;

  factory ReviewStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatsModelFromJson(json);
}
```

**Fields (ReviewModel):**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Review ID |
| fromUserId | String | No | Reviewer's user ID |
| toUserId | String | No | Reviewed user's ID |
| rating | int | No | Star rating (1-5) |
| comment | String | No | Review comment (10-1000 chars) |
| skillsReviewed | List\<String\> | No | Skills covered in review |
| sessionId | String? | Yes | Related session ID |
| createdAt | String | No | ISO 8601 date string |
| updatedAt | String | No | ISO 8601 date string |
| fromUser | UserProfileModel? | Yes | Reviewer profile |
| toUser | UserProfileModel? | Yes | Reviewed user profile |

---

## 14. CreateReviewDto

**File:** `lib/data/models/create_review_dto.dart`

```dart
@freezed
class CreateReviewDto with _$CreateReviewDto {
  const factory CreateReviewDto({
    required String toUserId,
    required int rating,
    required String comment,
    @Default([]) List<String> skillsReviewed,
    String? sessionId,
  }) = _CreateReviewDto;

  factory CreateReviewDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewDtoFromJson(json);
}
```

---

## 15. Notification

**File:** `lib/data/models/notification_model.dart`

```dart
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    @Default(false) bool read,
    required String createdAt,
    String? actionUrl,
    @Default({}) Map<String, dynamic> metadata,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

enum NotificationType {
  @JsonValue('connection_request') connectionRequest,
  @JsonValue('connection_accepted') connectionAccepted,
  @JsonValue('session_reminder') sessionReminder,
  @JsonValue('session_cancelled') sessionCancelled,
  @JsonValue('new_message') newMessage,
  @JsonValue('review_received') reviewReceived,
  @JsonValue('system') system,
}
```

**Fields:**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Notification ID |
| userId | String | No | Recipient user ID |
| type | NotificationType | No | One of 7 notification types |
| title | String | No | Notification title |
| message | String | No | Notification body text |
| read | bool | No | Read status (default: false) |
| createdAt | String | No | ISO 8601 date string |
| actionUrl | String? | Yes | URL to navigate to on tap |
| metadata | Map\<String, dynamic\> | No | Extra data (default: {}) |

---

## 16. SearchFilters / SearchResult

**File:** `lib/data/models/search_result_model.dart`

```dart
@freezed
class SearchFiltersModel with _$SearchFiltersModel {
  const factory SearchFiltersModel({
    String? query,
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    List<String>? availability,
    String? learningStyle,
    List<String>? languages,
  }) = _SearchFiltersModel;

  factory SearchFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersModelFromJson(json);
}

@freezed
class SearchResultModel with _$SearchResultModel {
  const factory SearchResultModel({
    @Default([]) List<UserProfileModel> users,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int pageSize,
  }) = _SearchResultModel;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);
}
```

---

## 17. DiscussionPost

**File:** `lib/data/models/discussion_post_model.dart`

```dart
@freezed
class DiscussionPostModel with _$DiscussionPostModel {
  const factory DiscussionPostModel({
    required String id,
    required String title,
    required String content,
    required String category,  // Tips & Tricks | Resources | Partner Search | Discussion | Question
    @Default([]) List<String> tags,
    required String authorId,
    UserProfileModel? author,
    @Default(0) int likes,
    @Default(0) int replies,
    required String createdAt,
    required String updatedAt,
  }) = _DiscussionPostModel;

  factory DiscussionPostModel.fromJson(Map<String, dynamic> json) =>
      _$DiscussionPostModelFromJson(json);
}

@freezed
class CreatePostDto with _$CreatePostDto {
  const factory CreatePostDto({
    required String title,
    required String category,
    required String content,
    @Default([]) List<String> tags,  // 1-5 tags
  }) = _CreatePostDto;

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);
}
```

**Fields (DiscussionPostModel):**
| Field | Type | Optional | Description |
|-------|------|----------|-------------|
| id | String | No | Post ID |
| title | String | No | Post title |
| content | String | No | Post body text |
| category | String | No | Post category |
| tags | List\<String\> | No | Tags (1-5) |
| authorId | String | No | Author's user ID |
| author | UserProfileModel? | Yes | Author profile |
| likes | int | No | Like count (default: 0) |
| replies | int | No | Reply count (default: 0) |
| createdAt | String | No | ISO 8601 date string |
| updatedAt | String | No | ISO 8601 date string |

---

## 18. LearningCircle

**File:** `lib/data/models/learning_circle_model.dart`

```dart
@freezed
class LearningCircleModel with _$LearningCircleModel {
  const factory LearningCircleModel({
    required String id,
    required String name,
    required String description,
    required String category,
    @Default([]) List<String> members,
    required int maxMembers,
    required String createdBy,
    required String createdAt,
    String? imageUrl,
  }) = _LearningCircleModel;

  factory LearningCircleModel.fromJson(Map<String, dynamic> json) =>
      _$LearningCircleModelFromJson(json);
}

@freezed
class CreateCircleDto with _$CreateCircleDto {
  const factory CreateCircleDto({
    required String name,
    required String category,
    required String description,
    required int maxMembers,  // 2-100
  }) = _CreateCircleDto;

  factory CreateCircleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCircleDtoFromJson(json);
}
```

---

## 19. LeaderboardEntry

**File:** `lib/data/models/leaderboard_entry_model.dart`

```dart
@freezed
class LeaderboardEntryModel with _$LeaderboardEntryModel {
  const factory LeaderboardEntryModel({
    required String userId,
    required int rank,
    required int score,
    @Default(0) int sessionsCompleted,
    @Default(0) int reviewsGiven,
    @Default(0) int connectionsCount,
    UserProfileModel? user,
  }) = _LeaderboardEntryModel;

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);
}
```

---

## 20. UserReport (Admin)

**File:** `lib/data/models/user_report_model.dart`

```dart
@freezed
class UserReportModel with _$UserReportModel {
  const factory UserReportModel({
    required String id,
    required String reportedUserId,
    String? reporterName,
    required String reason,  // Spam | Harassment | Inappropriate | Fake Profile | Scam | Other
    required String description,
    @Default('pending') String status,  // pending | reviewed | resolved | dismissed
    required String createdAt,
    String? reviewedAt,
    String? reviewedBy,
  }) = _UserReportModel;

  factory UserReportModel.fromJson(Map<String, dynamic> json) =>
      _$UserReportModelFromJson(json);
}
```

---

## 21. PlatformStats (Admin)

**File:** `lib/data/models/platform_stats_model.dart`

```dart
@freezed
class PlatformStatsModel with _$PlatformStatsModel {
  const factory PlatformStatsModel({
    @Default(0) int totalUsers,
    @Default(0) int activeUsers,
    @Default(0) int totalSessions,
    @Default(0) int completedSessions,
    @Default(0) int totalConnections,
    @Default(0) int totalReviews,
    @Default(0.0) double averageRating,
    @Default(0) int totalPosts,
    @Default(0) int totalCircles,
    @Default(0) int pendingReports,
  }) = _PlatformStatsModel;

  factory PlatformStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformStatsModelFromJson(json);
}
```

---

## 22. API Response Wrappers

**File:** `lib/data/models/api_response_model.dart`

```dart
@freezed
class ApiResponseModel<T> with _$ApiResponseModel<T> {
  const factory ApiResponseModel({
    required T data,
    String? message,
    @Default(true) bool success,
  }) = _ApiResponseModel;
}

@freezed
class PaginatedResponseModel<T> with _$PaginatedResponseModel<T> {
  const factory PaginatedResponseModel({
    required List<T> data,
    required PaginationModel pagination,
  }) = _PaginatedResponseModel;
}

@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @Default(1) int page,
    @Default(20) int pageSize,
    @Default(0) int totalItems,
    @Default(0) int totalPages,
    @Default(false) bool hasNextPage,
    @Default(false) bool hasPreviousPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}
```

---

## 23. Auth Request DTOs

**File:** `lib/data/models/auth_dto.dart`

```dart
@freezed
class LoginDto with _$LoginDto {
  const factory LoginDto({
    required String email,
    required String password,
  }) = _LoginDto;

  factory LoginDto.fromJson(Map<String, dynamic> json) => _$LoginDtoFromJson(json);
}

@freezed
class SignupDto with _$SignupDto {
  const factory SignupDto({
    required String name,
    required String email,
    required String password,
  }) = _SignupDto;

  factory SignupDto.fromJson(Map<String, dynamic> json) => _$SignupDtoFromJson(json);
}

@freezed
class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    required String accessToken,
    String? refreshToken,
    required UserModel user,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);
}

@freezed
class ChangePasswordDto with _$ChangePasswordDto {
  const factory ChangePasswordDto({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePasswordDto;

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDtoFromJson(json);
}
```

---

## Model Relationships

```
UserModel (auth)
  └── role determines admin access

UserProfileModel
  ├── has many SkillModel (skillsToTeach, skillsToLearn)
  ├── has one AvailabilityModel
  ├── has one UserStatsModel
  └── referenced by: ConnectionModel, SessionModel, ReviewModel, MessageModel,
      MatchScoreModel, DiscussionPostModel, LeaderboardEntryModel

ConnectionModel
  ├── belongs to UserProfileModel (fromUser)
  └── belongs to UserProfileModel (toUser)

SessionModel
  ├── belongs to UserProfileModel (host)
  └── belongs to UserProfileModel (participant)

ReviewModel
  ├── belongs to UserProfileModel (fromUser)
  ├── belongs to UserProfileModel (toUser)
  └── optionally references SessionModel (sessionId)

ConversationModel
  ├── has many participants (user IDs)
  └── has many UserProfileModel (participantProfiles)

MessageModel
  ├── belongs to ConversationModel
  └── belongs to UserProfileModel (sender)

DiscussionPostModel
  └── belongs to UserProfileModel (author)

LearningCircleModel
  └── has many members (user IDs)

LeaderboardEntryModel
  └── belongs to UserProfileModel (user)

NotificationModel
  └── belongs to UserModel (userId)

UserReportModel
  └── references a reported user (reportedUserId)
```
