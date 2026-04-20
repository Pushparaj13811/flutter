import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class ProfileRemoteSource {
  final Dio _dio;

  ProfileRemoteSource(this._dio);

  Future<UserProfileModel> getCurrentProfile() async {
    final response = await _dio.get(Profiles.me);
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> getProfile(String id) async {
    final response = await _dio.get(Profiles.byId(id));
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> getProfileByUsername(String username) async {
    final response = await _dio.get(Profiles.byUsername(username));
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> updateProfile(UpdateProfileDto dto) async {
    final response = await _dio.patch(Profiles.me, data: dto.toJson());
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<String> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(Profiles.avatar, data: formData);
    return response.data['data']['url'] as String;
  }

  Future<String> uploadCoverImage(File file) async {
    final formData = FormData.fromMap({
      'coverImage': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(Profiles.cover, data: formData);
    return response.data['data']['url'] as String;
  }

  Future<void> removeCoverImage() async {
    await _dio.delete(Profiles.cover);
  }

  Future<Map<String, dynamic>> getPreferences() async {
    final response = await _dio.get(Profiles.preferences);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) async {
    final response = await _dio.patch(Profiles.preferences, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getUserPosts(String userId) async {
    final response = await _dio.get(Profiles.userPosts(userId));
    return response.data['data'] as List<dynamic>;
  }

  Future<List<SkillModel>> getAllSkills() async {
    final response = await _dio.get(Skills.list);
    final data = response.data['data'] as List;
    return data
        .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getSkillCategories() async {
    final response = await _dio.get(Skills.categories);
    final data = response.data['data'] as List;
    return data.cast<String>();
  }
}
