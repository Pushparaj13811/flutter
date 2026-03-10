import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';
import 'package:skill_exchange/data/models/learning_circle_model.dart';

class CommunityRemoteSource {
  final Dio _dio;

  CommunityRemoteSource(this._dio);

  // ── Discussion Posts ──────────────────────────────────────────────────

  Future<List<DiscussionPostModel>> getPosts({int? page}) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;

    final response = await _dio.get(
      Community.posts,
      queryParameters: params,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => DiscussionPostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DiscussionPostModel> createPost(CreatePostDto dto) async {
    final response = await _dio.post(Community.posts, data: dto.toJson());
    return DiscussionPostModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> likePost(String id) async {
    await _dio.post(Community.likePost(id));
  }

  Future<void> unlikePost(String id) async {
    await _dio.delete(Community.unlikePost(id));
  }

  // ── Learning Circles ──────────────────────────────────────────────────

  Future<List<LearningCircleModel>> getCircles({int? page}) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;

    final response = await _dio.get(
      Community.circles,
      queryParameters: params,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => LearningCircleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LearningCircleModel> createCircle(CreateCircleDto dto) async {
    final response = await _dio.post(Community.circles, data: dto.toJson());
    return LearningCircleModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> joinCircle(String id) async {
    await _dio.post(Community.joinCircle(id));
  }

  Future<void> leaveCircle(String id) async {
    await _dio.delete(Community.leaveCircle(id));
  }

  // ── Leaderboard ───────────────────────────────────────────────────────

  Future<List<LeaderboardEntryModel>> getLeaderboard({int? limit}) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;

    final response = await _dio.get(
      Community.leaderboard,
      queryParameters: params,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
