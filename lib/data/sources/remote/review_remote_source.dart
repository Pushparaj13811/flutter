import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/data/models/review_model.dart';
import 'package:skill_exchange/data/models/review_stats_model.dart';

class ReviewRemoteSource {
  final Dio _dio;

  ReviewRemoteSource(this._dio);

  Future<List<ReviewModel>> getReviews(String userId) async {
    final response = await _dio.get(Reviews.byUser(userId));
    final data = response.data['data'] as List;
    return data
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReviewStatsModel> getReviewStats(String userId) async {
    final response = await _dio.get(Reviews.statsByUser(userId));
    return ReviewStatsModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<ReviewModel> createReview(CreateReviewDto dto) async {
    final response = await _dio.post(Reviews.create, data: dto.toJson());
    return ReviewModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
