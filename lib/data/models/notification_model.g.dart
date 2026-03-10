// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  title: json['title'] as String,
  message: json['message'] as String,
  read: json['read'] as bool? ?? false,
  createdAt: json['createdAt'] as String,
  actionUrl: json['actionUrl'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'message': instance.message,
  'read': instance.read,
  'createdAt': instance.createdAt,
  'actionUrl': instance.actionUrl,
  'metadata': instance.metadata,
};

const _$NotificationTypeEnumMap = {
  NotificationType.connectionRequest: 'connection_request',
  NotificationType.connectionAccepted: 'connection_accepted',
  NotificationType.sessionReminder: 'session_reminder',
  NotificationType.sessionCancelled: 'session_cancelled',
  NotificationType.newMessage: 'new_message',
  NotificationType.reviewReceived: 'review_received',
  NotificationType.system: 'system',
};
