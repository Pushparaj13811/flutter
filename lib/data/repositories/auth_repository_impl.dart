import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/auth_dto.dart';
import 'package:skill_exchange/data/sources/local/secure_storage_source.dart';
import 'package:skill_exchange/data/sources/remote/auth_remote_source.dart';
import 'package:skill_exchange/domain/entities/user.dart';
import 'package:skill_exchange/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final SecureStorageSource _storage;

  AuthRepositoryImpl(this._remoteSource, this._storage);

  User _toEntity(dynamic model) {
    return User(
      id: model.id as String,
      email: model.email as String,
      name: model.name as String,
      avatar: model.avatar as String?,
      role: model.role as String,
    );
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await _remoteSource.login(
        LoginDto(email: email, password: password),
      );
      await _storage.saveAccessToken(result.accessToken);
      if (result.refreshToken != null) {
        await _storage.saveRefreshToken(result.refreshToken!);
      }
      return Right(_toEntity(result.user));
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final result = await _remoteSource.signup(
        SignupDto(name: name, email: email, password: password),
      );
      await _storage.saveAccessToken(result.accessToken);
      if (result.refreshToken != null) {
        await _storage.saveRefreshToken(result.refreshToken!);
      }
      return Right(_toEntity(result.user));
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteSource.logout();
      await _storage.clearTokens();
      return const Right(null);
    } on DioException catch (e) {
      // Clear tokens even if server logout fails
      await _storage.clearTokens();
      return Left(e.error as Failure);
    } catch (e) {
      await _storage.clearTokens();
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _remoteSource.getCurrentUser();
      return Right(_toEntity(user));
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _remoteSource.forgotPassword(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      await _remoteSource.resetPassword(token, newPassword);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      await _remoteSource.verifyEmail(token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _remoteSource.changePassword(
        ChangePasswordDto(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
