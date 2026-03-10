import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signup(
      String name, String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(
      String token, String newPassword);
  Future<Either<Failure, void>> verifyEmail(String token);
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword);
}
