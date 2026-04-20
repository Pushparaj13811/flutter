class PlatformStatsModel {
  final int totalUsers;
  final int activeUsers;
  final int totalSessions;
  final int completedSessions;
  final int totalConnections;
  final int totalReviews;
  final double averageRating;
  final int totalPosts;
  final int totalCircles;
  final int pendingReports;

  const PlatformStatsModel({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.totalSessions = 0,
    this.completedSessions = 0,
    this.totalConnections = 0,
    this.totalReviews = 0,
    this.averageRating = 0,
    this.totalPosts = 0,
    this.totalCircles = 0,
    this.pendingReports = 0,
  });

  factory PlatformStatsModel.fromMap(Map<String, dynamic> map) {
    return PlatformStatsModel(
      totalUsers: (map['totalUsers'] as num?)?.toInt() ?? 0,
      activeUsers: (map['activeUsers'] as num?)?.toInt() ?? 0,
      totalSessions: (map['totalSessions'] as num?)?.toInt() ?? 0,
      completedSessions: (map['completedSessions'] as num?)?.toInt() ?? 0,
      totalConnections: (map['totalConnections'] as num?)?.toInt() ?? 0,
      totalReviews: (map['totalReviews'] as num?)?.toInt() ?? 0,
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0,
      totalPosts: (map['totalPosts'] as num?)?.toInt() ?? 0,
      totalCircles: (map['totalCircles'] as num?)?.toInt() ?? 0,
      pendingReports: (map['pendingReports'] as num?)?.toInt() ?? 0,
    );
  }

  /// Legacy compatibility alias
  factory PlatformStatsModel.fromJson(Map<String, dynamic> json) =
      PlatformStatsModel.fromMap;

  Map<String, dynamic> toMap() => {
        'totalUsers': totalUsers,
        'activeUsers': activeUsers,
        'totalSessions': totalSessions,
        'completedSessions': completedSessions,
        'totalConnections': totalConnections,
        'totalReviews': totalReviews,
        'averageRating': averageRating,
        'totalPosts': totalPosts,
        'totalCircles': totalCircles,
        'pendingReports': pendingReports,
      };
}
