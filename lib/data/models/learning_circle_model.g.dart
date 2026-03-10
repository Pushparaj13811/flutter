// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningCircleModelImpl _$$LearningCircleModelImplFromJson(
  Map<String, dynamic> json,
) => _$LearningCircleModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  creatorId: json['creatorId'] as String,
  skillFocus:
      (json['skillFocus'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  membersCount: (json['membersCount'] as num?)?.toInt() ?? 0,
  maxMembers: (json['maxMembers'] as num?)?.toInt() ?? 20,
  isJoinedByMe: json['isJoinedByMe'] as bool? ?? false,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  creator: json['creator'] == null
      ? null
      : UserProfileModel.fromJson(json['creator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$LearningCircleModelImplToJson(
  _$LearningCircleModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'creatorId': instance.creatorId,
  'skillFocus': instance.skillFocus,
  'membersCount': instance.membersCount,
  'maxMembers': instance.maxMembers,
  'isJoinedByMe': instance.isJoinedByMe,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'creator': instance.creator,
};

_$CreateCircleDtoImpl _$$CreateCircleDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateCircleDtoImpl(
  name: json['name'] as String,
  description: json['description'] as String,
  skillFocus:
      (json['skillFocus'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  maxMembers: (json['maxMembers'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$$CreateCircleDtoImplToJson(
  _$CreateCircleDtoImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'skillFocus': instance.skillFocus,
  'maxMembers': instance.maxMembers,
};
