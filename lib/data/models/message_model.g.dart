// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      read: json['read'] as bool? ?? false,
      sender: json['sender'] == null
          ? null
          : UserProfileModel.fromJson(json['sender'] as Map<String, dynamic>),
      isFromMe: json['isFromMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'read': instance.read,
      'sender': instance.sender,
      'isFromMe': instance.isFromMe,
    };
