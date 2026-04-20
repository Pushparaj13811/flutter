# Skill Exchange

A mobile app where users connect, teach, and learn skills from each other. Built with Flutter and Firebase.

## Features

### For Users
- **Discover** — Find skill partners with compatibility matching based on complementary skills
- **Connections** — Send, accept, and manage connection requests
- **Messaging** — Real-time chat with typing indicators and read receipts via Firestore listeners
- **Sessions** — Book, reschedule, cancel, and complete learning sessions
- **Community** — Discussion posts, learning circles, and leaderboard
- **Reviews** — Rate and review your learning partners after sessions
- **Profile** — Showcase your skills to teach/learn, availability, bio, and cover/avatar images
- **Search** — Find users by skill, category, location, or name
- **Notifications** — Real-time notification bell with unread count
- **Settings** — Account management, privacy, notifications, appearance (light/dark/system)

### For Admins
- **Dashboard** — Platform stats (users, sessions, connections)
- **User Management** — List, ban/unban, change roles, delete users
- **Content Moderation** — Review and resolve user reports
- **Community Management** — Manage posts and learning circles
- **Seed Data** — One-tap test data seeding from admin panel

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.41+ / Dart 3.11+ |
| State Management | Riverpod |
| Navigation | go_router |
| Backend | Firebase (Auth + Cloud Firestore) |
| File Storage | Cloudinary |
| Push Notifications | Firebase Cloud Messaging |
| Font | Urbanist (via google_fonts) |

## Architecture

```
lib/
├── config/          # DI providers, router, app shell
├── core/            # Theme, widgets, utils, extensions, errors
├── data/
│   ├── models/      # Plain Dart data classes
│   ├── seed/        # Firestore seed data
│   └── sources/
│       └── firebase/  # All Firebase services (auth, firestore, cloudinary)
├── domain/
│   └── entities/    # Core domain entities
└── features/        # Feature modules
    ├── admin/       # Admin dashboard, user/content management
    ├── auth/        # Login, signup, email verification
    ├── community/   # Posts, circles, leaderboard
    ├── connections/ # Connection requests and management
    ├── dashboard/   # Home feed with posts and suggestions
    ├── matching/    # Discover users with skill matching
    ├── messaging/   # Real-time chat
    ├── notifications/
    ├── profile/     # View, edit, avatar/cover upload
    ├── reviews/     # Ratings and reviews
    ├── search/      # User search with filters
    ├── sessions/    # Session booking and management
    └── settings/    # Account, privacy, notifications, theme
```

## Getting Started

### Prerequisites

- Flutter 3.41+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- A Firebase project with Auth and Firestore enabled

### Setup

1. **Clone the repo**
   ```bash
   git clone <repo-url>
   cd skill_exchange
   ```

2. **Configure Firebase**
   ```bash
   firebase login
   flutterfire configure --project=YOUR_PROJECT_ID
   ```
   See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed steps.

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Deploy Firestore rules**
   ```bash
   firebase deploy --only firestore --project YOUR_PROJECT_ID
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

6. **Seed test data** (optional)

   On the login screen (debug mode), tap "Seed Test Data" to create 10 test users with connections, posts, and circles.

### Test Accounts (after seeding)

| Name | Email | Password | Role |
|------|-------|----------|------|
| Kruti Manani | Kmanani465@rku.ac.in | Kruti1234@#$ | Admin |
| Aarav Sharma | aarav.sharma@example.com | Aarav1234@#$ | User |
| Diya Patel | diya.patel@example.com | Diya1234@#$ | User |
| Rohan Verma | rohan.verma@example.com | Rohan1234@#$ | User |
| Priya Nair | priya.nair@example.com | Priya1234@#$ | User |
| Arjun Mehta | arjun.mehta@example.com | Arjun1234@#$ | User |
| Sneha Joshi | sneha.joshi@example.com | Sneha1234@#$ | User |
| Vikram Singh | vikram.singh@example.com | Vikram1234@#$ | User |
| Ananya Krishnan | ananya.krishnan@example.com | Ananya1234@#$ | User |
| Rahul Gupta | rahul.gupta@example.com | Rahul1234@#$ | User |

## Firebase Services Used (Spark Plan — Free)

| Service | Purpose | Free Tier Limits |
|---------|---------|-----------------|
| Firebase Auth | Email/password + Google sign-in | Unlimited |
| Cloud Firestore | All app data + real-time messaging | 1 GiB, 50K reads/day |
| Firebase Cloud Messaging | Push notifications | Unlimited |
| Cloudinary | Avatar, cover, post media uploads | 25 GB storage, 25 GB bandwidth/month |

## Firestore Collections

| Collection | Purpose |
|-----------|---------|
| `users/{uid}` | Auth metadata (name, email, role, isVerified) |
| `profiles/{uid}` | Full user profile (skills, bio, availability) |
| `matchPool/{uid}` | Denormalized data for matching queries |
| `usernames/{username}` | Username uniqueness enforcement |
| `connections/{id}` | Connection requests and status |
| `sessions/{id}` | Learning session bookings |
| `messages/{threadId}` | Chat threads with unread counts |
| `messages/{threadId}/msgs/{id}` | Individual messages |
| `reviews/{id}` | User reviews and ratings |
| `notifications/{uid}/items/{id}` | Per-user notifications |
| `posts/{id}` | Community discussion posts |
| `posts/{id}/replies/{id}` | Post replies |
| `circles/{id}` | Learning circles |
| `reports/{id}` | User reports |
| `calls/{id}` | WebRTC signaling (video calls) |
| `typing/{threadId}` | Typing indicators |

## Design System

- **Primary**: Emerald green (#059669)
- **Secondary**: Violet (#8B5CF6)
- **Font**: Urbanist
- **Supports**: Light mode, dark mode, and system theme

## Documentation

- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) — Step-by-step Firebase configuration guide
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) — Common issues and fixes for Flutter/Dart version mismatches

## License

This project is for educational purposes.
