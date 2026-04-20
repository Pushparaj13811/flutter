import 'package:skill_exchange/data/models/user_profile_model.dart';

class DiscussionPostModel {
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
  final UserProfileModel? author;

  const DiscussionPostModel({
    this.id = '',
    this.authorId = '',
    this.title = '',
    this.content = '',
    this.tags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.author,
  });

  factory DiscussionPostModel.fromMap(Map<String, dynamic> map) {
    return DiscussionPostModel(
      id: map['id'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      tags: (map['tags'] as List?)?.cast<String>() ?? [],
      likesCount: (map['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (map['commentsCount'] as num?)?.toInt() ?? 0,
      isLikedByMe: map['isLikedByMe'] as bool? ?? false,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      author: map['author'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['author'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory DiscussionPostModel.fromJson(Map<String, dynamic> json) =
      DiscussionPostModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorId': authorId,
        'title': title,
        'content': content,
        'tags': tags,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'isLikedByMe': isLikedByMe,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  DiscussionPostModel copyWith({
    String? id,
    String? authorId,
    String? title,
    String? content,
    List<String>? tags,
    int? likesCount,
    int? commentsCount,
    bool? isLikedByMe,
    String? createdAt,
    String? updatedAt,
    UserProfileModel? author,
  }) {
    return DiscussionPostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
    );
  }
}

class CreatePostDto {
  final String title;
  final String content;
  final List<String> tags;

  const CreatePostDto({
    this.title = '',
    this.content = '',
    this.tags = const [],
  });

  factory CreatePostDto.fromMap(Map<String, dynamic> map) {
    return CreatePostDto(
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      tags: (map['tags'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'tags': tags,
      };
}
