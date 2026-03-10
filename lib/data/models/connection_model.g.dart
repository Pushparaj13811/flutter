// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectionModelImpl _$$ConnectionModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectionModelImpl(
  id: json['id'] as String,
  fromUserId: json['fromUserId'] as String,
  toUserId: json['toUserId'] as String,
  status: $enumDecode(_$ConnectionStatusEnumMap, json['status']),
  message: json['message'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  fromUser: json['fromUser'] == null
      ? null
      : UserProfileModel.fromJson(json['fromUser'] as Map<String, dynamic>),
  toUser: json['toUser'] == null
      ? null
      : UserProfileModel.fromJson(json['toUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ConnectionModelImplToJson(
  _$ConnectionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fromUserId': instance.fromUserId,
  'toUserId': instance.toUserId,
  'status': _$ConnectionStatusEnumMap[instance.status]!,
  'message': instance.message,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'fromUser': instance.fromUser,
  'toUser': instance.toUser,
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.pending: 'pending',
  ConnectionStatus.accepted: 'accepted',
  ConnectionStatus.rejected: 'rejected',
};
