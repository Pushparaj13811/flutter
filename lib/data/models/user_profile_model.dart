import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/skill_model.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    String? userId,
    required String username,
    required String email,
    required String fullName,
    String? avatar,
    String? coverImage,
    String? bio,
    String? location,
    String? timezone,
    @Default([]) List<String> languages,
    @Default([]) List<SkillModel> skillsToTeach,
    @Default([]) List<SkillModel> skillsToLearn,
    @Default([]) List<String> interests,
    required AvailabilityModel availability,
    @Default('visual') String preferredLearningStyle,
    required String joinedAt,
    required String lastActive,
    required UserStatsModel stats,
    PrivacyPreferencesModel? privacyPreferences,
    NotificationPreferencesModel? notificationPreferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
class AvailabilityModel with _$AvailabilityModel {
  const factory AvailabilityModel({
    @Default(false) bool monday,
    @Default(false) bool tuesday,
    @Default(false) bool wednesday,
    @Default(false) bool thursday,
    @Default(false) bool friday,
    @Default(false) bool saturday,
    @Default(false) bool sunday,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);
}

@freezed
class UserStatsModel with _$UserStatsModel {
  const factory UserStatsModel({
    @Default(0) int connectionsCount,
    @Default(0) int sessionsCompleted,
    @Default(0) int reviewsReceived,
    @Default(0.0) double averageRating,
  }) = _UserStatsModel;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);
}

@freezed
class PrivacyPreferencesModel with _$PrivacyPreferencesModel {
  const factory PrivacyPreferencesModel({
    @Default('public') String profileVisibility,
    @Default(false) bool showEmail,
    @Default(true) bool showLocation,
    @Default(true) bool showOnlineStatus,
    @Default('everyone') String allowMessages,
  }) = _PrivacyPreferencesModel;

  factory PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPreferencesModelFromJson(json);
}

@freezed
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const factory NotificationPreferencesModel({
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(true) bool connectionRequests,
    @Default(true) bool sessionReminders,
    @Default(true) bool newMessages,
    @Default(true) bool reviewsReceived,
    @Default(false) bool marketingEmails,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);
}
