class AnalyticsModel {
  final AnalyticsOverview overview;
  final List<SkillPopularity> popularSkills;
  final List<WeeklyActivity> weeklyActivity;

  const AnalyticsModel({
    this.overview = const AnalyticsOverview(),
    this.popularSkills = const [],
    this.weeklyActivity = const [],
  });

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    return AnalyticsModel(
      overview: map['overview'] is Map
          ? AnalyticsOverview.fromMap(
              Map<String, dynamic>.from(map['overview'] as Map))
          : const AnalyticsOverview(),
      popularSkills: (map['popularSkills'] as List?)
              ?.map((s) =>
                  SkillPopularity.fromMap(Map<String, dynamic>.from(s as Map)))
              .toList() ??
          [],
      weeklyActivity: (map['weeklyActivity'] as List?)
              ?.map((w) =>
                  WeeklyActivity.fromMap(Map<String, dynamic>.from(w as Map)))
              .toList() ??
          [],
    );
  }

  /// Legacy compatibility alias
  factory AnalyticsModel.fromJson(Map<String, dynamic> json) =
      AnalyticsModel.fromMap;

  Map<String, dynamic> toMap() => {
        'overview': overview.toMap(),
        'popularSkills': popularSkills.map((s) => s.toMap()).toList(),
        'weeklyActivity': weeklyActivity.map((w) => w.toMap()).toList(),
      };
}

class AnalyticsOverview {
  final int totalUsers;
  final int activeUsers;
  final int totalSessions;
  final double completionRate;
  final int newUsersThisWeek;
  final int sessionsThisWeek;

  const AnalyticsOverview({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.totalSessions = 0,
    this.completionRate = 0.0,
    this.newUsersThisWeek = 0,
    this.sessionsThisWeek = 0,
  });

  factory AnalyticsOverview.fromMap(Map<String, dynamic> map) {
    return AnalyticsOverview(
      totalUsers: (map['totalUsers'] as num?)?.toInt() ?? 0,
      activeUsers: (map['activeUsers'] as num?)?.toInt() ?? 0,
      totalSessions: (map['totalSessions'] as num?)?.toInt() ?? 0,
      completionRate: (map['completionRate'] as num?)?.toDouble() ?? 0.0,
      newUsersThisWeek: (map['newUsersThisWeek'] as num?)?.toInt() ?? 0,
      sessionsThisWeek: (map['sessionsThisWeek'] as num?)?.toInt() ?? 0,
    );
  }

  /// Legacy compatibility alias
  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) =
      AnalyticsOverview.fromMap;

  Map<String, dynamic> toMap() => {
        'totalUsers': totalUsers,
        'activeUsers': activeUsers,
        'totalSessions': totalSessions,
        'completionRate': completionRate,
        'newUsersThisWeek': newUsersThisWeek,
        'sessionsThisWeek': sessionsThisWeek,
      };
}

class SkillPopularity {
  final String name;
  final int teachCount;
  final int learnCount;

  const SkillPopularity({
    this.name = '',
    this.teachCount = 0,
    this.learnCount = 0,
  });

  factory SkillPopularity.fromMap(Map<String, dynamic> map) {
    return SkillPopularity(
      name: map['name'] as String? ?? '',
      teachCount: (map['teachCount'] as num?)?.toInt() ?? 0,
      learnCount: (map['learnCount'] as num?)?.toInt() ?? 0,
    );
  }

  /// Legacy compatibility alias
  factory SkillPopularity.fromJson(Map<String, dynamic> json) =
      SkillPopularity.fromMap;

  Map<String, dynamic> toMap() => {
        'name': name,
        'teachCount': teachCount,
        'learnCount': learnCount,
      };
}

class WeeklyActivity {
  final String week;
  final int sessions;
  final int connections;

  const WeeklyActivity({
    this.week = '',
    this.sessions = 0,
    this.connections = 0,
  });

  factory WeeklyActivity.fromMap(Map<String, dynamic> map) {
    return WeeklyActivity(
      week: map['week'] as String? ?? '',
      sessions: (map['sessions'] as num?)?.toInt() ?? 0,
      connections: (map['connections'] as num?)?.toInt() ?? 0,
    );
  }

  /// Legacy compatibility alias
  factory WeeklyActivity.fromJson(Map<String, dynamic> json) =
      WeeklyActivity.fromMap;

  Map<String, dynamic> toMap() => {
        'week': week,
        'sessions': sessions,
        'connections': connections,
      };
}
