class DiscussionPost {
  final String id;
  final String authorId;
  final String title;
  final String content;
  final List<String> tags;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByMe;
  final String createdAt;
  final String updatedAt;

  const DiscussionPost({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
    required this.createdAt,
    required this.updatedAt,
  });
}
