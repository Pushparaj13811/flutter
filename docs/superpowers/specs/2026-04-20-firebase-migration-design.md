# Firebase Migration Design Spec

> Replace the entire Node.js/MongoDB/Socket.IO backend with Firebase (Spark free plan). All logic client-side, Firestore Security Rules for access control.

---

## Firebase Services Used (Spark Plan — Free)

| Service | Purpose | Limits |
|---------|---------|--------|
| Firebase Auth | Email/password + Google sign-in | Unlimited |
| Cloud Firestore | All app data | 1 GiB, 50K reads/day, 20K writes/day |
| Cloud Storage | Avatars, covers, post media | 5 GB, 1 GB/day download |
| Firebase Cloud Messaging | Push notifications | Unlimited |
| Firestore listeners | Real-time messaging + signaling | Counts toward reads |

**No Cloud Functions.** All business logic lives in the Flutter client.

---

## Firestore Data Model

### `users/{uid}`
```
name: string
email: string
role: "user" | "admin"
isVerified: bool
isActive: bool
lastLogin: timestamp
createdAt: timestamp
updatedAt: timestamp
```

### `profiles/{uid}`
```
username: string (unique — enforce via a `usernames/{username}` lookup doc)
avatar: string? (Storage URL)
coverImage: string? (Storage URL)
bio: string
location: string
timezone: string
languages: string[]
skillsToTeach: [{name, category, level, isVerified}]
skillsToLearn: [{name, category, level, isVerified}]
interests: string[]
availability: {monday: bool, tuesday: bool, ...}
preferredLearningStyle: "visual" | "auditory" | "kinesthetic" | "reading"
stats: {connectionsCount, sessionsCompleted, reviewsReceived, averageRating}
privacyPreferences: {profileVisibility, showEmail, showLocation, showOnlineStatus, allowMessages}
notificationPreferences: {emailNotifications, pushNotifications, connectionRequests, sessionReminders, newMessages, reviewsReceived, marketingEmails}
createdAt: timestamp
updatedAt: timestamp
```

### `usernames/{username}`
```
uid: string
```
Used to enforce username uniqueness (Firestore has no unique constraint on fields).

### `matchPool/{uid}`
Denormalized public subset for matching queries:
```
username: string
avatar: string?
skillsToTeach: [{name, category, level}]
skillsToLearn: [{name, category, level}]
availability: {monday: bool, ...}
location: string
averageRating: number
sessionsCompleted: number
updatedAt: timestamp
```
Written whenever user updates their profile/skills.

### `connections/{connectionId}`
```
requester: string (uid)
recipient: string (uid)
status: "pending" | "accepted" | "rejected" | "withdrawn"
message: string
participants: [requester, recipient]  // for querying "my connections"
createdAt: timestamp
updatedAt: timestamp
```
`participants` array enables `where('participants', arrayContains: myUid)` queries.

### `sessions/{sessionId}`
```
host: string (uid)
participant: string (uid)
participants: [host, participant]  // for querying
title: string
description: string
skillsToCover: string[]
scheduledAt: timestamp
duration: number (minutes)
status: "scheduled" | "completed" | "cancelled"
sessionMode: "online" | "offline"
meetingPlatform: "in-app" | "google-meet" | "custom" | null
meetingLink: string?
location: string?
notes: string
isRequest: bool
createdAt: timestamp
updatedAt: timestamp
```

### `messages/{threadId}`
Thread document (one per unique pair of users):
```
participants: [uid1, uid2]
lastMessage: string
lastMessageAt: timestamp
unreadCount_{uid1}: number
unreadCount_{uid2}: number
createdAt: timestamp
```
Thread ID convention: alphabetically sorted UIDs joined with `_` → `uid1_uid2` where `uid1 < uid2`.

### `messages/{threadId}/msgs/{msgId}`
```
sender: string (uid)
content: string
createdAt: timestamp
isRead: bool
```

### `typing/{threadId}`
```
{uid}: timestamp | null
```
Set to `serverTimestamp()` when typing, set to `null` when stopped. Client ignores entries older than 5 seconds.

