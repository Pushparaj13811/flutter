import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
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
  // Watch auth state so this provider re-evaluates when user logs in/out
  final authState = ref.watch(authProvider);

  // Only fetch if authenticated
  final uid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';
  if (uid.isEmpty || authState is! AuthAuthenticated) {
    throw Exception('Not authenticated');
  }

  final db = FirebaseFirestore.instance;
  final doc = await db.collection('profiles').doc(uid).get();
  if (!doc.exists) throw Exception('Profile not found');

  final data = doc.data()!;

  // Merge fullName from users collection if missing
  if (data['fullName'] == null || (data['fullName'] as String).isEmpty) {
    final userDoc = await db.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = userDoc.data()!;
      data['fullName'] = userData['name'] ?? '';
      data['email'] = userData['email'] ?? data['email'] ?? '';
      if (data['avatar'] == null) data['avatar'] = userData['avatar'];
    }
  }

  return UserProfileModel.fromMap(_sanitizeProfileData(data));
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
      // Manually build the Firestore map to avoid Freezed serialization issues
      // (null values, enum name vs value, nested model encoding).
      final data = <String, dynamic>{};
      if (dto.fullName != null) data['fullName'] = dto.fullName;
      if (dto.bio != null) data['bio'] = dto.bio;
      if (dto.location != null) data['location'] = dto.location;
      if (dto.timezone != null) data['timezone'] = dto.timezone;
      if (dto.preferredLearningStyle != null) {
        data['preferredLearningStyle'] = dto.preferredLearningStyle;
      }
      if (dto.interests != null) data['interests'] = dto.interests;
      if (dto.languages != null) data['languages'] = dto.languages;
      if (dto.skillsToTeach != null) {
        data['skillsToTeach'] = dto.skillsToTeach!.map((s) => {
          'id': s.id,
          'name': s.name,
          'category': s.category,
          'level': s.level.value,
        }).toList();
      }
      if (dto.skillsToLearn != null) {
        data['skillsToLearn'] = dto.skillsToLearn!.map((s) => {
          'id': s.id,
          'name': s.name,
          'category': s.category,
          'level': s.level.value,
        }).toList();
      }
      if (dto.availability != null) {
        data['availability'] = {
          'monday': dto.availability!.monday,
          'tuesday': dto.availability!.tuesday,
          'wednesday': dto.availability!.wednesday,
          'thursday': dto.availability!.thursday,
          'friday': dto.availability!.friday,
          'saturday': dto.availability!.saturday,
          'sunday': dto.availability!.sunday,
        };
      }

      await _service.updateProfile(data);
      _ref.invalidate(currentProfileProvider);
      final refreshed = await _service.getMyProfile();
      if (refreshed != null) {
        state = AsyncValue.data(
          UserProfileModel.fromJson(_sanitizeProfileData(refreshed)),
        );
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
