// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminSkillModelImpl _$$AdminSkillModelImplFromJson(
  Map<String, dynamic> json,
) => _$AdminSkillModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$$AdminSkillModelImplToJson(
  _$AdminSkillModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'usageCount': instance.usageCount,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
};
