import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/auth_dto.dart';
import 'package:skill_exchange/data/models/user_model.dart';

class AuthRemoteSource {
  final Dio _dio;

  AuthRemoteSource(this._dio);

  Future<AuthTokensModel> login(LoginDto dto) async {
    final response = await _dio.post(Auth.login, data: dto.toJson());
    return AuthTokensModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<AuthTokensModel> signup(SignupDto dto) async {
    final response = await _dio.post(Auth.signup, data: dto.toJson());
    return AuthTokensModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> logout() async {
    await _dio.post(Auth.logout);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(Auth.me);
    return UserModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post(Auth.forgotPassword, data: {'email': email});
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _dio.post(
      Auth.resetPassword,
      data: {'token': token, 'newPassword': newPassword},
    );
  }

  Future<void> verifyEmail(String token) async {
    await _dio.post(Auth.verifyEmail, data: {'token': token});
  }

  Future<void> changePassword(ChangePasswordDto dto) async {
    await _dio.post(Auth.changePassword, data: dto.toJson());
  }
}
