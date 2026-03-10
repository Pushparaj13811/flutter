import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'match_score_model.freezed.dart';
part 'match_score_model.g.dart';

@freezed
class MatchScoreModel with _$MatchScoreModel {
  const factory MatchScoreModel({
    required String userId,
    required UserProfileModel profile,
    required double compatibilityScore,
    required double skillOverlapScore,
    required double availabilityScore,
    required double locationScore,
    required double languageScore,
    required MatchedSkillsModel matchedSkills,
  }) = _MatchScoreModel;

  factory MatchScoreModel.fromJson(Map<String, dynamic> json) =>
      _$MatchScoreModelFromJson(json);
}

@freezed
class MatchedSkillsModel with _$MatchedSkillsModel {
  const factory MatchedSkillsModel({
    @Default([]) List<String> theyTeach,
    @Default([]) List<String> youTeach,
  }) = _MatchedSkillsModel;

  factory MatchedSkillsModel.fromJson(Map<String, dynamic> json) =>
      _$MatchedSkillsModelFromJson(json);
}
