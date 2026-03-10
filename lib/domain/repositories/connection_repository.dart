import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/connection_model.dart';

abstract class ConnectionRepository {
  Future<Either<Failure, List<ConnectionModel>>> getConnections();
  Future<Either<Failure, List<ConnectionModel>>> getPendingRequests();
  Future<Either<Failure, List<ConnectionModel>>> getSentRequests();
  Future<Either<Failure, ConnectionModel>> sendRequest(
    String toUserId,
    String? message,
  );
  Future<Either<Failure, ConnectionModel>> respondToRequest(
    String id,
    bool accept,
  );
  Future<Either<Failure, void>> removeConnection(String id);
  Future<Either<Failure, String>> getConnectionStatus(String userId);
}
