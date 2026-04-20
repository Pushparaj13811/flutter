import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/activity_log_model.dart';
import 'package:skill_exchange/data/models/admin_circle_model.dart';
import 'package:skill_exchange/data/models/admin_post_model.dart';
import 'package:skill_exchange/data/models/admin_skill_model.dart';
import 'package:skill_exchange/data/models/analytics_model.dart';
import 'package:skill_exchange/data/models/announcement_model.dart';
import 'package:skill_exchange/data/models/platform_stats_model.dart';
import 'package:skill_exchange/data/models/user_report_model.dart';

// ── Data Providers ────────────────────────────────────────────────────────

final platformStatsProvider =
    FutureProvider<PlatformStatsModel>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getStats();
  return PlatformStatsModel.fromJson(data);
});

final allUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  return service.getUsers();
});

final reportedContentProvider =
    FutureProvider<List<UserReportModel>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getReports();
  return data.map((d) => UserReportModel.fromJson(d)).toList();
});

final adminPostsProvider =
    FutureProvider<List<AdminPostModel>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final result = await service.getPosts();
  return result.map((d) => AdminPostModel.fromMap(d)).toList();
});

final adminCirclesProvider =
    FutureProvider<List<AdminCircleModel>>((ref) async {
  final service = ref.watch(communityFirestoreServiceProvider);
  final circles = await service.getCircles();
  return circles.map((d) => AdminCircleModel.fromMap(d)).toList();
});

final analyticsProvider = FutureProvider<AnalyticsModel>((ref) async {
  final db = FirebaseFirestore.instance;

  // Get all profiles to compute skill popularity
  final profiles = await db.collection('profiles').get();
  final teachCounts = <String, int>{};
  final learnCounts = <String, int>{};

  for (final doc in profiles.docs) {
    final data = doc.data();
    final teachSkills = (data['skillsToTeach'] as List?) ?? [];
    final learnSkills = (data['skillsToLearn'] as List?) ?? [];

    for (final skill in teachSkills) {
      final name = (skill as Map)['category'] as String? ?? 'Other';
      teachCounts[name] = (teachCounts[name] ?? 0) + 1;
    }
    for (final skill in learnSkills) {
      final name = (skill as Map)['category'] as String? ?? 'Other';
      learnCounts[name] = (learnCounts[name] ?? 0) + 1;
    }
  }

  // Merge categories and sort by total popularity
  final allCategories = {...teachCounts.keys, ...learnCounts.keys};
  final popularSkills = allCategories.map((cat) {
    return {
      'name': cat,
      'teachCount': teachCounts[cat] ?? 0,
      'learnCount': learnCounts[cat] ?? 0,
    };
  }).toList()
    ..sort((a, b) =>
        ((b['teachCount'] as int) + (b['learnCount'] as int))
            .compareTo((a['teachCount'] as int) + (a['learnCount'] as int)));

  // Get session stats
  final allSessions = await db.collection('sessions').count().get();
  final completedSessions = await db.collection('sessions').where('status', isEqualTo: 'completed').count().get();
  final activeUsers = await db.collection('users').where('isActive', isEqualTo: true).count().get();
  final totalUsers = await db.collection('users').count().get();

  final totalSessionCount = allSessions.count ?? 0;
  final completedCount = completedSessions.count ?? 0;
  final completionRate = totalSessionCount > 0 ? completedCount / totalSessionCount : 0.0;

  return AnalyticsModel.fromMap({
    'overview': {
      'totalUsers': totalUsers.count ?? 0,
      'activeUsers': activeUsers.count ?? 0,
      'totalSessions': totalSessionCount,
      'completionRate': completionRate,
      'newUsersThisWeek': 0,
      'sessionsThisWeek': 0,
    },
    'popularSkills': popularSkills.take(8).toList(),
    'weeklyActivity': <Map<String, dynamic>>[],
  });
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
        () async {
          await FirebaseFirestore.instance.collection('circles').doc(id).update({'isFeatured': true});
        },
        [adminCirclesProvider],
      );

  Future<bool> updateCircle(String id, Map<String, dynamic> data) => _mutate(
        () async {
          await FirebaseFirestore.instance.collection('circles').doc(id).update(data);
        },
        [adminCirclesProvider],
      );

  Future<bool> deleteCircle(String id) => _mutate(
        () => _service.deleteCircle(id),
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
