# Firebase Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Node.js/MongoDB/Socket.IO backend with Firebase (Auth + Firestore) and Cloudinary (file uploads) — all free tier.

**Architecture:** Firebase Auth for authentication, Cloud Firestore for all data with real-time listeners for messaging, Cloudinary for file uploads. All business logic client-side. No Cloud Functions. Firestore Security Rules for access control.

**Tech Stack:** Firebase Auth, Cloud Firestore, Cloudinary, Flutter Riverpod, go_router

---

## File Structure

### Files to CREATE
```
lib/data/sources/firebase/firebase_auth_service.dart    — Firebase Auth wrapper
lib/data/sources/firebase/firestore_service.dart        — Generic Firestore helpers
lib/data/sources/firebase/profile_firestore_service.dart — Profile + matchPool
lib/data/sources/firebase/connection_firestore_service.dart
lib/data/sources/firebase/session_firestore_service.dart
lib/data/sources/firebase/messaging_firestore_service.dart
lib/data/sources/firebase/review_firestore_service.dart
lib/data/sources/firebase/notification_firestore_service.dart
lib/data/sources/firebase/community_firestore_service.dart
lib/data/sources/firebase/matching_firestore_service.dart
lib/data/sources/firebase/search_firestore_service.dart
lib/data/sources/firebase/admin_firestore_service.dart
lib/data/sources/firebase/call_firestore_service.dart
lib/data/sources/firebase/cloudinary_service.dart       — File upload to Cloudinary
lib/core/constants/cloudinary_config.dart               — Cloudinary credentials
firestore.rules                                         — Security rules
```

### Files to MODIFY
```
pubspec.yaml                              — Add firebase_auth, cloud_firestore; remove dio, fpdart, socket_io_client
lib/main.dart                             — Add Firebase.initializeApp()
lib/config/di/providers.dart              — Replace Dio providers with Firebase service providers
lib/features/auth/providers/auth_provider.dart — Use Firebase Auth streams
lib/config/router/app_router.dart         — Auth guard uses Firebase Auth state
lib/domain/entities/user.dart             — Keep as-is (already correct)
```

### Files to DELETE
```
lib/data/sources/remote/                  — All 12 remote source files
lib/core/network/auth_interceptor.dart
lib/core/network/error_interceptor.dart
lib/core/network/mock_interceptor.dart
lib/core/network/socket_service.dart
lib/core/constants/api_endpoints.dart
lib/config/env/env_config.dart
lib/data/repositories/auth_repository_impl.dart   — Replaced by Firebase service
lib/data/repositories/*_repository_impl.dart      — All replaced
lib/domain/repositories/*.dart                     — Interfaces no longer needed
```

---

## Task 1: Update pubspec.yaml and initialize Firebase

**Files:**
- Modify: `pubspec.yaml`
- Modify: `lib/main.dart`

- [ ] **Step 1: Update pubspec.yaml dependencies**

Remove these dependencies:
```yaml
  # REMOVE:
  dio: ^5.7.0
  fpdart: ^1.1.0
  socket_io_client: ^3.0.2
  flutter_secure_storage: ^9.2.4
  reactive_forms: ^18.2.2
  web_socket_channel: ^3.0.2  # already removed
```

Add these dependencies:
```yaml
  # ADD:
  firebase_auth: ^5.5.1
  cloud_firestore: ^5.6.5
  google_sign_in: ^6.2.2
  cloudinary_url_gen: ^1.6.0
  http: ^1.2.2
  crypto: ^3.0.6
```

Keep existing: `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `flutter_riverpod`, `riverpod_annotation`, `go_router`, `freezed_annotation`, `json_annotation`, `shared_preferences`, `image_picker`, `cached_network_image`, `shimmer`, `flutter_rating_bar`, `timeago`, `url_launcher`, `google_fonts`, `connectivity_plus`, `intl`, `cupertino_icons`.

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`

- [ ] **Step 3: Update main.dart with Firebase initialization**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_theme.dart';
import 'package:skill_exchange/core/widgets/connectivity_banner.dart';
import 'package:skill_exchange/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SkillExchangeApp(),
    ),
  );
}

class SkillExchangeApp extends ConsumerWidget {
  const SkillExchangeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Skill Exchange',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      routerConfig: router,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ConnectivityBanner(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/main.dart
git commit -m "feat: add Firebase packages and initialize in main.dart"
```

---

## Task 2: Create Cloudinary config and upload service

**Files:**
- Create: `lib/core/constants/cloudinary_config.dart`
- Create: `lib/data/sources/firebase/cloudinary_service.dart`

- [ ] **Step 1: Create Cloudinary config**

```dart
class CloudinaryConfig {
  CloudinaryConfig._();

