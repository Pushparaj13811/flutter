// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillModelImpl _$$SkillModelImplFromJson(Map<String, dynamic> json) =>
    _$SkillModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      level: $enumDecode(_$SkillLevelEnumMap, json['level']),
    );

Map<String, dynamic> _$$SkillModelImplToJson(_$SkillModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'level': _$SkillLevelEnumMap[instance.level]!,
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'beginner',
  SkillLevel.intermediate: 'intermediate',
  SkillLevel.advanced: 'advanced',
  SkillLevel.expert: 'expert',
};
