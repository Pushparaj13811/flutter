class ReviewStatsModel {
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;

  const ReviewStatsModel({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.ratingDistribution = const {},
  });

  factory ReviewStatsModel.fromMap(Map<String, dynamic> map) {
    return ReviewStatsModel(
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (map['totalReviews'] as num?)?.toInt() ?? 0,
      ratingDistribution: map['ratingDistribution'] is Map
          ? (map['ratingDistribution'] as Map)
              .map((k, v) => MapEntry(k.toString(), (v as num).toInt()))
          : {},
    );
  }

  /// Legacy compatibility alias
  factory ReviewStatsModel.fromJson(Map<String, dynamic> json) =
      ReviewStatsModel.fromMap;

  Map<String, dynamic> toMap() => {
        'averageRating': averageRating,
        'totalReviews': totalReviews,
        'ratingDistribution': ratingDistribution,
      };
}
