class LeaderboardEntry {
  final String userId;
  final int rank;
  final int points;
  final int sessionsCompleted;
  final int reviewsGiven;
  final double averageRating;

  const LeaderboardEntry({
    required this.userId,
    required this.rank,
    this.points = 0,
    this.sessionsCompleted = 0,
    this.reviewsGiven = 0,
    this.averageRating = 0.0,
  });
}
