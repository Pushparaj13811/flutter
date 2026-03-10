import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/sources/local/secure_storage_source.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageSource _storage;
  final Dio _dio;

  AuthInterceptor({
    required SecureStorageSource storage,
    required Dio dio,
  })  : _storage = storage,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final newToken = await _refreshToken(refreshToken);
          await _storage.saveAccessToken(newToken);

          // Retry original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(options);
          handler.resolve(response);
          return;
        } catch (_) {
          // Refresh failed — clear tokens, AuthProvider will detect and logout
          await _storage.clearTokens();
        }
      }
    }
    handler.next(err);
  }

  Future<String> _refreshToken(String refreshToken) async {
    final response = await _dio.post(
      Auth.refresh,
      data: {'refreshToken': refreshToken},
    );
    return response.data['data']['accessToken'] as String;
  }
}
