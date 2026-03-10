import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/domain/entities/user.dart';
import 'package:skill_exchange/domain/repositories/auth_repository.dart';

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
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    state = const AuthAuthenticating();
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) => state = const AuthUnauthenticated(),
      (user) => state = AuthAuthenticated(user: user),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AuthAuthenticating();
    final result = await _repository.login(email, password);
    result.fold(
      (failure) => state = AuthError(message: failure.message),
      (user) => state = AuthAuthenticated(user: user),
    );
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AuthAuthenticating();
    final result = await _repository.signup(name, email, password);
    result.fold(
      (failure) => state = AuthError(message: failure.message),
      (user) => state = AuthAuthenticated(user: user),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthUnauthenticated();
  }

  Future<bool> forgotPassword(String email) async {
    final result = await _repository.forgotPassword(email);
    return result.isRight();
  }

  Future<bool> verifyEmail(String token) async {
    final result = await _repository.verifyEmail(token);
    return result.isRight();
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
