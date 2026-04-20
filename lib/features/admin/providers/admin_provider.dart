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

// ── Data Providers ────────────────────────────────────────────────────────

final platformStatsProvider =
    FutureProvider<PlatformStatsModel>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getStats();
  return PlatformStatsModel.fromJson(data);
});

final allUsersProvider =
    FutureProvider<List<UserProfileModel>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getUsers();
  return data.map((d) => UserProfileModel.fromJson(d)).toList();
});

final reportedContentProvider =
    FutureProvider<List<UserReportModel>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getReports();
  return data.map((d) => UserReportModel.fromJson(d)).toList();
});

final adminPostsProvider =
    FutureProvider<List<AdminPostModel>>((ref) async {
  // Admin posts not directly supported — stub with empty list
  return <AdminPostModel>[];
});

final adminCirclesProvider =
    FutureProvider<List<AdminCircleModel>>((ref) async {
  // Admin circles not directly supported — stub with empty list
  return <AdminCircleModel>[];
});

final analyticsProvider = FutureProvider<AnalyticsModel>((ref) async {
  // Analytics not directly supported — stub
  return AnalyticsModel.fromJson({});
});

final adminSkillsProvider =
    FutureProvider<List<AdminSkillModel>>((ref) async {
  // Admin skills not directly supported — stub with empty list
  return <AdminSkillModel>[];
});

final announcementsProvider =
    FutureProvider<List<AnnouncementModel>>((ref) async {
  // Announcements not directly supported — stub with empty list
  return <AnnouncementModel>[];
});

final activityLogsProvider =
    FutureProvider<List<ActivityLogModel>>((ref) async {
  // Activity logs not directly supported — stub with empty list
  return <ActivityLogModel>[];
});

// ── Admin Notifier ────────────────────────────────────────────────────────

class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminFirestoreService _service;
  final Ref _ref;

  AdminNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> _mutate(
    Future<void> Function() call,
    List<ProviderOrFamily> invalidate,
  ) async {
    state = const AsyncValue.loading();
    try {
      await call();
      state = const AsyncValue.data(null);
      for (final provider in invalidate) {
        _ref.invalidate(provider);
      }
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> banUser(String userId) => _mutate(
        () => _service.banUser(userId),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> unbanUser(String userId) => _mutate(
        () => _service.unbanUser(userId),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> deleteContent(String contentId) => _mutate(
        () => _service.updateReport(contentId, {'action': 'delete_content'}),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> resolveReport(String reportId, String action) => _mutate(
        () => _service.updateReport(
          reportId,
          {'status': 'resolved', 'action': action},
        ),
        [platformStatsProvider, reportedContentProvider],
      );

  Future<bool> pinPost(String id) => _mutate(
        () => _service.moderatePost(id, 'pinned'),
        [adminPostsProvider],
      );

  Future<bool> hidePost(String id) => _mutate(
        () => _service.moderatePost(id, 'hidden'),
        [adminPostsProvider],
      );

  Future<bool> deletePost(String id) => _mutate(
        () => _service.moderatePost(id, 'deleted'),
        [adminPostsProvider],
      );

  Future<bool> featureCircle(String id) => _mutate(
        () async {}, // stub
        [adminCirclesProvider],
      );

  Future<bool> updateCircle(String id, Map<String, dynamic> data) => _mutate(
        () async {}, // stub
        [adminCirclesProvider],
      );

  Future<bool> deleteCircle(String id) => _mutate(
        () async {}, // stub
        [adminCirclesProvider],
      );

  Future<bool> createSkill(Map<String, dynamic> data) => _mutate(
        () async {}, // stub
        [adminSkillsProvider],
      );

  Future<bool> updateSkill(String id, Map<String, dynamic> data) => _mutate(
        () async {}, // stub
        [adminSkillsProvider],
      );

  Future<bool> deleteSkill(String id) => _mutate(
        () async {}, // stub
        [adminSkillsProvider],
      );

  Future<bool> createAnnouncement(Map<String, dynamic> data) => _mutate(
        () async {}, // stub
        [announcementsProvider],
      );

  Future<bool> deleteAnnouncement(String id) => _mutate(
        () async {}, // stub
        [announcementsProvider],
      );
}

final adminNotifierProvider =
    StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(adminFirestoreServiceProvider);
  return AdminNotifier(service, ref);
});