### `reviews/{reviewId}`
```
fromUser: string (uid)
toUser: string (uid)
session: string? (sessionId)
rating: number (1-5)
comment: string
skillsReviewed: string[]
status: "pending" | "approved" | "rejected"
isFeatured: bool
createdAt: timestamp
```

### `notifications/{uid}/items/{notifId}`
```
type: "connection_request" | "connection_accepted" | "message" | "session_booked" | "session_reminder" | "review_received" | "skill_match"
title: string
message: string
isRead: bool
actionUrl: string?
metadata: map?
createdAt: timestamp
```

### `posts/{postId}`
```
author: string (uid)
authorName: string (denormalized for display)
authorAvatar: string? (denormalized)
title: string
content: string
category: string
circle: string? (circleId)
tags: string[]
images: [{url, path}]
videoUrl: string?
mediaType: "text" | "image" | "video"
likesCount: number
repliesCount: number
likedBy: string[] (uids — for checking if current user liked; cap at reasonable size)
moderationStatus: "active" | "hidden" | "removed"
createdAt: timestamp
updatedAt: timestamp
```

### `posts/{postId}/replies/{replyId}`
```
author: string (uid)
authorName: string
authorAvatar: string?
content: string
createdAt: timestamp
```

### `circles/{circleId}`
```
name: string
description: string
category: string
members: string[] (uids)
maxMembers: number
createdBy: string (uid)
imageUrl: string?
createdAt: timestamp
```

### `reports/{reportId}`
```
reporter: string (uid)
reportedUser: string (uid)
reason: "spam" | "harassment" | "inappropriate" | "fake_profile" | "scam" | "other"
description: string
status: "pending" | "reviewed" | "resolved" | "dismissed"
resolutionNote: string?
reviewedBy: string? (admin uid)
reviewedAt: timestamp?
createdAt: timestamp
```

### `calls/{callId}`
WebRTC signaling document:
```
caller: string (uid)
callee: string (uid)
status: "ringing" | "active" | "ended" | "declined"
offer: map? (RTCSessionDescription as JSON)
answer: map? (RTCSessionDescription as JSON)
callerCandidates: [{candidate, sdpMid, sdpMLineIndex}]
calleeCandidates: [{candidate, sdpMid, sdpMLineIndex}]
createdAt: timestamp
endedAt: timestamp?
```

### `publicStats` (single document)
```
totalUsers: number
totalSessions: number
totalConnections: number
```
Updated client-side on relevant actions (increment on new user signup, session completion, connection acceptance).

### `leaderboard/{uid}`
```
username: string
avatar: string?
sessionsCompleted: number
reviewsReceived: number
averageRating: number
score: number (computed: sessions*10 + reviews*5 + rating*20)
updatedAt: timestamp
```

---

## Architecture Changes

### What Gets Removed

| Directory/File | Reason |
|---|---|
| `lib/data/sources/remote/*.dart` (all 12 files) | Dio-based HTTP calls → replaced by Firestore |
| `lib/core/network/auth_interceptor.dart` | Firebase Auth handles tokens |
| `lib/core/network/error_interceptor.dart` | No HTTP errors to intercept |
| `lib/core/network/mock_interceptor.dart` | No mock HTTP needed |
| `lib/core/network/socket_service.dart` | Firestore replaces Socket.IO |
| `lib/core/constants/api_endpoints.dart` | No REST endpoints |
| `lib/config/env/env_config.dart` | No API URL needed |

### What Gets Added

