// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminPostModelImpl _$$AdminPostModelImplFromJson(Map<String, dynamic> json) =>
    _$AdminPostModelImpl(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String?,
      content: json['content'] as String,
      skillTag: json['skillTag'] as String? ?? '',
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      repliesCount: (json['repliesCount'] as num?)?.toInt() ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$AdminPostModelImplToJson(
  _$AdminPostModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'authorName': instance.authorName,
  'authorAvatar': instance.authorAvatar,
  'content': instance.content,
  'skillTag': instance.skillTag,
  'likesCount': instance.likesCount,
  'repliesCount': instance.repliesCount,
  'isPinned': instance.isPinned,
  'isHidden': instance.isHidden,
  'createdAt': instance.createdAt,
};
