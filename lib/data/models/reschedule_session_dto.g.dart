// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reschedule_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RescheduleSessionDtoImpl _$$RescheduleSessionDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RescheduleSessionDtoImpl(
  newScheduledAt: json['newScheduledAt'] as String,
  newDuration: (json['newDuration'] as num).toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$$RescheduleSessionDtoImplToJson(
  _$RescheduleSessionDtoImpl instance,
) => <String, dynamic>{
  'newScheduledAt': instance.newScheduledAt,
  'newDuration': instance.newDuration,
  'reason': instance.reason,
};
