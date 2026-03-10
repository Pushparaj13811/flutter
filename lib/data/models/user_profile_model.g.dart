// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileModelImpl(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  avatar: json['avatar'] as String?,
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
);

Map<String, dynamic> _$$UserProfileModelImplToJson(
  _$UserProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'fullName': instance.fullName,
  'avatar': instance.avatar,
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
