import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/search_result_model.dart';

class SearchRemoteSource {
  final Dio _dio;

  SearchRemoteSource(this._dio);

  Future<SearchResultModel> searchUsers(
    SearchFiltersModel filters, {
    int page = 1,
  }) async {
    final params = <String, dynamic>{
      'page': page,
    };

    final json = filters.toJson();
    json.removeWhere((_, v) => v == null);
    params.addAll(json);

    final response = await _dio.get(
      Search.users,
      queryParameters: params,
    );

    return SearchResultModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