  static const String cloudName = 'dqqyq68df';
  static const String apiKey = '389891321894538';
  static const String apiSecret = 'aiTdLzMx1StFoE5EarbW-KFYDok';
  static const String uploadPreset = 'skill_exchange';

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  static String get videoUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/video/upload';
}
```

- [ ] **Step 2: Create Cloudinary upload service**

```dart
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_exchange/core/constants/cloudinary_config.dart';

class CloudinaryService {
  /// Upload an image file to Cloudinary. Returns the secure URL.
  Future<String> uploadImage(File file, {String? folder}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final params = <String, String>{
      'timestamp': timestamp.toString(),
      if (folder != null) 'folder': folder,
    };

    final signature = _generateSignature(params);

    final request = http.MultipartRequest('POST', Uri.parse(CloudinaryConfig.uploadUrl));
    request.fields['api_key'] = CloudinaryConfig.apiKey;
    request.fields['timestamp'] = timestamp.toString();
    request.fields['signature'] = signature;
    if (folder != null) request.fields['folder'] = folder;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: $body');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    return json['secure_url'] as String;
  }

  /// Upload a video file to Cloudinary. Returns the secure URL.
  Future<String> uploadVideo(File file, {String? folder}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final params = <String, String>{
      'timestamp': timestamp.toString(),
      if (folder != null) 'folder': folder,
    };

    final signature = _generateSignature(params);

    final request = http.MultipartRequest('POST', Uri.parse(CloudinaryConfig.videoUploadUrl));
    request.fields['api_key'] = CloudinaryConfig.apiKey;
    request.fields['timestamp'] = timestamp.toString();
    request.fields['signature'] = signature;
    if (folder != null) request.fields['folder'] = folder;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Cloudinary video upload failed: $body');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    return json['secure_url'] as String;
  }

  String _generateSignature(Map<String, String> params) {
    final sortedKeys = params.keys.toList()..sort();
    final paramString = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    final toSign = '$paramString${CloudinaryConfig.apiSecret}';
    return sha1.convert(utf8.encode(toSign)).toString();
  }
}

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});
```

- [ ] **Step 3: Commit**

```bash
git add lib/core/constants/cloudinary_config.dart lib/data/sources/firebase/cloudinary_service.dart
git commit -m "feat: add Cloudinary config and upload service"
```

---

## Task 3: Create Firebase Auth service and rewrite auth provider

**Files:**
- Create: `lib/data/sources/firebase/firebase_auth_service.dart`
- Modify: `lib/features/auth/providers/auth_provider.dart`
- Modify: `lib/domain/entities/user.dart`

- [ ] **Step 1: Create Firebase Auth service**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/domain/entities/user.dart';

class FirebaseAuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  fb.User? get currentFirebaseUser => _auth.currentUser;
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    // Create user document
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': 'user',
      'isVerified': false,
      'isActive': true,
      'lastLogin': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Reserve username
    await _firestore.collection('usernames').doc(username.toLowerCase()).set({
      'uid': uid,
    });

    // Create empty profile
    await _firestore.collection('profiles').doc(uid).set({
      'username': username.toLowerCase(),
      'avatar': null,
      'coverImage': null,
      'bio': '',
      'location': '',
      'timezone': '',
      'languages': <String>[],
      'skillsToTeach': <Map<String, dynamic>>[],
      'skillsToLearn': <Map<String, dynamic>>[],
      'interests': <String>[],
      'availability': {
        'monday': false,
        'tuesday': false,
        'wednesday': false,
        'thursday': false,
        'friday': false,
        'saturday': false,
        'sunday': false,
      },
      'preferredLearningStyle': 'visual',
      'stats': {
        'connectionsCount': 0,
        'sessionsCompleted': 0,
        'reviewsReceived': 0,
        'averageRating': 0.0,
      },
      'privacyPreferences': {
        'profileVisibility': 'public',
        'showEmail': false,
        'showLocation': true,
        'showOnlineStatus': true,
        'allowMessages': 'everyone',
      },
      'notificationPreferences': {
        'emailNotifications': true,
        'pushNotifications': true,
        'connectionRequests': true,
        'sessionReminders': true,
        'newMessages': true,
        'reviewsReceived': true,
        'marketingEmails': false,
      },
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Create matchPool entry
    await _firestore.collection('matchPool').doc(uid).set({
      'username': username.toLowerCase(),
      'avatar': null,
      'skillsToTeach': <Map<String, dynamic>>[],
      'skillsToLearn': <Map<String, dynamic>>[],
      'availability': {
        'monday': false, 'tuesday': false, 'wednesday': false,
        'thursday': false, 'friday': false, 'saturday': false, 'sunday': false,
      },
      'location': '',
      'averageRating': 0.0,
      'sessionsCompleted': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Send email verification
    await credential.user!.sendEmailVerification();

    return User(
      id: uid,
      email: email,
      name: name,
      role: 'user',
      isVerified: false,
      isActive: true,
    );
  }

  Future<User> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    // Update last login
    await _firestore.collection('users').doc(uid).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // Fetch user doc
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final data = userDoc.data()!;

    // Check if banned
    if (data['isActive'] == false) {
      await _auth.signOut();
      throw fb.FirebaseAuthException(code: 'user-disabled', message: 'Account has been suspended');
    }

    return User(
      id: uid,
      email: email,
      name: data['name'] as String,
      avatar: data['avatar'] as String?,
      role: data['role'] as String? ?? 'user',
      isVerified: credential.user!.emailVerified,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<User?> getCurrentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;

    final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
    if (!userDoc.exists) return null;
    final data = userDoc.data()!;

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      name: data['name'] as String? ?? '',
      avatar: data['avatar'] as String?,
      role: data['role'] as String? ?? 'user',
      isVerified: fbUser.emailVerified,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser!;
    final credential = fb.EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> changeEmail(String password, String newEmail) async {
    final user = _auth.currentUser!;
    final credential = fb.EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await user.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser!;
    final credential = fb.EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await _firestore.collection('users').doc(user.uid).update({'isActive': false});
    await user.delete();
  }

  Future<bool> isUsernameAvailable(String username) async {
    final doc = await _firestore.collection('usernames').doc(username.toLowerCase()).get();
    return !doc.exists;
  }
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
```

