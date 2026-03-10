import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'learning_circle_model.freezed.dart';
part 'learning_circle_model.g.dart';

@freezed
class LearningCircleModel with _$LearningCircleModel {
  const factory LearningCircleModel({
    required String id,
    required String name,
    required String description,
    required String creatorId,
    @Default([]) List<String> skillFocus,
    @Default(0) int membersCount,
    @Default(20) int maxMembers,
    @Default(false) bool isJoinedByMe,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? creator,
  }) = _LearningCircleModel;

  factory LearningCircleModel.fromJson(Map<String, dynamic> json) =>
      _$LearningCircleModelFromJson(json);
}

@freezed
class CreateCircleDto with _$CreateCircleDto {
  const factory CreateCircleDto({
    required String name,
    required String description,
    @Default([]) List<String> skillFocus,
    @Default(20) int maxMembers,
  }) = _CreateCircleDto;

  factory CreateCircleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCircleDtoFromJson(json);
}
