// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateProfileDtoImpl _$$UpdateProfileDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateProfileDtoImpl(
  fullName: json['fullName'] as String?,
  bio: json['bio'] as String?,
  location: json['location'] as String?,
  timezone: json['timezone'] as String?,
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  skillsToTeach: (json['skillsToTeach'] as List<dynamic>?)
      ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  skillsToLearn: (json['skillsToLearn'] as List<dynamic>?)
      ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  interests: (json['interests'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  availability: json['availability'] == null
      ? null
      : AvailabilityModel.fromJson(
          json['availability'] as Map<String, dynamic>,
        ),
  preferredLearningStyle: json['preferredLearningStyle'] as String?,
);

Map<String, dynamic> _$$UpdateProfileDtoImplToJson(
  _$UpdateProfileDtoImpl instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'bio': instance.bio,
  'location': instance.location,
  'timezone': instance.timezone,
  'languages': instance.languages,
  'skillsToTeach': instance.skillsToTeach,
  'skillsToLearn': instance.skillsToLearn,
  'interests': instance.interests,
  'availability': instance.availability,
  'preferredLearningStyle': instance.preferredLearningStyle,
};
