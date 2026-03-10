// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlatformStatsModelImpl _$$PlatformStatsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformStatsModelImpl(
  totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
  activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
  totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
  completedSessions: (json['completedSessions'] as num?)?.toInt() ?? 0,
  totalConnections: (json['totalConnections'] as num?)?.toInt() ?? 0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
  totalPosts: (json['totalPosts'] as num?)?.toInt() ?? 0,
  totalCircles: (json['totalCircles'] as num?)?.toInt() ?? 0,
  pendingReports: (json['pendingReports'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PlatformStatsModelImplToJson(
  _$PlatformStatsModelImpl instance,
) => <String, dynamic>{
  'totalUsers': instance.totalUsers,
  'activeUsers': instance.activeUsers,
  'totalSessions': instance.totalSessions,
  'completedSessions': instance.completedSessions,
  'totalConnections': instance.totalConnections,
  'totalReviews': instance.totalReviews,
  'averageRating': instance.averageRating,
  'totalPosts': instance.totalPosts,
  'totalCircles': instance.totalCircles,
  'pendingReports': instance.pendingReports,
};
