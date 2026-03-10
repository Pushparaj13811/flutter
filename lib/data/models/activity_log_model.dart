import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_model.freezed.dart';
part 'activity_log_model.g.dart';

@freezed
class ActivityLogModel with _$ActivityLogModel {
  const factory ActivityLogModel({
    required String id,
    required String adminName,
    required String action,
    required String targetType,
    @Default('') String targetId,
    @Default('') String details,
    required String timestamp,
  }) = _ActivityLogModel;

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogModelFromJson(json);
}
