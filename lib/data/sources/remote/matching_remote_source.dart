import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';
import 'package:skill_exchange/data/models/paginated_response_model.dart';

class MatchingRemoteSource {
  final Dio _dio;

  MatchingRemoteSource(this._dio);

  Future<PaginatedResponseModel<MatchScoreModel>> getMatches({
    MatchingFiltersModel? filters,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };

    if (sortBy != null) params['sortBy'] = sortBy;

    if (filters != null) {
      final json = filters.toJson();
      json.removeWhere((_, v) => v == null);
      params.addAll(json);
    }

    final response = await _dio.get(
      Matching.list,
      queryParameters: params,
    );

    final dataList = response.data['data'] as List;
    final matches = dataList
        .map((e) => MatchScoreModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final pagination = PaginationModel.fromJson(
      response.data['pagination'] as Map<String, dynamic>,
    );

    return PaginatedResponseModel(data: matches, pagination: pagination);
  }

  Future<List<MatchScoreModel>> getTopMatches(int limit) async {
    final response = await _dio.get(
      Matching.suggestions,
      queryParameters: {'limit': limit},
    );

    final data = response.data['data'] as List;
    return data
        .map((e) => MatchScoreModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
