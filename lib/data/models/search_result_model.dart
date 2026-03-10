import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'search_result_model.freezed.dart';
part 'search_result_model.g.dart';

@freezed
class SearchFiltersModel with _$SearchFiltersModel {
  const factory SearchFiltersModel({
    String? query,
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    String? availability,
    String? learningStyle,
    List<String>? languages,
  }) = _SearchFiltersModel;

  factory SearchFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersModelFromJson(json);
}

@freezed
class SearchResultModel with _$SearchResultModel {
  const factory SearchResultModel({
    @Default([]) List<UserProfileModel> users,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int pageSize,
  }) = _SearchResultModel;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);
}
