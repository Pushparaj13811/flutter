import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<SessionModel>>> getUpcomingSessions({int? limit});
  Future<Either<Failure, SessionModel>> createSession(CreateSessionDto dto);
  Future<Either<Failure, SessionModel>> cancelSession(
    String id, {
    String? reason,
  });
  Future<Either<Failure, SessionModel>> completeSession(String id);
  Future<Either<Failure, SessionModel>> rescheduleSession(
    String id,
    RescheduleSessionDto dto,
  );
}
