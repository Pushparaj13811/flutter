import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';
import 'package:skill_exchange/data/sources/remote/session_remote_source.dart';
import 'package:skill_exchange/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteSource _remoteSource;

  SessionRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, List<SessionModel>>> getUpcomingSessions({
    int? limit,
  }) async {
    try {
      final result = await _remoteSource.getSessions();
      final upcoming = result['upcoming'] as List? ?? [];
      final sessions = upcoming
          .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (limit != null && sessions.length > limit) {
        return Right(sessions.sublist(0, limit));
      }
      return Right(sessions);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> createSession(
    CreateSessionDto dto,
  ) async {
    try {
      final result = await _remoteSource.bookSession(dto);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> cancelSession(
    String id, {
    String? reason,
  }) async {
    try {
      final result = await _remoteSource.cancelSession(id, reason: reason);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> completeSession(String id) async {
    try {
      final result = await _remoteSource.completeSession(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> rescheduleSession(
    String id,
    RescheduleSessionDto dto,
  ) async {
    try {
      final result = await _remoteSource.rescheduleSession(id, dto);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
