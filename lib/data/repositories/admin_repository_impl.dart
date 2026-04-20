import 'package:dio/dio.dart';
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
import 'package:skill_exchange/data/sources/remote/admin_remote_source.dart';
import 'package:skill_exchange/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteSource _remoteSource;

  AdminRepositoryImpl(this._remoteSource);

  Future<Either<Failure, T>> _safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Reports ──────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserReportModel>> createReport(
    Map<String, dynamic> data,
  ) => _safeCall(() async {
    final result = await _remoteSource.getReportById('new');
    return UserReportModel.fromJson(result);
  });

  @override
  Future<Either<Failure, List<UserReportModel>>> getReports() =>
      _safeCall(() async {
        final result = await _remoteSource.getReports();
        final items = result['reports'] as List? ?? [];
        return items
            .map((e) => UserReportModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Either<Failure, UserReportModel>> updateReport(
    String id,
    Map<String, dynamic> data,
  ) => _safeCall(() async {
    await _remoteSource.updateReport(id, data);
    final result = await _remoteSource.getReportById(id);
    return UserReportModel.fromJson(result);
  });

  @override
  Future<Either<Failure, PlatformStatsModel>> getPlatformStats() =>
      _safeCall(() async {
        final result = await _remoteSource.getStats();
        return PlatformStatsModel.fromJson(result);
      });

  // ── Community Posts ──────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<AdminPostModel>>> getAdminPosts() =>
      _safeCall(() async {
        final result = await _remoteSource.getPosts();
        final items = result['posts'] as List? ?? [];
        return items
            .map((e) => AdminPostModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Either<Failure, void>> pinPost(String id) =>
      _safeCall(() => _remoteSource.moderatePost(id, {'action': 'pin'}));

  @override
  Future<Either<Failure, void>> hidePost(String id) =>
      _safeCall(() => _remoteSource.moderatePost(id, {'action': 'hide'}));

  @override
  Future<Either<Failure, void>> deletePost(String id) =>
      _safeCall(() => _remoteSource.deletePost(id));

  // ── Community Circles ────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<AdminCircleModel>>> getAdminCircles() =>
      _safeCall(() async {
        final result = await _remoteSource.getCircles();
        return result
            .map((e) => AdminCircleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Either<Failure, void>> featureCircle(String id) =>
      _safeCall(() => _remoteSource.updateCircle(id, {'featured': true}));

  @override
  Future<Either<Failure, void>> updateCircle(
    String id,
    Map<String, dynamic> data,
  ) => _safeCall(() => _remoteSource.updateCircle(id, data));

  @override
  Future<Either<Failure, void>> deleteCircle(String id) =>
      _safeCall(() => _remoteSource.deleteCircle(id));

  // ── Analytics ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, AnalyticsModel>> getAnalytics() =>
      _safeCall(() async {
        final result = await _remoteSource.getStats();
        return AnalyticsModel.fromJson(result);
      });

  // ── Skills Management ────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<AdminSkillModel>>> getAdminSkills() =>
      _safeCall(() async => <AdminSkillModel>[]);

  @override
  Future<Either<Failure, void>> createSkill(Map<String, dynamic> data) =>
      _safeCall(() async {});

  @override
  Future<Either<Failure, void>> updateSkill(
    String id,
    Map<String, dynamic> data,
  ) => _safeCall(() async {});

  @override
  Future<Either<Failure, void>> deleteSkill(String id) =>
      _safeCall(() async {});

  // ── Announcements ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<AnnouncementModel>>> getAnnouncements() =>
      _safeCall(() async => <AnnouncementModel>[]);

  @override
  Future<Either<Failure, void>> createAnnouncement(
    Map<String, dynamic> data,
  ) => _safeCall(() async {});

  @override
  Future<Either<Failure, void>> deleteAnnouncement(String id) =>
      _safeCall(() async {});

  // ── Activity Logs ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ActivityLogModel>>> getActivityLogs() =>
      _safeCall(() async => <ActivityLogModel>[]);
}
