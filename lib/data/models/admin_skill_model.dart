import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_skill_model.freezed.dart';
part 'admin_skill_model.g.dart';

@freezed
class AdminSkillModel with _$AdminSkillModel {
  const factory AdminSkillModel({
    required String id,
    required String name,
    required String category,
    @Default(0) int usageCount,
    @Default(true) bool isActive,
    required String createdAt,
  }) = _AdminSkillModel;

  factory AdminSkillModel.fromJson(Map<String, dynamic> json) =>
      _$AdminSkillModelFromJson(json);
}
