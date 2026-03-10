// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserReportModelImpl _$$UserReportModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserReportModelImpl(
  id: json['id'] as String,
  reportedUserId: json['reportedUserId'] as String,
  reporterName: json['reporterName'] as String?,
  reason: json['reason'] as String,
  description: json['description'] as String,
  status: json['status'] as String? ?? 'pending',
  createdAt: json['createdAt'] as String,
  reviewedAt: json['reviewedAt'] as String?,
  reviewedBy: json['reviewedBy'] as String?,
);

Map<String, dynamic> _$$UserReportModelImplToJson(
  _$UserReportModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reportedUserId': instance.reportedUserId,
  'reporterName': instance.reporterName,
  'reason': instance.reason,
  'description': instance.description,
  'status': instance.status,
  'createdAt': instance.createdAt,
  'reviewedAt': instance.reviewedAt,
  'reviewedBy': instance.reviewedBy,
};
