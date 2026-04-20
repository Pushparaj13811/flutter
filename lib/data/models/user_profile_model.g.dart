// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  username: json['username'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  avatar: json['avatar'] as String?,
  coverImage: json['coverImage'] as String?,
  bio: json['bio'] as String?,
  location: json['location'] as String?,
  timezone: json['timezone'] as String?,
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  skillsToTeach:
      (json['skillsToTeach'] as List<dynamic>?)
          ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  skillsToLearn:
      (json['skillsToLearn'] as List<dynamic>?)
          ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  availability: AvailabilityModel.fromJson(
    json['availability'] as Map<String, dynamic>,
  ),
  preferredLearningStyle: json['preferredLearningStyle'] as String? ?? 'visual',
  joinedAt: json['joinedAt'] as String,
  lastActive: json['lastActive'] as String,
  stats: UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
  privacyPreferences: json['privacyPreferences'] == null
      ? null
      : PrivacyPreferencesModel.fromJson(
          json['privacyPreferences'] as Map<String, dynamic>,
        ),
  notificationPreferences: json['notificationPreferences'] == null
      ? null
      : NotificationPreferencesModel.fromJson(
          json['notificationPreferences'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$UserProfileModelImplToJson(
  _$UserProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'username': instance.username,
  'email': instance.email,
  'fullName': instance.fullName,
  'avatar': instance.avatar,
  'coverImage': instance.coverImage,
  'bio': instance.bio,
  'location': instance.location,
  'timezone': instance.timezone,
  'languages': instance.languages,
  'skillsToTeach': instance.skillsToTeach,
  'skillsToLearn': instance.skillsToLearn,
  'interests': instance.interests,
  'availability': instance.availability,
  'preferredLearningStyle': instance.preferredLearningStyle,
  'joinedAt': instance.joinedAt,
  'lastActive': instance.lastActive,
  'stats': instance.stats,
  'privacyPreferences': instance.privacyPreferences,
  'notificationPreferences': instance.notificationPreferences,
};

_$AvailabilityModelImpl _$$AvailabilityModelImplFromJson(
  Map<String, dynamic> json,
) => _$AvailabilityModelImpl(
  monday: json['monday'] as bool? ?? false,
  tuesday: json['tuesday'] as bool? ?? false,
  wednesday: json['wednesday'] as bool? ?? false,
  thursday: json['thursday'] as bool? ?? false,
  friday: json['friday'] as bool? ?? false,
  saturday: json['saturday'] as bool? ?? false,
  sunday: json['sunday'] as bool? ?? false,
);

Map<String, dynamic> _$$AvailabilityModelImplToJson(
  _$AvailabilityModelImpl instance,
) => <String, dynamic>{
  'monday': instance.monday,
  'tuesday': instance.tuesday,
  'wednesday': instance.wednesday,
  'thursday': instance.thursday,
  'friday': instance.friday,
  'saturday': instance.saturday,
  'sunday': instance.sunday,
};

_$UserStatsModelImpl _$$UserStatsModelImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsModelImpl(
      connectionsCount: (json['connectionsCount'] as num?)?.toInt() ?? 0,
      sessionsCompleted: (json['sessionsCompleted'] as num?)?.toInt() ?? 0,
      reviewsReceived: (json['reviewsReceived'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$UserStatsModelImplToJson(
  _$UserStatsModelImpl instance,
) => <String, dynamic>{
  'connectionsCount': instance.connectionsCount,
  'sessionsCompleted': instance.sessionsCompleted,
  'reviewsReceived': instance.reviewsReceived,
  'averageRating': instance.averageRating,
};

_$PrivacyPreferencesModelImpl _$$PrivacyPreferencesModelImplFromJson(
  Map<String, dynamic> json,
) => _$PrivacyPreferencesModelImpl(
  profileVisibility: json['profileVisibility'] as String? ?? 'public',
  showEmail: json['showEmail'] as bool? ?? false,
  showLocation: json['showLocation'] as bool? ?? true,
  showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
  allowMessages: json['allowMessages'] as String? ?? 'everyone',
);

Map<String, dynamic> _$$PrivacyPreferencesModelImplToJson(
  _$PrivacyPreferencesModelImpl instance,
) => <String, dynamic>{
  'profileVisibility': instance.profileVisibility,
  'showEmail': instance.showEmail,
  'showLocation': instance.showLocation,
  'showOnlineStatus': instance.showOnlineStatus,
  'allowMessages': instance.allowMessages,
};

_$NotificationPreferencesModelImpl _$$NotificationPreferencesModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationPreferencesModelImpl(
  emailNotifications: json['emailNotifications'] as bool? ?? true,
  pushNotifications: json['pushNotifications'] as bool? ?? true,
  connectionRequests: json['connectionRequests'] as bool? ?? true,
  sessionReminders: json['sessionReminders'] as bool? ?? true,
  newMessages: json['newMessages'] as bool? ?? true,
  reviewsReceived: json['reviewsReceived'] as bool? ?? true,
  marketingEmails: json['marketingEmails'] as bool? ?? false,
);

Map<String, dynamic> _$$NotificationPreferencesModelImplToJson(
  _$NotificationPreferencesModelImpl instance,
) => <String, dynamic>{
  'emailNotifications': instance.emailNotifications,
  'pushNotifications': instance.pushNotifications,
  'connectionRequests': instance.connectionRequests,
  'sessionReminders': instance.sessionReminders,
  'newMessages': instance.newMessages,
  'reviewsReceived': instance.reviewsReceived,
  'marketingEmails': instance.marketingEmails,
};
