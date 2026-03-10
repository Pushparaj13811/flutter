// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_filters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchingFiltersModelImpl _$$MatchingFiltersModelImplFromJson(
  Map<String, dynamic> json,
) => _$MatchingFiltersModelImpl(
  skillCategory: json['skillCategory'] as String?,
  skillName: json['skillName'] as String?,
  location: json['location'] as String?,
  minRating: (json['minRating'] as num?)?.toDouble(),
  maxRating: (json['maxRating'] as num?)?.toDouble(),
  availability: (json['availability'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  learningStyle: json['learningStyle'] as String?,
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$MatchingFiltersModelImplToJson(
  _$MatchingFiltersModelImpl instance,
) => <String, dynamic>{
  'skillCategory': instance.skillCategory,
  'skillName': instance.skillName,
  'location': instance.location,
  'minRating': instance.minRating,
  'maxRating': instance.maxRating,
  'availability': instance.availability,
  'learningStyle': instance.learningStyle,
  'languages': instance.languages,
};
