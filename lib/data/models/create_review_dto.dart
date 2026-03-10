import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_review_dto.freezed.dart';
part 'create_review_dto.g.dart';

@freezed
class CreateReviewDto with _$CreateReviewDto {
  const factory CreateReviewDto({
    required String toUserId,
    required int rating,
    required String comment,
    @Default([]) List<String> skillsReviewed,
    String? sessionId,
  }) = _CreateReviewDto;

  factory CreateReviewDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewDtoFromJson(json);
}
