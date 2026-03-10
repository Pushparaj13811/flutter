import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileModel>> getCurrentProfile();
  Future<Either<Failure, UserProfileModel>> getProfile(String id);
  Future<Either<Failure, UserProfileModel>> updateProfile(
      UpdateProfileDto dto);
  Future<Either<Failure, List<SkillModel>>> getAllSkills();
  Future<Either<Failure, List<String>>> getSkillCategories();
  Future<Either<Failure, String>> uploadAvatar(File file);
}
