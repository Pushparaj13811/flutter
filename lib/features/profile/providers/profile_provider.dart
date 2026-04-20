import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

// ── Helpers ───────────────────────────────────────────────────────────────

/// Sanitizes raw Firestore data so that required fields in [UserProfileModel]
/// never receive null values. This prevents "type 'Null' is not a subtype of
/// type 'String' in type cast" errors when a profile document has missing or
/// incomplete fields (e.g. freshly-created user).
/// Converts a Firestore Timestamp or other value to an ISO 8601 string.
String _toIsoString(dynamic value) {
  if (value == null) return DateTime.now().toIso8601String();
  if (value is String) return value;
  // Firestore Timestamp has a toDate() method
  if (value.runtimeType.toString().contains('Timestamp')) {
    try {
      return (value as dynamic).toDate().toIso8601String() as String;
    } catch (_) {}
  }
  return DateTime.now().toIso8601String();
}

Map<String, dynamic> _sanitizeProfileData(Map<String, dynamic> raw) {
  final uid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';

  return <String, dynamic>{
    ...raw,
    'id': raw['id'] ?? raw['uid'] ?? uid,
    'username': raw['username'] ?? raw['email']?.toString().split('@').first ?? '',
    'email': raw['email'] ?? '',
    'fullName': raw['fullName'] ?? raw['name'] ?? raw['displayName'] ?? '',
    'joinedAt': _toIsoString(raw['joinedAt'] ?? raw['createdAt']),
    'lastActive': _toIsoString(raw['lastActive'] ?? raw['updatedAt']),
    'availability': raw['availability'] ?? <String, dynamic>{},
    'stats': raw['stats'] ?? <String, dynamic>{},
  };
}

// ── Data Providers ────────────────────────────────────────────────────────

final currentProfileProvider =
    FutureProvider<UserProfileModel>((ref) async {
  final service = ref.watch(profileFirestoreServiceProvider);
  final data = await service.getMyProfile();
  if (data == null) {
    throw Exception('Profile not found');
  }
  return UserProfileModel.fromJson(_sanitizeProfileData(data));
});

final profileProvider =
    FutureProvider.family<UserProfileModel, String>((ref, userId) async {
  final service = ref.watch(profileFirestoreServiceProvider);
  final data = await service.getProfile(userId);
  if (data == null) {
    throw Exception('Profile not found');
  }
  return UserProfileModel.fromJson(_sanitizeProfileData(data));
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
        state = AsyncValue.data(UserProfileModel.fromJson(_sanitizeProfileData(data)));
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
