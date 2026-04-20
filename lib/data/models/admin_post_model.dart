class AdminPostModel {
  final String id;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String skillTag;
  final int likesCount;
  final int repliesCount;
  final bool isPinned;
  final bool isHidden;
  final String createdAt;

  const AdminPostModel({
    this.id = '',
    this.authorName = '',
    this.authorAvatar,
    this.content = '',
    this.skillTag = '',
    this.likesCount = 0,
    this.repliesCount = 0,
    this.isPinned = false,
    this.isHidden = false,
    this.createdAt = '',
  });

  factory AdminPostModel.fromMap(Map<String, dynamic> map) {
    return AdminPostModel(
      id: map['id'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      authorAvatar: map['authorAvatar'] as String?,
      content: map['content'] as String? ?? '',
      skillTag: map['skillTag'] as String? ?? '',
      likesCount: (map['likesCount'] as num?)?.toInt() ?? 0,
      repliesCount: (map['repliesCount'] as num?)?.toInt() ?? 0,
      isPinned: map['isPinned'] as bool? ?? false,
      isHidden: map['isHidden'] as bool? ?? false,
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  /// Legacy compatibility alias
  factory AdminPostModel.fromJson(Map<String, dynamic> json) =
      AdminPostModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
        'content': content,
        'skillTag': skillTag,
        'likesCount': likesCount,
        'repliesCount': repliesCount,
        'isPinned': isPinned,
        'isHidden': isHidden,
        'createdAt': createdAt,
      };
}
