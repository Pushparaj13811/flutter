// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      mongoId: json['_id'] as String?,
      id: json['id'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'user',
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      lastLogin: json['lastLogin'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.mongoId,
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
      'role': instance.role,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'lastLogin': instance.lastLogin,
    };
