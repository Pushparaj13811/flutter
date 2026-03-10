import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'discussion_post_model.freezed.dart';
part 'discussion_post_model.g.dart';

@freezed
class DiscussionPostModel with _$DiscussionPostModel {
  const factory DiscussionPostModel({
    required String id,
    required String authorId,
    required String title,
    required String content,
    @Default([]) List<String> tags,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(false) bool isLikedByMe,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? author,
  }) = _DiscussionPostModel;

  factory DiscussionPostModel.fromJson(Map<String, dynamic> json) =>
      _$DiscussionPostModelFromJson(json);
}

@freezed
class CreatePostDto with _$CreatePostDto {
  const factory CreatePostDto({
    required String title,
    required String content,
    @Default([]) List<String> tags,
  }) = _CreatePostDto;

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);
}
