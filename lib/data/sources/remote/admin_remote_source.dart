import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/activity_log_model.dart';
import 'package:skill_exchange/data/models/admin_circle_model.dart';
import 'package:skill_exchange/data/models/admin_post_model.dart';
import 'package:skill_exchange/data/models/admin_skill_model.dart';
import 'package:skill_exchange/data/models/analytics_model.dart';
import 'package:skill_exchange/data/models/announcement_model.dart';
import 'package:skill_exchange/data/models/platform_stats_model.dart';
import 'package:skill_exchange/data/models/user_report_model.dart';

class AdminRemoteSource {
  final Dio _dio;

  AdminRemoteSource(this._dio);

  // ── Reports ──────────────────────────────────────────────────────────

  Future<UserReportModel> createReport(Map<String, dynamic> data) async {
    final response = await _dio.post(Reports.create, data: data);
    return UserReportModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<List<UserReportModel>> getReports() async {
    final response = await _dio.get(Reports.list);
    final data = response.data['data'] as List;
    return data
        .map((e) => UserReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserReportModel> updateReport(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(Reports.byId(id), data: data);
    return UserReportModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<PlatformStatsModel> getPlatformStats() async {
    final response = await _dio.get(Admin.stats);
    return PlatformStatsModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  // ── Community Posts ──────────────────────────────────────────────────

  Future<List<AdminPostModel>> getAdminPosts() async {
    final response = await _dio.get(Admin.communityPosts);
    final data = response.data['data'] as List;
    return data
        .map((e) => AdminPostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> pinPost(String id) async {
    await _dio.put(Admin.pinPost(id));
  }

  Future<void> hidePost(String id) async {
    await _dio.put(Admin.hidePost(id));
  }

  Future<void> deletePost(String id) async {
    await _dio.delete(Admin.deletePost(id));
  }

  // ── Community Circles ────────────────────────────────────────────────

  Future<List<AdminCircleModel>> getAdminCircles() async {
    final response = await _dio.get(Admin.communityCircles);
    final data = response.data['data'] as List;
    return data
        .map((e) => AdminCircleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> featureCircle(String id) async {
    await _dio.put(Admin.featureCircle(id));
  }

  Future<void> updateCircle(String id, Map<String, dynamic> data) async {
    await _dio.put(Admin.updateCircle(id), data: data);
  }

  Future<void> deleteCircle(String id) async {
    await _dio.delete(Admin.deleteCircle(id));
  }

  // ── Analytics ────────────────────────────────────────────────────────

  Future<AnalyticsModel> getAnalytics() async {
    final response = await _dio.get(Admin.analytics);
    return AnalyticsModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  // ── Skills Management ────────────────────────────────────────────────

  Future<List<AdminSkillModel>> getAdminSkills() async {
    final response = await _dio.get(Admin.skills);
    final data = response.data['data'] as List;
    return data
        .map((e) => AdminSkillModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createSkill(Map<String, dynamic> data) async {
    await _dio.post(Admin.skills, data: data);
  }

  Future<void> updateSkill(String id, Map<String, dynamic> data) async {
    await _dio.put(Admin.skillById(id), data: data);
  }

  Future<void> deleteSkill(String id) async {
    await _dio.delete(Admin.skillById(id));
  }

  // ── Announcements ───────────────────────────────────────────────────

  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await _dio.get(Admin.announcements);
    final data = response.data['data'] as List;
    return data
        .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createAnnouncement(Map<String, dynamic> data) async {
    await _dio.post(Admin.announcements, data: data);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _dio.delete(Admin.deleteAnnouncement(id));
  }

  // ── Activity Logs ───────────────────────────────────────────────────

  Future<List<ActivityLogModel>> getActivityLogs() async {
    final response = await _dio.get(Admin.activityLogs);
    final data = response.data['data'] as List;
    return data
        .map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
