import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      'fullName': name,
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

  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw fb.FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final uid = userCredential.user!.uid;
    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

    if (isNewUser) {
      final name = userCredential.user!.displayName ?? 'User';
      final email = userCredential.user!.email ?? '';
      final avatar = userCredential.user!.photoURL;
      final username = email.split('@').first.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

      // Create user document
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': 'user',
        'isVerified': true,
        'isActive': true,
        'avatar': avatar,
        'lastLogin': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Reserve username
      await _firestore.collection('usernames').doc(username).set({'uid': uid});

      // Create profile
      await _firestore.collection('profiles').doc(uid).set({
        'fullName': name,
        'username': username,
        'avatar': avatar,
        'coverImage': null,
        'bio': '',
        'location': '',
        'timezone': '',
        'languages': <String>[],
        'skillsToTeach': <Map<String, dynamic>>[],
        'skillsToLearn': <Map<String, dynamic>>[],
        'interests': <String>[],
        'availability': {
          'monday': false, 'tuesday': false, 'wednesday': false,
          'thursday': false, 'friday': false, 'saturday': false, 'sunday': false,
        },
        'preferredLearningStyle': 'visual',
        'stats': {
          'connectionsCount': 0, 'sessionsCompleted': 0,
          'reviewsReceived': 0, 'averageRating': 0.0,
        },
        'privacyPreferences': {
          'profileVisibility': 'public', 'showEmail': false,
          'showLocation': true, 'showOnlineStatus': true, 'allowMessages': 'everyone',
        },
        'notificationPreferences': {
          'emailNotifications': true, 'pushNotifications': true,
          'connectionRequests': true, 'sessionReminders': true,
          'newMessages': true, 'reviewsReceived': true, 'marketingEmails': false,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create matchPool entry
      await _firestore.collection('matchPool').doc(uid).set({
        'username': username,
        'avatar': avatar,
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
    } else {
      // Update last login for existing users
      await _firestore.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final data = userDoc.data()!;

    return User(
      id: uid,
      email: userCredential.user!.email ?? '',
      name: data['name'] as String? ?? userCredential.user!.displayName ?? '',
      avatar: data['avatar'] as String?,
      role: data['role'] as String? ?? 'user',
      isVerified: true,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Future<bool> isUsernameAvailable(String username) async {
    final doc = await _firestore.collection('usernames').doc(username.toLowerCase()).get();
    return !doc.exists;
  }
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
