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
  final allSessions = await db.collection('sessions').get();
  final completedCount = allSessions.docs.where((d) => d.data()['status'] == 'completed').length;
  final usersSnap = await db.collection('users').get();
  final activeUsersCount = usersSnap.docs.where((d) => d.data()['isActive'] == true).length;

  final totalSessionCount = allSessions.size;
  final completionRate = totalSessionCount > 0 ? completedCount / totalSessionCount : 0.0;

  return AnalyticsModel.fromMap({
    'overview': {
      'totalUsers': usersSnap.size,
      'activeUsers': activeUsersCount,
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
  final db = FirebaseFirestore.instance;
  final profiles = await db.collection('profiles').get();

  final skillMap = <String, Map<String, dynamic>>{};

  for (final doc in profiles.docs) {
    final data = doc.data();
    for (final skill in ((data['skillsToTeach'] as List?) ?? [])) {
      if (skill is Map) {
        final name = skill['name'] as String? ?? '';
        if (name.isNotEmpty) {
          skillMap.putIfAbsent(name, () => {
            'id': name.toLowerCase().replaceAll(' ', '_'),
            'name': name,
            'category': skill['category'] ?? 'other',
            'usersTeaching': 0,
            'usersLearning': 0,
          });
          skillMap[name]!['usersTeaching'] =
              (skillMap[name]!['usersTeaching'] as int) + 1;
        }
      }
    }
    for (final skill in ((data['skillsToLearn'] as List?) ?? [])) {
      if (skill is Map) {
        final name = skill['name'] as String? ?? '';
        if (name.isNotEmpty) {
          skillMap.putIfAbsent(name, () => {
            'id': name.toLowerCase().replaceAll(' ', '_'),
            'name': name,
            'category': skill['category'] ?? 'other',
            'usersTeaching': 0,
            'usersLearning': 0,
          });
          skillMap[name]!['usersLearning'] =
              (skillMap[name]!['usersLearning'] as int) + 1;
        }
      }
    }
  }

  return skillMap.values
      .map((d) => AdminSkillModel.fromMap(d))
      .toList()
    ..sort((a, b) => (b.usersTeaching + b.usersLearning)
        .compareTo(a.usersTeaching + a.usersLearning));
});

final announcementsProvider =
    FutureProvider<List<AnnouncementModel>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getAnnouncements();
  return data.map((d) => AnnouncementModel.fromMap(d)).toList();
});

final activityLogsProvider =
    FutureProvider<List<ActivityLogModel>>((ref) async {
  final service = ref.watch(adminFirestoreServiceProvider);
  final data = await service.getActivityLogs();
  return data.map((d) => ActivityLogModel.fromMap(d)).toList();
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
        () async {
          await _service.banUser(userId);
          await _service.logActivity('ban_user', targetId: userId);
        },
        [platformStatsProvider, reportedContentProvider, activityLogsProvider],
      );

  Future<bool> unbanUser(String userId) => _mutate(
        () async {
          await _service.unbanUser(userId);
          await _service.logActivity('unban_user', targetId: userId);
        },
        [platformStatsProvider, reportedContentProvider, activityLogsProvider],
      );

  Future<bool> deleteContent(String contentId) => _mutate(
        () async {
          await _service.updateReport(contentId, {'action': 'delete_content'});
          await _service.logActivity('delete_content', targetId: contentId);
        },
        [platformStatsProvider, reportedContentProvider, activityLogsProvider],
      );

  Future<bool> resolveReport(String reportId, String action) => _mutate(
        () async {
          await _service.updateReport(reportId, {'status': 'resolved', 'action': action});
          await _service.logActivity('resolve_report', targetId: reportId, details: action);
        },
        [platformStatsProvider, reportedContentProvider, activityLogsProvider],
      );

  Future<bool> pinPost(String id) => _mutate(
        () async {
          await _service.moderatePost(id, 'pinned');
          await _service.logActivity('pin_post', targetId: id);
        },
        [adminPostsProvider, activityLogsProvider],
      );

  Future<bool> hidePost(String id) => _mutate(
        () async {
          await _service.moderatePost(id, 'hidden');
          await _service.logActivity('hide_post', targetId: id);
        },
        [adminPostsProvider, activityLogsProvider],
      );

  Future<bool> deletePost(String id) => _mutate(
        () async {
          await _service.moderatePost(id, 'deleted');
          await _service.logActivity('delete_post', targetId: id);
        },
        [adminPostsProvider, activityLogsProvider],
      );

  Future<bool> featureCircle(String id) => _mutate(
        () async {
          await FirebaseFirestore.instance.collection('circles').doc(id).update({'isFeatured': true});
          await _service.logActivity('feature_circle', targetId: id);
        },
        [adminCirclesProvider, activityLogsProvider],
      );

  Future<bool> updateCircle(String id, Map<String, dynamic> data) => _mutate(
        () async {
          await FirebaseFirestore.instance.collection('circles').doc(id).update(data);
          await _service.logActivity('update_circle', targetId: id);
        },
        [adminCirclesProvider, activityLogsProvider],
      );

  Future<bool> deleteCircle(String id) => _mutate(
        () async {
          await _service.deleteCircle(id);
          await _service.logActivity('delete_circle', targetId: id);
        },
        [adminCirclesProvider, activityLogsProvider],
      );

  Future<bool> createSkill(Map<String, dynamic> data) => _mutate(
        () async {
          await _service.logActivity('create_skill', details: data['name'] as String? ?? '');
        },
        [adminSkillsProvider, activityLogsProvider],
      );

  Future<bool> updateSkill(String id, Map<String, dynamic> data) => _mutate(
        () async {
          await _service.logActivity('update_skill', targetId: id);
        },
        [adminSkillsProvider, activityLogsProvider],
      );

  Future<bool> deleteSkill(String id) => _mutate(
        () async {
          await _service.logActivity('delete_skill', targetId: id);
        },
        [adminSkillsProvider, activityLogsProvider],
      );

  Future<bool> createAnnouncement(Map<String, dynamic> data) => _mutate(
        () async {
          await _service.createAnnouncement(data);
          await _service.logActivity('create_announcement', details: data['title'] as String? ?? '');
        },
        [announcementsProvider, activityLogsProvider],
      );

  Future<bool> deleteAnnouncement(String id) => _mutate(
        () async {
          await _service.deleteAnnouncement(id);
          await _service.logActivity('delete_announcement', targetId: id);
        },
        [announcementsProvider, activityLogsProvider],
      );
}

final adminNotifierProvider =
    StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(adminFirestoreServiceProvider);
  return AdminNotifier(service, ref);
});
