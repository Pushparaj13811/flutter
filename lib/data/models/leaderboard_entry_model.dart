import 'package:skill_exchange/data/models/user_profile_model.dart';

class LeaderboardEntryModel {
  final String userId;
  final int rank;
  final int points;
  final int sessionsCompleted;
  final int reviewsGiven;
  final double averageRating;
  final UserProfileModel? user;

  const LeaderboardEntryModel({
    this.userId = '',
    this.rank = 0,
    this.points = 0,
    this.sessionsCompleted = 0,
    this.reviewsGiven = 0,
    this.averageRating = 0.0,
    this.user,
  });

  factory LeaderboardEntryModel.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntryModel(
      userId: map['userId'] as String? ?? '',
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      points: (map['points'] as num?)?.toInt() ?? 0,
      sessionsCompleted: (map['sessionsCompleted'] as num?)?.toInt() ?? 0,
      reviewsGiven: (map['reviewsGiven'] as num?)?.toInt() ?? 0,
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      user: map['user'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['user'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =
      LeaderboardEntryModel.fromMap;

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'rank': rank,
        'points': points,
        'sessionsCompleted': sessionsCompleted,
        'reviewsGiven': reviewsGiven,
        'averageRating': averageRating,
      };
}
