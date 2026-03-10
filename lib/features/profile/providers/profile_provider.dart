import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/data/repositories/profile_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/profile_remote_source.dart';
import 'package:skill_exchange/domain/repositories/profile_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  return ProfileRemoteSource(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final currentProfileProvider =
    FutureProvider<UserProfileModel>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getCurrentProfile();
  return result.fold(
    (failure) => throw failure,
    (profile) => profile,
  );
});

final profileProvider =
    FutureProvider.family<UserProfileModel, String>((ref, userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getProfile(userId);
  return result.fold(
    (failure) => throw failure,
    (profile) => profile,
  );
});

final allSkillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getAllSkills();
  return result.fold(
    (failure) => throw failure,
    (skills) => skills,
  );
});

final skillCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final result = await repo.getSkillCategories();
  return result.fold(
    (failure) => throw failure,
    (categories) => categories,
  );
});

// ── Profile Update Notifier ───────────────────────────────────────────────

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfileModel?>> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> updateProfile(UpdateProfileDto dto) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateProfile(dto);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (profile) {
        state = AsyncValue.data(profile);
        _ref.invalidate(currentProfileProvider);
        return true;
      },
    );
  }

  Future<String?> uploadAvatar(File file) async {
    final result = await _repository.uploadAvatar(file);
    return result.fold(
      (failure) => null,
      (url) {
        _ref.invalidate(currentProfileProvider);
        return url;
      },
    );
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfileModel?>>(
  (ref) {
    final repo = ref.watch(profileRepositoryProvider);
    return ProfileNotifier(repo, ref);
  },
);