| Directory/File | Purpose |
|---|---|
| `lib/firebase_options.dart` | Generated by FlutterFire CLI |
| `lib/data/sources/firebase/auth_service.dart` | Firebase Auth wrapper |
| `lib/data/sources/firebase/firestore_service.dart` | Generic Firestore CRUD |
| `lib/data/sources/firebase/profile_service.dart` | Profile + matchPool writes |
| `lib/data/sources/firebase/connection_service.dart` | Connection requests/accept/reject |
| `lib/data/sources/firebase/session_service.dart` | Session CRUD |
| `lib/data/sources/firebase/messaging_service.dart` | Threads + messages + typing |
| `lib/data/sources/firebase/review_service.dart` | Reviews CRUD |
| `lib/data/sources/firebase/notification_service.dart` | Notifications CRUD |
| `lib/data/sources/firebase/community_service.dart` | Posts, circles, likes, replies |
| `lib/data/sources/firebase/storage_service.dart` | File upload to Cloud Storage |
| `lib/data/sources/firebase/matching_service.dart` | Query matchPool, compute scores |
| `lib/data/sources/firebase/search_service.dart` | Query profiles by filters |
| `lib/data/sources/firebase/admin_service.dart` | Admin operations |
| `lib/data/sources/firebase/call_service.dart` | WebRTC signaling via Firestore |
| `firestore.rules` | Security rules |
| `storage.rules` | Storage security rules |

### What Stays the Same

- All UI screens and widgets (no visual changes)
- Theme/design tokens
- go_router navigation
- Domain entities (`lib/domain/entities/`)
- Riverpod providers (they'll just point to Firebase services instead of repositories)
- `lib/core/theme/`, `lib/core/widgets/`, `lib/core/utils/`, `lib/core/extensions/`
- `lib/core/errors/failures.dart` (still used for error handling)
- `lib/core/network/connectivity_provider.dart` (still useful for offline detection)

### What Gets Modified

| File | Change |
|---|---|
| `pubspec.yaml` | Remove dio, fpdart, socket_io_client. Add firebase_core, firebase_auth, cloud_firestore, firebase_storage, firebase_messaging |
| `lib/main.dart` | Add `Firebase.initializeApp()` |
| `lib/config/di/providers.dart` | Replace Dio/remote source providers with Firebase service providers |
| `lib/features/auth/providers/auth_provider.dart` | Use FirebaseAuth streams |
| All feature providers | Point to Firebase services instead of repositories |
| `lib/data/repositories/*.dart` | Either rewrite to use Firebase services or remove (replaced by services directly) |
| `lib/domain/repositories/*.dart` | Keep interfaces but implementations change |

---

## Auth Flow

1. **Signup**: `FirebaseAuth.instance.createUserWithEmailAndPassword()` → create `users/{uid}` + `profiles/{uid}` docs → send email verification
2. **Login**: `FirebaseAuth.instance.signInWithEmailAndPassword()` → update `lastLogin`
3. **Google OAuth**: `GoogleSignIn` → `FirebaseAuth.instance.signInWithCredential()`
4. **Auth state**: `FirebaseAuth.instance.authStateChanges()` stream drives router redirect
5. **Logout**: `FirebaseAuth.instance.signOut()`
6. **Forgot password**: `FirebaseAuth.instance.sendPasswordResetEmail()`
7. **Verify email**: `user.sendEmailVerification()` / check `user.emailVerified`
8. **Ban check**: Read `users/{uid}.isActive` on auth state change; if false, show banned screen

---

## Real-Time Messaging Flow

1. **Thread list**: `messages` collection, `where('participants', arrayContains: myUid)`, `orderBy('lastMessageAt', descending: true)`, `.snapshots()` for real-time
2. **Messages in thread**: `messages/{threadId}/msgs`, `orderBy('createdAt')`, `.snapshots()`
3. **Send message**: Write to `msgs` subcollection + update parent thread's `lastMessage`, `lastMessageAt`, increment recipient's `unreadCount`
4. **Mark read**: Set `unreadCount_{myUid}` to 0, batch update `isRead` on unread msgs
5. **Typing indicator**: Write `typing/{threadId}.{myUid} = serverTimestamp()`, clear on stop. Listener on the typing doc, filter entries < 5s old.

---

## Video Call Signaling Flow

1. **Caller creates** `calls/{callId}` with `status: "ringing"`, `caller: myUid`, `callee: theirUid`
2. **Callee listens** for `calls` where `callee == myUid && status == "ringing"` → shows IncomingCallDialog
3. **Callee accepts**: Updates `status: "active"`, gets local media stream, creates RTCPeerConnection
4. **Caller detects** status change to "active", creates offer, writes to `calls/{callId}.offer`
5. **Callee reads offer**, creates answer, writes to `calls/{callId}.answer`
6. **ICE candidates**: Each party appends to `callerCandidates` or `calleeCandidates` array
7. **End call**: Set `status: "ended"`

---

## Matching Flow

1. On profile save, write denormalized data to `matchPool/{uid}`
2. Matching screen: query `matchPool` where skill categories overlap with user's `skillsToLearn`
3. Client-side: compute compatibility score based on skill overlap, availability overlap, location proximity
4. Sort by score, display top matches

---

## Firestore Security Rules (Key Points)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users: only self can write, anyone authenticated can read basic info
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == uid;
    }
    
    // Profiles: owner writes, authenticated reads (respecting privacy)
    match /profiles/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == uid;
    }
    
    // Match pool: owner writes, anyone authenticated reads
    match /matchPool/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == uid;
    }
    
    // Connections: participants can read, requester can create
    match /connections/{id} {
      allow read: if request.auth.uid in resource.data.participants;
      allow create: if request.auth.uid == request.resource.data.requester;
      allow update: if request.auth.uid in resource.data.participants;
    }
    
    // Messages: only participants
    match /messages/{threadId} {
      allow read, write: if request.auth.uid in resource.data.participants;
      match /msgs/{msgId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/messages/$(threadId)).data.participants;
        allow create: if request.auth.uid in get(/databases/$(database)/documents/messages/$(threadId)).data.participants;
      }
    }
    
    // Sessions: only participants
    match /sessions/{id} {
      allow read: if request.auth.uid in resource.data.participants;
      allow create: if request.auth != null;
      allow update: if request.auth.uid in resource.data.participants;
    }
    
    // Reviews: anyone can read, authenticated can create
    match /reviews/{id} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.fromUser;
    }
    
    // Posts: anyone authenticated can read, author or admin can write
    match /posts/{id} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.author || isAdmin();
    }
    
    // Admin helper
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

