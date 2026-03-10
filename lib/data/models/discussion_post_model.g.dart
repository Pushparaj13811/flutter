// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscussionPostModelImpl _$$DiscussionPostModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscussionPostModelImpl(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
  commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
  isLikedByMe: json['isLikedByMe'] as bool? ?? false,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  author: json['author'] == null
      ? null
      : UserProfileModel.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DiscussionPostModelImplToJson(
  _$DiscussionPostModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'authorId': instance.authorId,
  'title': instance.title,
  'content': instance.content,
  'tags': instance.tags,
  'likesCount': instance.likesCount,
  'commentsCount': instance.commentsCount,
  'isLikedByMe': instance.isLikedByMe,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'author': instance.author,
};

_$CreatePostDtoImpl _$$CreatePostDtoImplFromJson(Map<String, dynamic> json) =>
    _$CreatePostDtoImpl(
      title: json['title'] as String,
      content: json['content'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$$CreatePostDtoImplToJson(_$CreatePostDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
    };
