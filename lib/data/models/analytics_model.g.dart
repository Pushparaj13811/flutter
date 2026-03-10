// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsModelImpl _$$AnalyticsModelImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsModelImpl(
      overview: AnalyticsOverview.fromJson(
        json['overview'] as Map<String, dynamic>,
      ),
      popularSkills:
          (json['popularSkills'] as List<dynamic>?)
              ?.map((e) => SkillPopularity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      weeklyActivity:
          (json['weeklyActivity'] as List<dynamic>?)
              ?.map((e) => WeeklyActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AnalyticsModelImplToJson(
  _$AnalyticsModelImpl instance,
) => <String, dynamic>{
  'overview': instance.overview,
  'popularSkills': instance.popularSkills,
  'weeklyActivity': instance.weeklyActivity,
};

_$AnalyticsOverviewImpl _$$AnalyticsOverviewImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsOverviewImpl(
  totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
  activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
  totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
  completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
  newUsersThisWeek: (json['newUsersThisWeek'] as num?)?.toInt() ?? 0,
  sessionsThisWeek: (json['sessionsThisWeek'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$AnalyticsOverviewImplToJson(
  _$AnalyticsOverviewImpl instance,
) => <String, dynamic>{
  'totalUsers': instance.totalUsers,
  'activeUsers': instance.activeUsers,
  'totalSessions': instance.totalSessions,
  'completionRate': instance.completionRate,
  'newUsersThisWeek': instance.newUsersThisWeek,
  'sessionsThisWeek': instance.sessionsThisWeek,
};

_$SkillPopularityImpl _$$SkillPopularityImplFromJson(
  Map<String, dynamic> json,
) => _$SkillPopularityImpl(
  name: json['name'] as String,
  teachCount: (json['teachCount'] as num?)?.toInt() ?? 0,
  learnCount: (json['learnCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SkillPopularityImplToJson(
  _$SkillPopularityImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'teachCount': instance.teachCount,
  'learnCount': instance.learnCount,
};

_$WeeklyActivityImpl _$$WeeklyActivityImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyActivityImpl(
      week: json['week'] as String,
      sessions: (json['sessions'] as num?)?.toInt() ?? 0,
      connections: (json['connections'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WeeklyActivityImplToJson(
  _$WeeklyActivityImpl instance,
) => <String, dynamic>{
  'week': instance.week,
  'sessions': instance.sessions,
  'connections': instance.connections,
};
