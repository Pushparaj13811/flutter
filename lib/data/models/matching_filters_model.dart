import 'package:freezed_annotation/freezed_annotation.dart';

part 'matching_filters_model.freezed.dart';
part 'matching_filters_model.g.dart';

@freezed
class MatchingFiltersModel with _$MatchingFiltersModel {
  const factory MatchingFiltersModel({
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    List<String>? availability,
    String? learningStyle,
    List<String>? languages,
  }) = _MatchingFiltersModel;

  factory MatchingFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingFiltersModelFromJson(json);
}
