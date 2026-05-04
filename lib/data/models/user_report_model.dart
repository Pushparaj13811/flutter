import 'package:cloud_firestore/cloud_firestore.dart';

class UserReportModel {
  final String id;
  final String reportedUserId;
  final String? reporterName;
  final String reason;
  final String description;
  final String status;
  final String createdAt;
  final String? reviewedAt;
  final String? reviewedBy;

  const UserReportModel({
    this.id = '',
    this.reportedUserId = '',
    this.reporterName,
    this.reason = '',
    this.description = '',
    this.status = 'pending',
    this.createdAt = '',
    this.reviewedAt,
    this.reviewedBy,
  });

  factory UserReportModel.fromMap(Map<String, dynamic> map) {
    // Handle Timestamp or String for createdAt
    String createdAtStr = '';
    final raw = map['createdAt'];
    if (raw is Timestamp) {
      createdAtStr = raw.toDate().toIso8601String();
    } else if (raw is String) {
      createdAtStr = raw;
    }

    String reviewedAtStr = '';
    final rawReviewed = map['reviewedAt'];
    if (rawReviewed is Timestamp) {
      reviewedAtStr = rawReviewed.toDate().toIso8601String();
    } else if (rawReviewed is String) {
      reviewedAtStr = rawReviewed;
    }

    return UserReportModel(
      id: map['id'] as String? ?? '',
      reportedUserId: map['reportedUserId'] as String? ?? map['reporter'] as String? ?? '',
      reporterName: map['reporterName'] as String?,
      reason: map['reason'] as String? ?? '',
      description: map['description'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      createdAt: createdAtStr,
      reviewedAt: reviewedAtStr.isEmpty ? null : reviewedAtStr,
      reviewedBy: map['reviewedBy'] as String?,
    );
  }

  /// Legacy compatibility alias
  factory UserReportModel.fromJson(Map<String, dynamic> json) =
      UserReportModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'reportedUserId': reportedUserId,
        'reporterName': reporterName,
        'reason': reason,
        'description': description,
        'status': status,
        'createdAt': createdAt,
        'reviewedAt': reviewedAt,
        'reviewedBy': reviewedBy,
      };
}
