import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/connection_model.dart';
import 'package:skill_exchange/data/sources/remote/connection_remote_source.dart';
import 'package:skill_exchange/domain/repositories/connection_repository.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionRemoteSource _remoteSource;

  ConnectionRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, List<ConnectionModel>>> getConnections() async {
    try {
      final result = await _remoteSource.getConnections();
      final items = result['connections'] as List? ?? [];
      return Right(
        items
            .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConnectionModel>>> getPendingRequests() async {
    try {
      final result = await _remoteSource.getPendingRequests();
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConnectionModel>>> getSentRequests() async {
    try {
      final result = await _remoteSource.getSentRequests();
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConnectionModel>> sendRequest(
    String toUserId,
    String? message,
  ) async {
    try {
      final result = await _remoteSource.sendRequest(toUserId, message);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConnectionModel>> respondToRequest(
    String id,
    bool accept,
  ) async {
    try {
      final result = accept
          ? await _remoteSource.acceptRequest(id)
          : await _remoteSource.rejectRequest(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeConnection(String id) async {
    try {
      await _remoteSource.removeConnection(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getConnectionStatus(String userId) async {
    try {
      // The remote source no longer has a dedicated getConnectionStatus method.
      // Return 'none' as default; the UI can derive status from connections list.
      return const Right('none');
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
