import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_circle_model.freezed.dart';
part 'admin_circle_model.g.dart';

@freezed
class AdminCircleModel with _$AdminCircleModel {
  const factory AdminCircleModel({
    required String id,
    required String name,
    @Default('') String description,
    @Default(0) int memberCount,
    @Default(false) bool isFeatured,
    @Default(true) bool isActive,
    required String createdAt,
    String? imageUrl,
  }) = _AdminCircleModel;

  factory AdminCircleModel.fromJson(Map<String, dynamic> json) =>
      _$AdminCircleModelFromJson(json);
}
