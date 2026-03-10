import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform_stats_model.freezed.dart';
part 'platform_stats_model.g.dart';

@freezed
class PlatformStatsModel with _$PlatformStatsModel {
  const factory PlatformStatsModel({
    @Default(0) int totalUsers,
    @Default(0) int activeUsers,
    @Default(0) int totalSessions,
    @Default(0) int completedSessions,
    @Default(0) int totalConnections,
    @Default(0) int totalReviews,
    @Default(0) double averageRating,
    @Default(0) int totalPosts,
    @Default(0) int totalCircles,
    @Default(0) int pendingReports,
  }) = _PlatformStatsModel;

  factory PlatformStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformStatsModelFromJson(json);
}
