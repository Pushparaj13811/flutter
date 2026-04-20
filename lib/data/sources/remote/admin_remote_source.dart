import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class AdminRemoteSource {
  final Dio _dio;

  AdminRemoteSource(this._dio);

  // ── Stats ──
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(Admin.stats);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Users ──
  Future<Map<String, dynamic>> getUsers({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.users, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await _dio.get(Admin.userById(id));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateUserRole(String id, String role) async {
    await _dio.patch(Admin.userRole(id), data: {'role': role});
  }

  Future<void> banUser(String id) async {
    await _dio.patch(Admin.banUser(id));
  }

  Future<void> unbanUser(String id) async {
    await _dio.patch(Admin.unbanUser(id));
  }

  Future<void> deleteUser(String id) async {
    await _dio.delete(Admin.userById(id));
  }

  Future<void> verifySkill(String userId, int skillIndex) async {
    await _dio.patch(Admin.verifySkill(userId, skillIndex));
  }

  // ── Posts ──
  Future<Map<String, dynamic>> getPosts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.posts, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deletePost(String id) async {
    await _dio.delete(Admin.deletePost(id));
  }

  Future<void> moderatePost(String id, Map<String, dynamic> data) async {
    await _dio.patch(Admin.moderatePost(id), data: data);
  }

  // ── Circles ──
  Future<List<dynamic>> getCircles() async {
    final response = await _dio.get(Admin.circles);
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getCircleById(String id) async {
    final response = await _dio.get(Admin.circleById(id));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createCircle(Map<String, dynamic> data) async {
    final response = await _dio.post(Admin.circles, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateCircle(String id, Map<String, dynamic> data) async {
    await _dio.put(Admin.circleById(id), data: data);
  }

  Future<void> deleteCircle(String id) async {
    await _dio.delete(Admin.circleById(id));
  }

  // ── Sessions ──
  Future<Map<String, dynamic>> getSessions({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.sessions, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> cancelSession(String id) async {
    await _dio.patch(Admin.cancelSession(id));
  }

  // ── Connections ──
  Future<Map<String, dynamic>> getConnections({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.connections, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteConnection(String id) async {
    await _dio.delete(Admin.deleteConnection(id));
  }

  // ── Reviews ──
  Future<Map<String, dynamic>> getReviews({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.reviews, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteReview(String id) async {
    await _dio.delete(Admin.deleteReview(id));
  }

  Future<void> updateReviewStatus(String id, String status) async {
    await _dio.patch(Admin.reviewStatus(id), data: {'status': status});
  }

  // ── Reports ──
  Future<Map<String, dynamic>> getReports({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.reports, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getReportById(String id) async {
    final response = await _dio.get(Admin.reportById(id));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    await _dio.patch(Admin.reportById(id), data: data);
  }
}
