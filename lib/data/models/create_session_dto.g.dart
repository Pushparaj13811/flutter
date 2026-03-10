// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateSessionDtoImpl _$$CreateSessionDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateSessionDtoImpl(
  participantId: json['participantId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  skillsToCover:
      (json['skillsToCover'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  scheduledAt: json['scheduledAt'] as String,
  duration: (json['duration'] as num).toInt(),
  sessionMode: json['sessionMode'] as String? ?? 'online',
  meetingPlatform: json['meetingPlatform'] as String?,
  meetingLink: json['meetingLink'] as String?,
  location: json['location'] as String?,
);

Map<String, dynamic> _$$CreateSessionDtoImplToJson(
  _$CreateSessionDtoImpl instance,
) => <String, dynamic>{
  'participantId': instance.participantId,
  'title': instance.title,
  'description': instance.description,
  'skillsToCover': instance.skillsToCover,
  'scheduledAt': instance.scheduledAt,
  'duration': instance.duration,
  'sessionMode': instance.sessionMode,
  'meetingPlatform': instance.meetingPlatform,
  'meetingLink': instance.meetingLink,
  'location': instance.location,
};
