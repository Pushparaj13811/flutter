import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response_model.freezed.dart';
part 'paginated_response_model.g.dart';

class PaginatedResponseModel<T> {
  final List<T> data;
  final PaginationModel pagination;

  const PaginatedResponseModel({
    required this.data,
    required this.pagination,
  });
}

@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @Default(1) int page,
    @Default(20) int pageSize,
    @Default(0) int totalItems,
    @Default(0) int totalPages,
    @Default(false) bool hasNextPage,
    @Default(false) bool hasPreviousPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}
