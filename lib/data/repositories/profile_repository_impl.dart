import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/data/sources/remote/profile_remote_source.dart';
import 'package:skill_exchange/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteSource _remoteSource;

  ProfileRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, UserProfileModel>> getCurrentProfile() async {
    try {
      final profile = await _remoteSource.getCurrentProfile();
      return Right(profile);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> getProfile(String id) async {
    try {
      final profile = await _remoteSource.getProfile(id);
      return Right(profile);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateProfile(
    UpdateProfileDto dto,
  ) async {
    try {
      final profile = await _remoteSource.updateProfile(dto);
      return Right(profile);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SkillModel>>> getAllSkills() async {
    try {
      final skills = await _remoteSource.getAllSkills();
      return Right(skills);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSkillCategories() async {
    try {
      final categories = await _remoteSource.getSkillCategories();
      return Right(categories);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(File file) async {
    try {
      final url = await _remoteSource.uploadAvatar(file);
      return Right(url);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
