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
import 'package:skill_exchange/data/repositories/admin_repository_impl.dart';
import 'package:skill_exchange/data/repositories/auth_repository_impl.dart';
import 'package:skill_exchange/data/repositories/community_repository_impl.dart';
import 'package:skill_exchange/data/repositories/connection_repository_impl.dart';
import 'package:skill_exchange/data/repositories/matching_repository_impl.dart';
import 'package:skill_exchange/data/repositories/messaging_repository_impl.dart';
import 'package:skill_exchange/data/repositories/notification_repository_impl.dart';
import 'package:skill_exchange/data/repositories/profile_repository_impl.dart';
import 'package:skill_exchange/data/repositories/review_repository_impl.dart';
import 'package:skill_exchange/data/repositories/search_repository_impl.dart';
import 'package:skill_exchange/data/repositories/session_repository_impl.dart';
import 'package:skill_exchange/data/sources/local/preferences_source.dart';
import 'package:skill_exchange/data/sources/local/secure_storage_source.dart';
import 'package:skill_exchange/data/sources/remote/admin_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/auth_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/community_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/connection_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/matching_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/messaging_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/notification_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/profile_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/report_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/review_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/search_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/session_remote_source.dart';
import 'package:skill_exchange/domain/repositories/admin_repository.dart';
import 'package:skill_exchange/domain/repositories/auth_repository.dart';
import 'package:skill_exchange/domain/repositories/community_repository.dart';
import 'package:skill_exchange/domain/repositories/connection_repository.dart';
import 'package:skill_exchange/domain/repositories/matching_repository.dart';
import 'package:skill_exchange/domain/repositories/messaging_repository.dart';
import 'package:skill_exchange/domain/repositories/notification_repository.dart';
import 'package:skill_exchange/domain/repositories/profile_repository.dart';
import 'package:skill_exchange/domain/repositories/review_repository.dart';
import 'package:skill_exchange/domain/repositories/search_repository.dart';
import 'package:skill_exchange/domain/repositories/session_repository.dart';

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

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  return ProfileRemoteSource(ref.watch(dioProvider));
});

final connectionRemoteSourceProvider = Provider<ConnectionRemoteSource>((ref) {
  return ConnectionRemoteSource(ref.watch(dioProvider));
});

final sessionRemoteSourceProvider = Provider<SessionRemoteSource>((ref) {
  return SessionRemoteSource(ref.watch(dioProvider));
});

final messagingRemoteSourceProvider = Provider<MessagingRemoteSource>((ref) {
  return MessagingRemoteSource(ref.watch(dioProvider));
});

final reviewRemoteSourceProvider = Provider<ReviewRemoteSource>((ref) {
  return ReviewRemoteSource(ref.watch(dioProvider));
});

final notificationRemoteSourceProvider =
    Provider<NotificationRemoteSource>((ref) {
  return NotificationRemoteSource(ref.watch(dioProvider));
});

final matchingRemoteSourceProvider = Provider<MatchingRemoteSource>((ref) {
  return MatchingRemoteSource(ref.watch(dioProvider));
});

final searchRemoteSourceProvider = Provider<SearchRemoteSource>((ref) {
  return SearchRemoteSource(ref.watch(dioProvider));
});

final communityRemoteSourceProvider = Provider<CommunityRemoteSource>((ref) {
  return CommunityRemoteSource(ref.watch(dioProvider));
});

final adminRemoteSourceProvider = Provider<AdminRemoteSource>((ref) {
  return AdminRemoteSource(ref.watch(dioProvider));
});

final reportRemoteSourceProvider = Provider<ReportRemoteSource>((ref) {
  return ReportRemoteSource(ref.watch(dioProvider));
});

// ── Repositories ──────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteSourceProvider),
    ref.watch(secureStorageSourceProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteSourceProvider));
});

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  return ConnectionRepositoryImpl(ref.watch(connectionRemoteSourceProvider));
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(ref.watch(sessionRemoteSourceProvider));
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.watch(messagingRemoteSourceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteSourceProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
      ref.watch(notificationRemoteSourceProvider));
});

final matchingRepositoryProvider = Provider<MatchingRepository>((ref) {
  return MatchingRepositoryImpl(ref.watch(matchingRemoteSourceProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.watch(searchRemoteSourceProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(ref.watch(communityRemoteSourceProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(adminRemoteSourceProvider));
});
