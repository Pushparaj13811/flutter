// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminCircleModelImpl _$$AdminCircleModelImplFromJson(
  Map<String, dynamic> json,
) => _$AdminCircleModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  isFeatured: json['isFeatured'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$AdminCircleModelImplToJson(
  _$AdminCircleModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'memberCount': instance.memberCount,
  'isFeatured': instance.isFeatured,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'imageUrl': instance.imageUrl,
};
