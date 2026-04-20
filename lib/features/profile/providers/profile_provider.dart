import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final currentProfileProvider =
    FutureProvider<UserProfileModel>((ref) async {
  final service = ref.watch(profileFirestoreServiceProvider);
  final data = await service.getMyProfile();
  if (data == null) {
    throw Exception('Profile not found');
  }
  return UserProfileModel.fromJson(data);
});

final profileProvider =
    FutureProvider.family<UserProfileModel, String>((ref, userId) async {
  final service = ref.watch(profileFirestoreServiceProvider);
  final data = await service.getProfile(userId);
  if (data == null) {
    throw Exception('Profile not found');
  }
  return UserProfileModel.fromJson(data);
});

final allSkillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  // Skills are embedded in profiles in Firebase; return empty list as stub.
  return <SkillModel>[];
});

final skillCategoriesProvider = FutureProvider<List<String>>((ref) async {
  // Skill categories not stored separately in Firebase; return defaults.
  return <String>[
    'Programming',
    'Design',
    'Marketing',
    'Music',
    'Language',
    'Business',
    'Science',
    'Other',
  ];
});

// ── Profile Update Notifier ───────────────────────────────────────────────

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfileModel?>> {
  final ProfileFirestoreService _service;
  final Ref _ref;

  ProfileNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> updateProfile(UpdateProfileDto dto) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateProfile(dto.toJson());
      _ref.invalidate(currentProfileProvider);
      final data = await _service.getMyProfile();
      if (data != null) {
        state = AsyncValue.data(UserProfileModel.fromJson(data));
      } else {
        state = const AsyncValue.data(null);
      }
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<String?> uploadAvatar(File file) async {
    try {
      final url = await _service.uploadAvatar(file);
      _ref.invalidate(currentProfileProvider);
      return url;
    } catch (e) {
      return null;
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfileModel?>>(
  (ref) {
    final service = ref.watch(profileFirestoreServiceProvider);
    return ProfileNotifier(service, ref);
  },
);
