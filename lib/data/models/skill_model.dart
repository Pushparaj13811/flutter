import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

@JsonEnum(valueField: 'value')
enum SkillLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced'),
  expert('expert');

  const SkillLevel(this.value);
  final String value;
}

@JsonEnum(valueField: 'value')
enum SkillCategory {
  frontend('Frontend'),
  backend('Backend'),
  programming('Programming'),
  dataScience('Data Science'),
  devOps('DevOps'),
  cloud('Cloud'),
  design('Design'),
  blockchain('Blockchain'),
  security('Security'),
  mobile('Mobile'),
  other('Other');

  const SkillCategory(this.value);
  final String value;
}

@freezed
class SkillModel with _$SkillModel {
  const factory SkillModel({
    required String id,
    required String name,
    required String category,
    required SkillLevel level,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);
}
