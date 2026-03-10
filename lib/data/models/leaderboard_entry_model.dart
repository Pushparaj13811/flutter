import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'leaderboard_entry_model.freezed.dart';
part 'leaderboard_entry_model.g.dart';

@freezed
class LeaderboardEntryModel with _$LeaderboardEntryModel {
  const factory LeaderboardEntryModel({
    required String userId,
    required int rank,
    @Default(0) int points,
    @Default(0) int sessionsCompleted,
    @Default(0) int reviewsGiven,
    @Default(0.0) double averageRating,
    UserProfileModel? user,
  }) = _LeaderboardEntryModel;

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);
}
