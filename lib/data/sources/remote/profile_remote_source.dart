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
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> getProfile(String id) async {
    final response = await _dio.get(Profiles.byId(id));
    return UserProfileModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> updateProfile(UpdateProfileDto dto) async {
    final response = await _dio.put(Profiles.me, data: dto.toJson());
    return UserProfileModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
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

  Future<String> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(Uploads.avatar, data: formData);
    return response.data['data']['url'] as String;
  }
}
