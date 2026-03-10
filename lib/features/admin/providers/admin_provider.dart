import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/activity_log_model.dart';
import 'package:skill_exchange/data/models/admin_circle_model.dart';
import 'package:skill_exchange/data/models/admin_post_model.dart';
import 'package:skill_exchange/data/models/admin_skill_model.dart';
import 'package:skill_exchange/data/models/analytics_model.dart';
import 'package:skill_exchange/data/models/announcement_model.dart';
import 'package:skill_exchange/data/models/platform_stats_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/data/models/user_report_model.dart';
import 'package:skill_exchange/data/repositories/admin_repository_impl.dart';
import 'package:skill_exchange/data/sources/remote/admin_remote_source.dart';
import 'package:skill_exchange/domain/repositories/admin_repository.dart';

// ── DI Providers ──────────────────────────────────────────────────────────

final adminRemoteSourceProvider = Provider<AdminRemoteSource>((ref) {
  return AdminRemoteSource(ref.watch(dioProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(adminRemoteSourceProvider));
});

// ── Data Providers ────────────────────────────────────────────────────────

final platformStatsProvider =
    FutureProvider<PlatformStatsModel>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getPlatformStats();
  return result.fold(
    (failure) => throw failure,
    (stats) => stats,
  );
});

/// Placeholder provider for listing all users.
final allUsersProvider =
    FutureProvider<List<UserProfileModel>>((ref) async {
  ref.watch(adminRepositoryProvider);
  throw UnimplementedError(
    'allUsersProvider requires a dedicated admin users endpoint.',
  );
});

final reportedContentProvider =
    FutureProvider<List<UserReportModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getReports();
  return result.fold(
    (failure) => throw failure,
    (reports) => reports,
  );
});

final adminPostsProvider =
    FutureProvider<List<AdminPostModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getAdminPosts();
  return result.fold(
    (failure) => throw failure,
    (posts) => posts,
  );
});

final adminCirclesProvider =
    FutureProvider<List<AdminCircleModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getAdminCircles();
  return result.fold(
    (failure) => throw failure,
    (circles) => circles,
  );
});

final analyticsProvider = FutureProvider<AnalyticsModel>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getAnalytics();
  return result.fold(
    (failure) => throw failure,
    (analytics) => analytics,
  );
});

final adminSkillsProvider =
    FutureProvider<List<AdminSkillModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getAdminSkills();
  return result.fold(
    (failure) => throw failure,
    (skills) => skills,
  );
});

final announcementsProvider =
    FutureProvider<List<AnnouncementModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getAnnouncements();
  return result.fold(
    (failure) => throw failure,
    (announcements) => announcements,
  );
});

final activityLogsProvider =
    FutureProvider<List<ActivityLogModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getActivityLogs();
  return result.fold(
    (failure) => throw failure,
    (logs) => logs,
  );
});

// ── Admin Notifier ────────────────────────────────────────────────────────

class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repository;
  final Ref _ref;

  AdminNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> _mutate(
    Future<dynamic> Function() call,
    List<ProviderOrFamily> invalidate,
  ) async {
    state = const AsyncValue.loading();
    final result = await call();
    // result is Either<Failure, T>
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        for (final provider in invalidate) {
          _ref.invalidate(provider);
        }
        return true;
      },
    );
  }

  // ── Existing mutations ──────────────────────────────────────────────

  Future<bool> banUser(String userId) => _mutate(
        () => _repository.updateReport(userId, {'action': 'ban'}),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> unbanUser(String userId) => _mutate(
        () => _repository.updateReport(userId, {'action': 'unban'}),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> deleteContent(String contentId) => _mutate(
        () => _repository.updateReport(contentId, {'action': 'delete_content'}),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> resolveReport(String reportId, String action) => _mutate(
        () => _repository.updateReport(
          reportId,
          {'status': 'resolved', 'action': action},
        ),
        [platformStatsProvider, reportedContentProvider],
      );

  // ── Community Posts ─────────────────────────────────────────────────

  Future<bool> pinPost(String id) => _mutate(
        () => _repository.pinPost(id),
        [adminPostsProvider],
      );

  Future<bool> hidePost(String id) => _mutate(
        () => _repository.hidePost(id),
        [adminPostsProvider],
      );

  Future<bool> deletePost(String id) => _mutate(
        () => _repository.deletePost(id),
        [adminPostsProvider],
      );

  // ── Community Circles ───────────────────────────────────────────────

  Future<bool> featureCircle(String id) => _mutate(
        () => _repository.featureCircle(id),
        [adminCirclesProvider],
      );

  Future<bool> updateCircle(String id, Map<String, dynamic> data) => _mutate(
        () => _repository.updateCircle(id, data),
        [adminCirclesProvider],
      );

  Future<bool> deleteCircle(String id) => _mutate(
        () => _repository.deleteCircle(id),
        [adminCirclesProvider],
      );

  // ── Skills Management ───────────────────────────────────────────────

  Future<bool> createSkill(Map<String, dynamic> data) => _mutate(
        () => _repository.createSkill(data),
        [adminSkillsProvider],
      );

  Future<bool> updateSkill(String id, Map<String, dynamic> data) => _mutate(
        () => _repository.updateSkill(id, data),
        [adminSkillsProvider],
      );

  Future<bool> deleteSkill(String id) => _mutate(
        () => _repository.deleteSkill(id),
        [adminSkillsProvider],
      );

  // ── Announcements ──────────────────────────────────────────────────

  Future<bool> createAnnouncement(Map<String, dynamic> data) => _mutate(
        () => _repository.createAnnouncement(data),
        [announcementsProvider],
      );

  Future<bool> deleteAnnouncement(String id) => _mutate(
        () => _repository.deleteAnnouncement(id),
        [announcementsProvider],
      );
}

final adminNotifierProvider =
    StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return AdminNotifier(repo, ref);
});
