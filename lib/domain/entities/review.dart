class Review {
  final String id;
  final String fromUserId;
  final String toUserId;
  final int rating;
  final String comment;
  final List<String> skillsReviewed;
  final String? sessionId;
  final String createdAt;

  const Review({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.comment,
    this.skillsReviewed = const [],
    this.sessionId,
    required this.createdAt,
  });
}
