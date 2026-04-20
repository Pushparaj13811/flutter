import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/data/sources/firebase/firebase_auth_service.dart';
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

  Future<void> signInWithGoogle() async {
    state = const AuthAuthenticating();
    try {
      final user = await _authService.signInWithGoogle();
      state = AuthAuthenticated(user: user);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'sign-in-cancelled') {
        state = const AuthUnauthenticated();
      } else {
        state = AuthError(message: _mapAuthError(e.code));
      }
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

  void refreshUser(User user) {
    state = AuthAuthenticated(user: user);
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
