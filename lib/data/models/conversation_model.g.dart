// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
  id: json['id'] as String,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastMessage: json['lastMessage'] as String?,
  lastMessageAt: json['lastMessageAt'] as String?,
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  updatedAt: json['updatedAt'] as String,
  participantProfiles:
      (json['participantProfiles'] as List<dynamic>?)
          ?.map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'participants': instance.participants,
  'lastMessage': instance.lastMessage,
  'lastMessageAt': instance.lastMessageAt,
  'unreadCount': instance.unreadCount,
  'updatedAt': instance.updatedAt,
  'participantProfiles': instance.participantProfiles,
};
