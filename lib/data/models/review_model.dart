import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    required int rating,
    required String comment,
    @Default([]) List<String> skillsReviewed,
    String? sessionId,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}
