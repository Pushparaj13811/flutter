import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_model.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
class LoginDto with _$LoginDto {
  const factory LoginDto({
    required String email,
    required String password,
  }) = _LoginDto;

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}

@freezed
class SignupDto with _$SignupDto {
  const factory SignupDto({
    required String name,
    required String email,
    required String password,
  }) = _SignupDto;

  factory SignupDto.fromJson(Map<String, dynamic> json) =>
      _$SignupDtoFromJson(json);
}

@freezed
class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    required String accessToken,
    String? refreshToken,
    required UserModel user,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);
}

@freezed
class ChangePasswordDto with _$ChangePasswordDto {
  const factory ChangePasswordDto({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePasswordDto;

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDtoFromJson(json);
}
