// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnnouncementModelImpl _$$AnnouncementModelImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String? ?? '',
  priority:
      $enumDecodeNullable(_$AnnouncementPriorityEnumMap, json['priority']) ??
      AnnouncementPriority.info,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] as String,
  expiresAt: json['expiresAt'] as String?,
);

Map<String, dynamic> _$$AnnouncementModelImplToJson(
  _$AnnouncementModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'priority': _$AnnouncementPriorityEnumMap[instance.priority]!,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'expiresAt': instance.expiresAt,
};

const _$AnnouncementPriorityEnumMap = {
  AnnouncementPriority.info: 'info',
  AnnouncementPriority.warning: 'warning',
  AnnouncementPriority.critical: 'critical',
};
