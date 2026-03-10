import 'package:dio/dio.dart';
import 'package:skill_exchange/core/errors/failures.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = switch (err.response?.statusCode) {
      400 => ValidationFailure(
          message: _extractMessage(err, 'Invalid request'),
          fieldErrors: _parseFieldErrors(err.response?.data),
        ),
      401 => const AuthFailure(message: 'Authentication required'),
      403 => const PermissionFailure(message: 'Permission denied'),
      404 => const NotFoundFailure(message: 'Resource not found'),
      409 => ConflictFailure(
          message: _extractMessage(err, 'Conflict'),
        ),
      422 => ValidationFailure(
          message: _extractMessage(err, 'Validation failed'),
          fieldErrors: _parseFieldErrors(err.response?.data),
        ),
      429 => const RateLimitFailure(message: 'Too many requests'),
      500 => const ServerFailure(message: 'Internal server error'),
      503 => const ServerFailure(message: 'Service unavailable'),
      _ => _handleDioExceptionType(err),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: failure,
        type: err.type,
        response: err.response,
      ),
    );
  }

  String _extractMessage(DioException err, String fallback) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? fallback;
    }
    return fallback;
  }

  Map<String, List<String>>? _parseFieldErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final errors = data['errors'];
    if (errors is! Map<String, dynamic>) return null;

    return errors.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.cast<String>());
      }
      return MapEntry(key, [value.toString()]);
    });
  }

  Failure _handleDioExceptionType(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const NetworkFailure(message: 'Connection timed out'),
      DioExceptionType.connectionError =>
        const NetworkFailure(message: 'No internet connection'),
      DioExceptionType.cancel =>
        const NetworkFailure(message: 'Request was cancelled'),
      _ => ServerFailure(
          message: err.message ?? 'An unexpected error occurred',
        ),
    };
  }
}
