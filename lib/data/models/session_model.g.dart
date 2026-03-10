// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionModelImpl _$$SessionModelImplFromJson(Map<String, dynamic> json) =>
    _$SessionModelImpl(
      id: json['id'] as String,
      hostId: json['hostId'] as String,
      participantId: json['participantId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      skillsToCover:
          (json['skillsToCover'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      scheduledAt: json['scheduledAt'] as String,
      duration: (json['duration'] as num).toInt(),
      status: $enumDecode(_$SessionStatusEnumMap, json['status']),
      sessionMode: json['sessionMode'] as String? ?? 'online',
      meetingPlatform: json['meetingPlatform'] as String?,
      meetingLink: json['meetingLink'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      host: json['host'] == null
          ? null
          : UserProfileModel.fromJson(json['host'] as Map<String, dynamic>),
      participant: json['participant'] == null
          ? null
          : UserProfileModel.fromJson(
              json['participant'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$SessionModelImplToJson(_$SessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostId': instance.hostId,
      'participantId': instance.participantId,
      'title': instance.title,
      'description': instance.description,
      'skillsToCover': instance.skillsToCover,
      'scheduledAt': instance.scheduledAt,
      'duration': instance.duration,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'sessionMode': instance.sessionMode,
      'meetingPlatform': instance.meetingPlatform,
      'meetingLink': instance.meetingLink,
      'location': instance.location,
      'notes': instance.notes,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'host': instance.host,
      'participant': instance.participant,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.scheduled: 'scheduled',
  SessionStatus.completed: 'completed',
  SessionStatus.cancelled: 'cancelled',
};
