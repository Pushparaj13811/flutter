import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/config/env/env_config.dart';
import 'package:skill_exchange/core/network/auth_interceptor.dart';
import 'package:skill_exchange/core/network/error_interceptor.dart';
import 'package:skill_exchange/core/network/mock_interceptor.dart';
import 'package:skill_exchange/data/repositories/auth_repository_impl.dart';
import 'package:skill_exchange/data/sources/local/preferences_source.dart';
import 'package:skill_exchange/data/sources/local/secure_storage_source.dart';
import 'package:skill_exchange/data/sources/remote/auth_remote_source.dart';
import 'package:skill_exchange/domain/repositories/auth_repository.dart';

// ── Local Storage ─────────────────────────────────────────────────────────

final secureStorageSourceProvider = Provider<SecureStorageSource>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return SecureStorageSource(storage);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // Must be overridden in ProviderScope at app startup.
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a real instance.',
  );
});

final preferencesSourceProvider = Provider<PreferencesSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesSource(prefs);
});

// ── Networking ────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: EnvConfig.apiTimeoutSeconds),
      receiveTimeout: const Duration(seconds: EnvConfig.apiTimeoutSeconds),
      sendTimeout: const Duration(seconds: EnvConfig.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final authInterceptor = AuthInterceptor(
    storage: ref.read(secureStorageSourceProvider),
    dio: dio,
  );

  // In mock mode, the MockInterceptor short-circuits all requests with fake
  // data so no real HTTP calls are made. Add it FIRST so it resolves before
  // auth/error interceptors run.
  if (EnvConfig.enableMockData) {
    dio.interceptors.add(MockInterceptor());
  }

  dio.interceptors.addAll([
    if (!EnvConfig.enableMockData) authInterceptor,
    if (!EnvConfig.enableMockData) ErrorInterceptor(),
    if (kDebugMode)
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => developer.log(obj.toString(), name: 'Dio'),
      ),
  ]);

  return dio;
});

// ── Remote Sources ────────────────────────────────────────────────────────

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSource(ref.watch(dioProvider));
});

// ── Repositories ──────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteSourceProvider),
    ref.watch(secureStorageSourceProvider),
  );
});
