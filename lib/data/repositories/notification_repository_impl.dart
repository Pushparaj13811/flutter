import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/notification_model.dart';
import 'package:skill_exchange/data/sources/remote/notification_remote_source.dart';
import 'package:skill_exchange/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteSource _remoteSource;

  NotificationRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final result = await _remoteSource.getNotifications();
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final result = await _remoteSource.getUnreadCount();
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _remoteSource.markAsRead(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await _remoteSource.deleteNotification(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
