// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchScoreModelImpl _$$MatchScoreModelImplFromJson(
  Map<String, dynamic> json,
) => _$MatchScoreModelImpl(
  userId: json['userId'] as String,
  profile: UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  compatibilityScore: (json['compatibilityScore'] as num).toDouble(),
  skillOverlapScore: (json['skillOverlapScore'] as num).toDouble(),
  availabilityScore: (json['availabilityScore'] as num).toDouble(),
  locationScore: (json['locationScore'] as num).toDouble(),
  languageScore: (json['languageScore'] as num).toDouble(),
  matchedSkills: MatchedSkillsModel.fromJson(
    json['matchedSkills'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$MatchScoreModelImplToJson(
  _$MatchScoreModelImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'profile': instance.profile,
  'compatibilityScore': instance.compatibilityScore,
  'skillOverlapScore': instance.skillOverlapScore,
  'availabilityScore': instance.availabilityScore,
  'locationScore': instance.locationScore,
  'languageScore': instance.languageScore,
  'matchedSkills': instance.matchedSkills,
};

_$MatchedSkillsModelImpl _$$MatchedSkillsModelImplFromJson(
  Map<String, dynamic> json,
) => _$MatchedSkillsModelImpl(
  theyTeach:
      (json['theyTeach'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  youTeach:
      (json['youTeach'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$MatchedSkillsModelImplToJson(
  _$MatchedSkillsModelImpl instance,
) => <String, dynamic>{
  'theyTeach': instance.theyTeach,
  'youTeach': instance.youTeach,
};
