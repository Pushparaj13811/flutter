// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogModelImpl _$$ActivityLogModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityLogModelImpl(
  id: json['id'] as String,
  adminName: json['adminName'] as String,
  action: json['action'] as String,
  targetType: json['targetType'] as String,
  targetId: json['targetId'] as String? ?? '',
  details: json['details'] as String? ?? '',
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$$ActivityLogModelImplToJson(
  _$ActivityLogModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'adminName': instance.adminName,
  'action': instance.action,
  'targetType': instance.targetType,
  'targetId': instance.targetId,
  'details': instance.details,
  'timestamp': instance.timestamp,
};
