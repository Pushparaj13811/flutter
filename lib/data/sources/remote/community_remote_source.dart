import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class CommunityRemoteSource {
  final Dio _dio;

  CommunityRemoteSource(this._dio);

  // ── Posts ──

  Future<Map<String, dynamic>> getPosts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Community.posts, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    final response = await _dio.post(Community.posts, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _dio.put(Community.postById(postId), data: data);
  }

  Future<void> deletePost(String postId) async {
    await _dio.delete(Community.postById(postId));
  }

  Future<List<Map<String, dynamic>>> uploadPostMedia(List<File> files) async {
    final formData = FormData();
    for (final file in files) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(file.path),
      ));
    }
    final response = await _dio.post(
      Community.uploadMedia,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return (response.data['data']['media'] as List)
        .cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> uploadPostVideo(File file) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(
      Community.uploadVideo,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Likes ──

  Future<void> likePost(String postId) async {
    await _dio.post(Community.likePost(postId));
  }

  Future<void> unlikePost(String postId) async {
    await _dio.delete(Community.likePost(postId));
  }

  Future<bool> hasUserLikedPost(String postId) async {
    final response = await _dio.get(Community.hasLiked(postId));
    return response.data['data']['liked'] as bool;
  }

  // ── Replies ──

  Future<List<dynamic>> getPostReplies(String postId) async {
    final response = await _dio.get(Community.postReplies(postId));
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createReply(String postId, String content) async {
    final response = await _dio.post(
      Community.postReplies(postId),
      data: {'content': content},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Circles ──

  Future<List<dynamic>> getCircles() async {
    final response = await _dio.get(Community.circles);
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createCircle(Map<String, dynamic> data) async {
    final response = await _dio.post(Community.circles, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateCircle(String circleId, Map<String, dynamic> data) async {
    await _dio.put(Community.circleById(circleId), data: data);
  }

  Future<void> deleteCircle(String circleId) async {
    await _dio.delete(Community.circleById(circleId));
  }

  Future<void> joinCircle(String circleId) async {
    await _dio.post(Community.joinCircle(circleId));
  }

  Future<void> leaveCircle(String circleId) async {
    await _dio.post(Community.leaveCircle(circleId));
  }

  Future<bool> isCircleMember(String circleId) async {
    final response = await _dio.get(Community.circleMembership(circleId));
    return response.data['data']['isMember'] as bool;
  }

  Future<Map<String, dynamic>> getCirclePosts(
    String circleId, {
    Map<String, dynamic>? params,
  }) async {
    final response = await _dio.get(
      Community.circlePosts(circleId),
      queryParameters: params,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createCirclePost(
    String circleId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      Community.circlePosts(circleId),
      data: data,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Leaderboard ──

  Future<List<dynamic>> getLeaderboard({int limit = 10}) async {
    final response = await _dio.get(
      Community.leaderboard,
      queryParameters: {'limit': limit},
    );
    return response.data['data'] as List<dynamic>;
  }
}