---

## Package Changes

### Remove
- `dio`
- `fpdart`
- `socket_io_client`
- `web_socket_channel` (already removed)

### Add
- `firebase_core: ^3.12.1` (already in pubspec)
- `firebase_auth: ^5.5.1`
- `cloud_firestore: ^5.6.5`
- `firebase_storage: ^12.4.4`
- `firebase_messaging: ^15.2.5` (already in pubspec)
- `google_sign_in: ^6.2.2`

### Keep
- `flutter_riverpod`, `riverpod_annotation`
- `go_router`
- `freezed_annotation`, `json_annotation`
- `flutter_secure_storage`, `shared_preferences`
- `reactive_forms`
- `image_picker`
- `cached_network_image`, `shimmer`, `flutter_rating_bar`, `timeago`, `url_launcher`
- `google_fonts`
- `connectivity_plus`
- `intl`

---

## Implementation Order

1. **Firebase setup** — Add packages, `firebase_options.dart`, `Firebase.initializeApp()`, basic rules
2. **Auth migration** — Replace auth provider/repository with Firebase Auth
3. **Profile + matchPool** — Firestore profile service, username uniqueness, match pool writes
4. **Core features** — Connections, Sessions, Reviews, Notifications, Search
5. **Messaging** — Real-time threads with Firestore listeners + typing indicators
6. **Community** — Posts, circles, likes, replies, media uploads
7. **Video calling** — WebRTC signaling via Firestore
8. **Admin** — Admin service with role-based access
9. **Cleanup** — Remove old Dio/remote source files, update mock data for development

---

## Quota Optimization Strategies

To stay within 50K reads/day:
- Use `.snapshots()` only for screens currently visible (auto-detach on dispose)
- Cache aggressively with Firestore's built-in offline persistence
- Denormalize frequently-read data (author name/avatar on posts, last message on threads)
- Use `limit()` on all list queries (20 items per page)
- Batch writes where possible (fewer documents = fewer reads on refresh)
- `matchPool` is read-heavy — use pagination and filters to limit result sets
