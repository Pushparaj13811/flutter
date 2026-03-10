import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'update_profile_dto.freezed.dart';
part 'update_profile_dto.g.dart';

@freezed
class UpdateProfileDto with _$UpdateProfileDto {
  const factory UpdateProfileDto({
    String? fullName,
    String? bio,
    String? location,
    String? timezone,
    List<String>? languages,
    List<SkillModel>? skillsToTeach,
    List<SkillModel>? skillsToLearn,
    List<String>? interests,
    AvailabilityModel? availability,
    String? preferredLearningStyle,
  }) = _UpdateProfileDto;

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);
}
