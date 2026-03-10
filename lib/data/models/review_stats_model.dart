import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_stats_model.freezed.dart';
part 'review_stats_model.g.dart';

@freezed
class ReviewStatsModel with _$ReviewStatsModel {
  const factory ReviewStatsModel({
    @Default(0.0) double averageRating,
    @Default(0) int totalReviews,
    @Default({}) Map<String, int> ratingDistribution,
  }) = _ReviewStatsModel;

  factory ReviewStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatsModelFromJson(json);
}
