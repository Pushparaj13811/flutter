import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_post_model.freezed.dart';
part 'admin_post_model.g.dart';

@freezed
class AdminPostModel with _$AdminPostModel {
  const factory AdminPostModel({
    required String id,
    required String authorName,
    String? authorAvatar,
    required String content,
    @Default('') String skillTag,
    @Default(0) int likesCount,
    @Default(0) int repliesCount,
    @Default(false) bool isPinned,
    @Default(false) bool isHidden,
    required String createdAt,
  }) = _AdminPostModel;

  factory AdminPostModel.fromJson(Map<String, dynamic> json) =>
      _$AdminPostModelFromJson(json);
}