- [ ] **Step 2: Rewrite auth_provider.dart to use Firebase**

```dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/domain/entities/user.dart';

// ── Auth State ────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
}

// ── Auth Notifier ─────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;

  AuthNotifier(this._authService) : super(const AuthInitial()) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((fbUser) async {
      if (fbUser == null) {
        state = const AuthUnauthenticated();
      } else {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          if (!user.isActive) {
            state = const AuthUnauthenticated();
            await _authService.signOut();
          } else {
            state = AuthAuthenticated(user: user);
          }
        } else {
          state = const AuthUnauthenticated();
        }
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = const AuthAuthenticating();
    try {
      final user = await _authService.signIn(email: email, password: password);
      state = AuthAuthenticated(user: user);
    } on fb.FirebaseAuthException catch (e) {
      state = AuthError(message: _mapAuthError(e.code));
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  Future<void> signup(String name, String email, String password, {String? username}) async {
    state = const AuthAuthenticating();
    try {
      final uname = username ?? email.split('@').first;
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        username: uname,
      );
      state = AuthAuthenticated(user: user);
    } on fb.FirebaseAuthException catch (e) {
      state = AuthError(message: _mapAuthError(e.code));
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = const AuthUnauthenticated();
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyEmail(String token) async {
    // Firebase handles email verification via deep links, not tokens
    // This method checks if the current user's email is now verified
    await fb.FirebaseAuth.instance.currentUser?.reload();
    return fb.FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }

  String _mapAuthError(String code) {
    return switch (code) {
      'user-not-found' => 'No account found with this email',
      'wrong-password' => 'Incorrect password',
      'invalid-credential' => 'Invalid email or password',
      'email-already-in-use' => 'An account with this email already exists',
      'weak-password' => 'Password is too weak (min 8 characters)',
      'user-disabled' => 'Account has been suspended',
      'too-many-requests' => 'Too many attempts. Please try again later',
      'invalid-email' => 'Invalid email address',
      _ => 'Authentication failed. Please try again',
    };
  }
}

// ── Provider ──────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return AuthNotifier(authService);
});
```

- [ ] **Step 3: Commit**

```bash
git add lib/data/sources/firebase/firebase_auth_service.dart lib/features/auth/providers/auth_provider.dart
git commit -m "feat: replace auth with Firebase Auth service"
```

---

## Task 4: Create all Firestore services

**Files:**
- Create: `lib/data/sources/firebase/firestore_service.dart`
- Create: `lib/data/sources/firebase/profile_firestore_service.dart`
- Create: `lib/data/sources/firebase/connection_firestore_service.dart`
- Create: `lib/data/sources/firebase/session_firestore_service.dart`
- Create: `lib/data/sources/firebase/messaging_firestore_service.dart`
- Create: `lib/data/sources/firebase/review_firestore_service.dart`
- Create: `lib/data/sources/firebase/notification_firestore_service.dart`
- Create: `lib/data/sources/firebase/community_firestore_service.dart`
- Create: `lib/data/sources/firebase/matching_firestore_service.dart`
- Create: `lib/data/sources/firebase/search_firestore_service.dart`
- Create: `lib/data/sources/firebase/admin_firestore_service.dart`
- Create: `lib/data/sources/firebase/call_firestore_service.dart`

This is a large task. Each service file follows the same pattern: uses `FirebaseFirestore.instance` directly, returns raw Maps or typed data, provides a Riverpod provider.

- [ ] **Step 1: Create base firestore_service.dart (helpers)**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Shared Firestore instance and helpers
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);

  DocumentReference<Map<String, dynamic>> doc(String path) => _db.doc(path);

  /// Generate a thread ID from two UIDs (alphabetically sorted)
  static String threadId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
```

- [ ] **Step 2: Create profile_firestore_service.dart**

```dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';

class ProfileFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary;

  ProfileFirestoreService(this._cloudinary);

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> getMyProfile() async {
    final doc = await _db.collection('profiles').doc(_uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final doc = await _db.collection('profiles').doc(uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> getProfileByUsername(String username) async {
    final usernameDoc = await _db.collection('usernames').doc(username.toLowerCase()).get();
    if (!usernameDoc.exists) return null;
    final uid = usernameDoc.data()!['uid'] as String;
    return getProfile(uid);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('profiles').doc(_uid).update(data);

    // Also update matchPool
    final matchData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (data.containsKey('skillsToTeach')) matchData['skillsToTeach'] = data['skillsToTeach'];
    if (data.containsKey('skillsToLearn')) matchData['skillsToLearn'] = data['skillsToLearn'];
    if (data.containsKey('availability')) matchData['availability'] = data['availability'];
    if (data.containsKey('location')) matchData['location'] = data['location'];
    if (data.containsKey('username')) matchData['username'] = data['username'];
    if (data.containsKey('avatar')) matchData['avatar'] = data['avatar'];

    if (matchData.length > 1) {
      await _db.collection('matchPool').doc(_uid).update(matchData);
    }
  }

  Future<String> uploadAvatar(File file) async {
    final url = await _cloudinary.uploadImage(file, folder: 'avatars');
    await _db.collection('profiles').doc(_uid).update({'avatar': url, 'updatedAt': FieldValue.serverTimestamp()});
    await _db.collection('matchPool').doc(_uid).update({'avatar': url});
    await _db.collection('users').doc(_uid).update({'avatar': url});
    return url;
  }

  Future<String> uploadCoverImage(File file) async {
    final url = await _cloudinary.uploadImage(file, folder: 'covers');
    await _db.collection('profiles').doc(_uid).update({'coverImage': url, 'updatedAt': FieldValue.serverTimestamp()});
    return url;
  }

  Future<void> removeCoverImage() async {
    await _db.collection('profiles').doc(_uid).update({'coverImage': null, 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    final doc = await _db.collection('profiles').doc(_uid).get();
    final data = doc.data();
    if (data == null) return null;
    return {
      'privacyPreferences': data['privacyPreferences'],
      'notificationPreferences': data['notificationPreferences'],
    };
  }

  Future<void> updatePreferences(Map<String, dynamic> prefs) async {
    await _db.collection('profiles').doc(_uid).update({
      ...prefs,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

final profileFirestoreServiceProvider = Provider<ProfileFirestoreService>((ref) {
  return ProfileFirestoreService(ref.watch(cloudinaryServiceProvider));
});
```

- [ ] **Step 3: Create connection_firestore_service.dart**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getMyConnections() async {
    final snap = await _db.collection('connections')
        .where('participants', arrayContains: _uid)
        .where('status', isEqualTo: 'accepted')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final snap = await _db.collection('connections')
        .where('recipient', isEqualTo: _uid)
        .where('status', isEqualTo: 'pending')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getSentRequests() async {
    final snap = await _db.collection('connections')
        .where('requester', isEqualTo: _uid)
        .where('status', isEqualTo: 'pending')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> sendRequest(String toUserId, {String? message}) async {
    await _db.collection('connections').add({
      'requester': _uid,
      'recipient': toUserId,
      'participants': [_uid, toUserId],
      'status': 'pending',
      'message': message ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeConnection(String connectionId) async {
    await _db.collection('connections').doc(connectionId).delete();
  }
}

final connectionFirestoreServiceProvider = Provider<ConnectionFirestoreService>((ref) {
  return ConnectionFirestoreService();
});
```

- [ ] **Step 4: Create session_firestore_service.dart**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getMySessions() async {
    final snap = await _db.collection('sessions')
        .where('participants', arrayContains: _uid)
        .orderBy('scheduledAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<Map<String, dynamic>?> getSession(String id) async {
    final doc = await _db.collection('sessions').doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  Future<String> bookSession(Map<String, dynamic> data) async {
    final doc = await _db.collection('sessions').add({
      ...data,
      'host': _uid,
      'participants': [_uid, data['participant']],
      'status': 'scheduled',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> cancelSession(String id) async {
    await _db.collection('sessions').doc(id).update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeSession(String id, {String? notes}) async {
    await _db.collection('sessions').doc(id).update({
      'status': 'completed',
      if (notes != null) 'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rescheduleSession(String id, DateTime newTime, int newDuration, {String? reason}) async {
    await _db.collection('sessions').doc(id).update({
      'scheduledAt': Timestamp.fromDate(newTime),
      'duration': newDuration,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

final sessionFirestoreServiceProvider = Provider<SessionFirestoreService>((ref) {
  return SessionFirestoreService();
});
```

- [ ] **Step 5: Create messaging_firestore_service.dart**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  static String getThreadId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Real-time stream of threads for current user
  Stream<QuerySnapshot<Map<String, dynamic>>> threadsStream() {
    return _db.collection('messages')
        .where('participants', arrayContains: _uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  /// Real-time stream of messages in a thread
  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(String threadId) {
    return _db.collection('messages').doc(threadId)
        .collection('msgs')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(String receiverId, String content) async {
    final threadId = getThreadId(_uid, receiverId);
    final threadRef = _db.collection('messages').doc(threadId);

    // Ensure thread exists
    final threadDoc = await threadRef.get();
    if (!threadDoc.exists) {
      await threadRef.set({
        'participants': [_uid, receiverId],
        'lastMessage': content,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount_$_uid': 0,
        'unreadCount_$receiverId': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await threadRef.update({
        'lastMessage': content,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount_$receiverId': FieldValue.increment(1),
      });
    }

    // Add message
    await threadRef.collection('msgs').add({
      'sender': _uid,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  Future<void> markThreadRead(String threadId) async {
    await _db.collection('messages').doc(threadId).update({
      'unreadCount_$_uid': 0,
    });
  }

  /// Typing indicator: set/clear
  Future<void> setTyping(String threadId, bool isTyping) async {
    final ref = _db.collection('typing').doc(threadId);
    if (isTyping) {
      await ref.set({_uid: FieldValue.serverTimestamp()}, SetOptions(merge: true));
    } else {
      await ref.update({_uid: FieldValue.delete()});
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> typingStream(String threadId) {
    return _db.collection('typing').doc(threadId).snapshots();
  }

  Future<int> getUnreadCount() async {
    final snap = await _db.collection('messages')
        .where('participants', arrayContains: _uid)
        .get();
    int count = 0;
    for (final doc in snap.docs) {
      count += (doc.data()['unreadCount_$_uid'] as int?) ?? 0;
    }
    return count;
  }
}

final messagingFirestoreServiceProvider = Provider<MessagingFirestoreService>((ref) {
  return MessagingFirestoreService();
});
```

- [ ] **Step 6: Create review_firestore_service.dart**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getReviewsForUser(String userId) async {
    final snap = await _db.collection('reviews')
        .where('toUser', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getReviewsByUser(String userId) async {
    final snap = await _db.collection('reviews')
        .where('fromUser', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<String> createReview(Map<String, dynamic> data) async {
    final doc = await _db.collection('reviews').add({
      ...data,
      'fromUser': _uid,
      'status': 'approved',
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }
}

final reviewFirestoreServiceProvider = Provider<ReviewFirestoreService>((ref) {
  return ReviewFirestoreService();
});
```

- [ ] **Step 7: Create notification_firestore_service.dart**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream() {
    return _db.collection('notifications').doc(_uid).collection('items')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<int> getUnreadCount() async {
    final snap = await _db.collection('notifications').doc(_uid).collection('items')
        .where('isRead', isEqualTo: false)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<void> markAsRead(String notifId) async {
    await _db.collection('notifications').doc(_uid).collection('items').doc(notifId).update({
      'isRead': true,
    });
  }

  Future<void> markAllAsRead() async {
    final snap = await _db.collection('notifications').doc(_uid).collection('items')
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String notifId) async {
    await _db.collection('notifications').doc(_uid).collection('items').doc(notifId).delete();
  }

  /// Helper: create a notification for a user
  Future<void> createNotification(String forUid, Map<String, dynamic> data) async {
    await _db.collection('notifications').doc(forUid).collection('items').add({
      ...data,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final notificationFirestoreServiceProvider = Provider<NotificationFirestoreService>((ref) {
  return NotificationFirestoreService();
});
```

- [ ] **Step 8: Create community_firestore_service.dart**

```dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';

class CommunityFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CommunityFirestoreService(this._cloudinary);

  // ── Posts ──
  Future<List<Map<String, dynamic>>> getPosts({String? category, int limit = 20}) async {
    Query<Map<String, dynamic>> query = _db.collection('posts')
        .where('moderationStatus', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (category != null) {
      query = _db.collection('posts')
          .where('moderationStatus', isEqualTo: 'active')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .limit(limit);
    }
    final snap = await query.get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<String> createPost(Map<String, dynamic> data) async {
    final doc = await _db.collection('posts').add({
      ...data,
      'author': _uid,
      'likesCount': 0,
      'repliesCount': 0,
      'likedBy': <String>[],
      'moderationStatus': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  Future<List<String>> uploadPostMedia(List<File> files) async {
    final urls = <String>[];
    for (final file in files) {
      final url = await _cloudinary.uploadImage(file, folder: 'posts');
      urls.add(url);
    }
    return urls;
  }

  Future<String> uploadPostVideo(File file) async {
    return _cloudinary.uploadVideo(file, folder: 'posts/videos');
  }

  // ── Likes ──
  Future<void> likePost(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'likedBy': FieldValue.arrayUnion([_uid]),
      'likesCount': FieldValue.increment(1),
    });
  }

  Future<void> unlikePost(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'likedBy': FieldValue.arrayRemove([_uid]),
      'likesCount': FieldValue.increment(-1),
    });
  }

  bool hasUserLiked(Map<String, dynamic> postData) {
    final likedBy = (postData['likedBy'] as List?)?.cast<String>() ?? [];
    return likedBy.contains(_uid);
  }

  // ── Replies ──
  Future<List<Map<String, dynamic>>> getPostReplies(String postId) async {
    final snap = await _db.collection('posts').doc(postId).collection('replies')
        .orderBy('createdAt', descending: false)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> createReply(String postId, Map<String, dynamic> data) async {
    await _db.collection('posts').doc(postId).collection('replies').add({
      ...data,
      'author': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('posts').doc(postId).update({
      'repliesCount': FieldValue.increment(1),
    });
  }

  // ── Circles ──
  Future<List<Map<String, dynamic>>> getCircles() async {
    final snap = await _db.collection('circles').get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<String> createCircle(Map<String, dynamic> data) async {
    final doc = await _db.collection('circles').add({
      ...data,
      'createdBy': _uid,
      'members': [_uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> joinCircle(String circleId) async {
    await _db.collection('circles').doc(circleId).update({
      'members': FieldValue.arrayUnion([_uid]),
    });
  }

  Future<void> leaveCircle(String circleId) async {
    await _db.collection('circles').doc(circleId).update({
      'members': FieldValue.arrayRemove([_uid]),
    });
  }

  bool isMember(Map<String, dynamic> circleData) {
    final members = (circleData['members'] as List?)?.cast<String>() ?? [];
    return members.contains(_uid);
  }

  // ── Leaderboard ──
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    final snap = await _db.collection('matchPool')
        .orderBy('sessionsCompleted', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }
}

final communityFirestoreServiceProvider = Provider<CommunityFirestoreService>((ref) {
  return CommunityFirestoreService(ref.watch(cloudinaryServiceProvider));
});
```

- [ ] **Step 9: Create matching_firestore_service.dart and search_firestore_service.dart**

```dart
// matching_firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchingFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getSuggestions() async {
    // Get current user's skills to learn
    final myProfile = await _db.collection('profiles').doc(_uid).get();
    final mySkillsToLearn = (myProfile.data()?['skillsToLearn'] as List?) ?? [];
    final wantedCategories = mySkillsToLearn.map((s) => (s as Map)['category'] as String).toSet();

    // Query matchPool excluding self
    final snap = await _db.collection('matchPool')
        .limit(50)
        .get();

    final results = <Map<String, dynamic>>[];
    for (final doc in snap.docs) {
      if (doc.id == _uid) continue;
      final data = doc.data();
      final theirSkillsToTeach = (data['skillsToTeach'] as List?) ?? [];
      final theirCategories = theirSkillsToTeach.map((s) => (s as Map)['category'] as String).toSet();

      // Simple overlap score
      final overlap = wantedCategories.intersection(theirCategories).length;
      if (overlap > 0) {
        results.add({'id': doc.id, ...data, 'score': overlap});
      }
    }

    results.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return results.take(20).toList();
  }
}

final matchingFirestoreServiceProvider = Provider<MatchingFirestoreService>((ref) {
  return MatchingFirestoreService();
});
```

```dart
// search_firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> searchUsers({
    String? query,
    String? skillCategory,
    String? location,
    int limit = 20,
  }) async {
    // Firestore doesn't support full-text search, so we fetch and filter client-side
    Query<Map<String, dynamic>> q = _db.collection('matchPool').limit(100);

    final snap = await q.get();
    var results = snap.docs
        .where((d) => d.id != _uid)
        .map((d) => {'id': d.id, ...d.data()})
        .toList();

    // Client-side filtering
    if (query != null && query.isNotEmpty) {
      final lq = query.toLowerCase();
      results = results.where((r) {
        final username = (r['username'] as String? ?? '').toLowerCase();
        final skills = [
          ...((r['skillsToTeach'] as List?) ?? []),
          ...((r['skillsToLearn'] as List?) ?? []),
        ];
        final skillNames = skills.map((s) => ((s as Map)['name'] as String? ?? '').toLowerCase());
        return username.contains(lq) || skillNames.any((n) => n.contains(lq));
      }).toList();
    }

    if (skillCategory != null) {
      results = results.where((r) {
        final skills = [...((r['skillsToTeach'] as List?) ?? []), ...((r['skillsToLearn'] as List?) ?? [])];
        return skills.any((s) => (s as Map)['category'] == skillCategory);
      }).toList();
    }

    if (location != null && location.isNotEmpty) {
      final ll = location.toLowerCase();
      results = results.where((r) => ((r['location'] as String?) ?? '').toLowerCase().contains(ll)).toList();
    }

    return results.take(limit).toList();
  }
}

final searchFirestoreServiceProvider = Provider<SearchFirestoreService>((ref) {
  return SearchFirestoreService();
});
```

- [ ] **Step 10: Create admin_firestore_service.dart**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getStats() async {
    final users = await _db.collection('users').count().get();
    final sessions = await _db.collection('sessions').where('status', isEqualTo: 'completed').count().get();
    final connections = await _db.collection('connections').where('status', isEqualTo: 'accepted').count().get();
    return {
      'totalUsers': users.count ?? 0,
      'totalSessions': sessions.count ?? 0,
      'totalConnections': connections.count ?? 0,
    };
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snap = await _db.collection('users').get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> banUser(String uid) async {
    await _db.collection('users').doc(uid).update({'isActive': false});
  }

  Future<void> unbanUser(String uid) async {
    await _db.collection('users').doc(uid).update({'isActive': true});
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _db.collection('users').doc(uid).update({'role': role});
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
    await _db.collection('profiles').doc(uid).delete();
    await _db.collection('matchPool').doc(uid).delete();
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final snap = await _db.collection('reports').orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    await _db.collection('reports').doc(id).update(data);
  }

  Future<void> moderatePost(String postId, String status, {String? reason}) async {
    await _db.collection('posts').doc(postId).update({
      'moderationStatus': status,
      if (reason != null) 'moderationReason': reason,
    });
  }

  Future<void> deleteReview(String reviewId) async {
    await _db.collection('reviews').doc(reviewId).delete();
  }
}

final adminFirestoreServiceProvider = Provider<AdminFirestoreService>((ref) {
  return AdminFirestoreService();
});
```

- [ ] **Step 11: Create call_firestore_service.dart (WebRTC signaling)**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  /// Create a call document (caller initiates)
  Future<String> createCall(String calleeUid) async {
    final doc = await _db.collection('calls').add({
      'caller': _uid,
      'callee': calleeUid,
      'status': 'ringing',
      'offer': null,
      'answer': null,
      'callerCandidates': <Map<String, dynamic>>[],
      'calleeCandidates': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
      'endedAt': null,
    });
    return doc.id;
  }

  /// Listen for incoming calls
  Stream<QuerySnapshot<Map<String, dynamic>>> incomingCallsStream() {
    return _db.collection('calls')
        .where('callee', isEqualTo: _uid)
        .where('status', isEqualTo: 'ringing')
        .snapshots();
  }

  /// Listen for call document changes
  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream(String callId) {
    return _db.collection('calls').doc(callId).snapshots();
  }

  Future<void> setOffer(String callId, Map<String, dynamic> offer) async {
    await _db.collection('calls').doc(callId).update({'offer': offer});
  }

  Future<void> setAnswer(String callId, Map<String, dynamic> answer) async {
    await _db.collection('calls').doc(callId).update({
      'answer': answer,
      'status': 'active',
    });
  }

  Future<void> addCallerCandidate(String callId, Map<String, dynamic> candidate) async {
    await _db.collection('calls').doc(callId).update({
      'callerCandidates': FieldValue.arrayUnion([candidate]),
    });
  }

  Future<void> addCalleeCandidate(String callId, Map<String, dynamic> candidate) async {
    await _db.collection('calls').doc(callId).update({
      'calleeCandidates': FieldValue.arrayUnion([candidate]),
    });
  }

  Future<void> endCall(String callId) async {
    await _db.collection('calls').doc(callId).update({
      'status': 'ended',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> declineCall(String callId) async {
    await _db.collection('calls').doc(callId).update({
      'status': 'declined',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }
}

final callFirestoreServiceProvider = Provider<CallFirestoreService>((ref) {
  return CallFirestoreService();
});
```

- [ ] **Step 12: Commit all services**

```bash
git add lib/data/sources/firebase/
git commit -m "feat: add all Firestore services (profile, connections, sessions, messaging, reviews, notifications, community, matching, search, admin, calls)"
```

---

## Task 5: Rewrite providers.dart (DI container)

**Files:**
- Modify: `lib/config/di/providers.dart`

- [ ] **Step 1: Replace entire providers.dart**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/data/sources/firebase/firebase_auth_service.dart';
import 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';
import 'package:skill_exchange/data/sources/firebase/profile_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/connection_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/session_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/messaging_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/review_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/notification_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/community_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/matching_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/search_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/admin_firestore_service.dart';
import 'package:skill_exchange/data/sources/firebase/call_firestore_service.dart';

// Re-export all service providers for convenience
export 'package:skill_exchange/data/sources/firebase/firebase_auth_service.dart';
export 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';
export 'package:skill_exchange/data/sources/firebase/profile_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/connection_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/session_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/messaging_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/review_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/notification_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/community_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/matching_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/search_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/admin_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/call_firestore_service.dart';

// ── Local Storage ─────────────────────────────────────────────────────────

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a real instance.',
  );
});
```

- [ ] **Step 2: Commit**

```bash
git add lib/config/di/providers.dart
git commit -m "feat: replace Dio-based DI container with Firebase service providers"
```

---

## Task 6: Delete old files and fix compilation

**Files:**
- Delete: All files in `lib/data/sources/remote/`
- Delete: `lib/core/network/auth_interceptor.dart`
- Delete: `lib/core/network/error_interceptor.dart`
- Delete: `lib/core/network/mock_interceptor.dart`
- Delete: `lib/core/network/socket_service.dart`
- Delete: `lib/core/constants/api_endpoints.dart`
- Delete: `lib/config/env/env_config.dart`
- Delete: All files in `lib/data/repositories/`
- Delete: All files in `lib/domain/repositories/`

- [ ] **Step 1: Delete old remote sources, network, repositories**

```bash
rm -rf lib/data/sources/remote/
rm -f lib/core/network/auth_interceptor.dart
rm -f lib/core/network/error_interceptor.dart
rm -f lib/core/network/mock_interceptor.dart
rm -f lib/core/network/socket_service.dart
rm -f lib/core/constants/api_endpoints.dart
rm -f lib/config/env/env_config.dart
rm -rf lib/data/repositories/
rm -rf lib/domain/repositories/
```

- [ ] **Step 2: Fix all compilation errors**

After deleting, many feature providers/screens will have broken imports. The main fixes needed:

1. All feature providers that import from `domain/repositories/` or `config/di/providers.dart` need to be updated to import Firebase services directly
2. Remove any `import 'package:fpdart/fpdart.dart'` and `import 'package:dio/dio.dart'`
3. Feature providers that used `Either<Failure, T>` patterns need to switch to try/catch

This is the most labor-intensive step. Go through `flutter analyze lib/` errors and fix each one:
- Update each feature provider to use the corresponding Firebase service instead of the old repository
- Replace `result.fold(...)` patterns with try/catch
- Update imports

- [ ] **Step 3: Run flutter analyze until 0 errors**

Run: `flutter analyze lib/`
Fix errors iteratively.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: remove old Dio/repository layer, fix all imports for Firebase"
```

---

## Task 7: Create Firestore security rules

**Files:**
- Create: `firestore.rules`

- [ ] **Step 1: Create security rules file**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(uid) {
      return request.auth.uid == uid;
    }

    function isAdmin() {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    // Users
    match /users/{uid} {
      allow read: if isAuthenticated();
      allow create: if isOwner(uid);
      allow update: if isOwner(uid) || isAdmin();
      allow delete: if isAdmin();
    }

    // Usernames (lookup)
    match /usernames/{username} {
      allow read: if true;
      allow create: if isAuthenticated();
      allow delete: if isAdmin();
    }

    // Profiles
    match /profiles/{uid} {
      allow read: if isAuthenticated();
      allow write: if isOwner(uid);
    }

    // Match Pool
    match /matchPool/{uid} {
      allow read: if isAuthenticated();
      allow write: if isOwner(uid);
    }

    // Connections
    match /connections/{id} {
      allow read: if isAuthenticated() && request.auth.uid in resource.data.participants;
      allow create: if isAuthenticated() && request.auth.uid == request.resource.data.requester;
      allow update: if isAuthenticated() && request.auth.uid in resource.data.participants;
      allow delete: if isAuthenticated() && (request.auth.uid in resource.data.participants || isAdmin());
    }

    // Sessions
    match /sessions/{id} {
      allow read: if isAuthenticated() && request.auth.uid in resource.data.participants;
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && request.auth.uid in resource.data.participants;
      allow delete: if isAdmin();
    }

    // Messages (threads)
    match /messages/{threadId} {
      allow read: if isAuthenticated() && request.auth.uid in resource.data.participants;
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && request.auth.uid in resource.data.participants;

      match /msgs/{msgId} {
        allow read: if isAuthenticated() &&
          request.auth.uid in get(/databases/$(database)/documents/messages/$(threadId)).data.participants;
        allow create: if isAuthenticated() &&
          request.auth.uid in get(/databases/$(database)/documents/messages/$(threadId)).data.participants;
      }
    }

    // Typing indicators
    match /typing/{threadId} {
      allow read, write: if isAuthenticated();
    }

    // Reviews
    match /reviews/{id} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == request.resource.data.fromUser;
      allow update, delete: if isAdmin();
    }

    // Notifications
    match /notifications/{uid}/items/{notifId} {
      allow read: if isOwner(uid);
      allow create: if isAuthenticated();
      allow update, delete: if isOwner(uid);
    }

    // Posts
    match /posts/{id} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && (request.auth.uid == resource.data.author || isAdmin());
      allow delete: if isAuthenticated() && (request.auth.uid == resource.data.author || isAdmin());

      match /replies/{replyId} {
        allow read: if isAuthenticated();
        allow create: if isAuthenticated();
        allow delete: if isAdmin();
      }
    }

    // Circles
    match /circles/{id} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAuthenticated();
      allow delete: if isAdmin();
    }

    // Reports
    match /reports/{id} {
      allow create: if isAuthenticated() && request.auth.uid == request.resource.data.reporter;
      allow read, update: if isAdmin();
    }

    // Calls (WebRTC signaling)
    match /calls/{id} {
      allow read: if isAuthenticated() &&
        (request.auth.uid == resource.data.caller || request.auth.uid == resource.data.callee);
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() &&
        (request.auth.uid == resource.data.caller || request.auth.uid == resource.data.callee);
    }

    // Leaderboard (public read from matchPool, no separate collection needed)
  }
}
```

- [ ] **Step 2: Deploy rules**

Run: `firebase deploy --only firestore:rules`

- [ ] **Step 3: Commit**

```bash
git add firestore.rules
git commit -m "feat: add Firestore security rules"
```

---

## Task 8: Final verification and cleanup

- [ ] **Step 1: Run flutter analyze**

Run: `flutter analyze lib/`
Expected: 0 errors

- [ ] **Step 2: Run flutter build (dry-run)**

Run: `flutter build apk --debug 2>&1 | tail -5`
Expected: BUILD SUCCESSFUL

- [ ] **Step 3: Final commit if needed**

```bash
git add -A
git commit -m "fix: final cleanup after Firebase migration"
```

---

## Summary

| Task | What | Key Files |
|------|------|-----------|
| 1 | Packages + Firebase init | pubspec.yaml, main.dart |
| 2 | Cloudinary service | cloudinary_config.dart, cloudinary_service.dart |
| 3 | Firebase Auth service + auth provider | firebase_auth_service.dart, auth_provider.dart |
| 4 | All 12 Firestore services | data/sources/firebase/*.dart |
| 5 | Rewrite DI container | providers.dart |
| 6 | Delete old code + fix compilation | Remove remote/, repositories/, network/ |
| 7 | Firestore security rules | firestore.rules |
| 8 | Final verification | Build check |
