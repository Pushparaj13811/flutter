// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginDtoImpl _$$LoginDtoImplFromJson(Map<String, dynamic> json) =>
    _$LoginDtoImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginDtoImplToJson(_$LoginDtoImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$SignupDtoImpl _$$SignupDtoImplFromJson(Map<String, dynamic> json) =>
    _$SignupDtoImpl(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$SignupDtoImplToJson(_$SignupDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

_$AuthTokensModelImpl _$$AuthTokensModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthTokensModelImpl(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String?,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AuthTokensModelImplToJson(
  _$AuthTokensModelImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user,
};

_$ChangePasswordDtoImpl _$$ChangePasswordDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChangePasswordDtoImpl(
  currentPassword: json['currentPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$ChangePasswordDtoImplToJson(
  _$ChangePasswordDtoImpl instance,
) => <String, dynamic>{
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};
