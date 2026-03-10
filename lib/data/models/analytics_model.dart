import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

@freezed
class AnalyticsModel with _$AnalyticsModel {
  const factory AnalyticsModel({
    required AnalyticsOverview overview,
    @Default([]) List<SkillPopularity> popularSkills,
    @Default([]) List<WeeklyActivity> weeklyActivity,
  }) = _AnalyticsModel;

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsModelFromJson(json);
}

@freezed
class AnalyticsOverview with _$AnalyticsOverview {
  const factory AnalyticsOverview({
    @Default(0) int totalUsers,
    @Default(0) int activeUsers,
    @Default(0) int totalSessions,
    @Default(0.0) double completionRate,
    @Default(0) int newUsersThisWeek,
    @Default(0) int sessionsThisWeek,
  }) = _AnalyticsOverview;

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsOverviewFromJson(json);
}

@freezed
class SkillPopularity with _$SkillPopularity {
  const factory SkillPopularity({
    required String name,
    @Default(0) int teachCount,
    @Default(0) int learnCount,
  }) = _SkillPopularity;

  factory SkillPopularity.fromJson(Map<String, dynamic> json) =>
      _$SkillPopularityFromJson(json);
}

@freezed
class WeeklyActivity with _$WeeklyActivity {
  const factory WeeklyActivity({
    required String week,
    @Default(0) int sessions,
    @Default(0) int connections,
  }) = _WeeklyActivity;

  factory WeeklyActivity.fromJson(Map<String, dynamic> json) =>
      _$WeeklyActivityFromJson(json);
}
