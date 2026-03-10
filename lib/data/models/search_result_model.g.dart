// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchFiltersModelImpl _$$SearchFiltersModelImplFromJson(
  Map<String, dynamic> json,
) => _$SearchFiltersModelImpl(
  query: json['query'] as String?,
  skillCategory: json['skillCategory'] as String?,
  skillName: json['skillName'] as String?,
  location: json['location'] as String?,
  minRating: (json['minRating'] as num?)?.toDouble(),
  maxRating: (json['maxRating'] as num?)?.toDouble(),
  availability: json['availability'] as String?,
  learningStyle: json['learningStyle'] as String?,
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$SearchFiltersModelImplToJson(
  _$SearchFiltersModelImpl instance,
) => <String, dynamic>{
  'query': instance.query,
  'skillCategory': instance.skillCategory,
  'skillName': instance.skillName,
  'location': instance.location,
  'minRating': instance.minRating,
  'maxRating': instance.maxRating,
  'availability': instance.availability,
  'learningStyle': instance.learningStyle,
  'languages': instance.languages,
};

_$SearchResultModelImpl _$$SearchResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$SearchResultModelImpl(
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$$SearchResultModelImplToJson(
  _$SearchResultModelImpl instance,
) => <String, dynamic>{
  'users': instance.users,
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
