import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/activity_log_model.dart';
import 'package:skill_exchange/data/models/admin_circle_model.dart';
import 'package:skill_exchange/data/models/admin_post_model.dart';
import 'package:skill_exchange/data/models/admin_skill_model.dart';
import 'package:skill_exchange/data/models/analytics_model.dart';
import 'package:skill_exchange/data/models/announcement_model.dart';
import 'package:skill_exchange/data/models/platform_stats_model.dart';
import 'package:skill_exchange/data/models/user_report_model.dart';

abstract class AdminRepository {
  // Reports
  Future<Either<Failure, UserReportModel>> createReport(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<UserReportModel>>> getReports();
  Future<Either<Failure, UserReportModel>> updateReport(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, PlatformStatsModel>> getPlatformStats();

  // Community posts
  Future<Either<Failure, List<AdminPostModel>>> getAdminPosts();
  Future<Either<Failure, void>> pinPost(String id);
  Future<Either<Failure, void>> hidePost(String id);
  Future<Either<Failure, void>> deletePost(String id);

  // Community circles
  Future<Either<Failure, List<AdminCircleModel>>> getAdminCircles();
  Future<Either<Failure, void>> featureCircle(String id);
  Future<Either<Failure, void>> updateCircle(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteCircle(String id);

  // Analytics
  Future<Either<Failure, AnalyticsModel>> getAnalytics();

  // Skills management
  Future<Either<Failure, List<AdminSkillModel>>> getAdminSkills();
  Future<Either<Failure, void>> createSkill(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateSkill(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteSkill(String id);

  // Announcements
  Future<Either<Failure, List<AnnouncementModel>>> getAnnouncements();
  Future<Either<Failure, void>> createAnnouncement(Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteAnnouncement(String id);

  // Activity logs
  Future<Either<Failure, List<ActivityLogModel>>> getActivityLogs();
}
