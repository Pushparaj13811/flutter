class CreateReviewDto {
  final String toUserId;
  final int rating;
  final String comment;
  final List<String> skillsReviewed;
  final String? sessionId;

  const CreateReviewDto({
    this.toUserId = '',
    this.rating = 0,
    this.comment = '',
    this.skillsReviewed = const [],
    this.sessionId,
  });

  factory CreateReviewDto.fromMap(Map<String, dynamic> map) {
    return CreateReviewDto(
      toUserId: map['toUserId'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] as String? ?? '',
      skillsReviewed: (map['skillsReviewed'] as List?)?.cast<String>() ?? [],
      sessionId: map['sessionId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'toUserId': toUserId,
        'rating': rating,
        'comment': comment,
        'skillsReviewed': skillsReviewed,
        'sessionId': sessionId,
      };

  /// Legacy compatibility alias
  Map<String, dynamic> toJson() => toMap();
}
