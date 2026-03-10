sealed class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;
  const ValidationFailure({required super.message, this.fieldErrors});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class ConflictFailure extends Failure {
  const ConflictFailure({required super.message});
}

class RateLimitFailure extends Failure {
  const RateLimitFailure({required super.message});
}
