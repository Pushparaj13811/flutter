import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class SearchRemoteSource {
  final Dio _dio;

  SearchRemoteSource(this._dio);

  Future<Map<String, dynamic>> searchUsers({
    String? query,
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    String? learningStyle,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (query != null) params['query'] = query;
    if (skillCategory != null) params['skillCategory'] = skillCategory;
    if (skillName != null) params['skillName'] = skillName;
    if (location != null) params['location'] = location;
    if (minRating != null) params['minRating'] = minRating;
    if (maxRating != null) params['maxRating'] = maxRating;
    if (learningStyle != null) params['learningStyle'] = learningStyle;

    final response = await _dio.get(
      Search.users,
      queryParameters: params,
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
