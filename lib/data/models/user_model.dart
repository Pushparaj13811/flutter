import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') String? mongoId,
    String? id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    @Default(false) bool isVerified,
    @Default(true) bool isActive,
    String? lastLogin,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
