import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_report_model.freezed.dart';
part 'user_report_model.g.dart';

@freezed
class UserReportModel with _$UserReportModel {
  const factory UserReportModel({
    required String id,
    required String reportedUserId,
    String? reporterName,
    required String reason,
    required String description,
    @Default('pending') String status,
    required String createdAt,
    String? reviewedAt,
    String? reviewedBy,
  }) = _UserReportModel;

  factory UserReportModel.fromJson(Map<String, dynamic> json) =>
      _$UserReportModelFromJson(json);
}
