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
    return UserReportModel(
      id: map['id'] as String? ?? '',
      reportedUserId: map['reportedUserId'] as String? ?? '',
      reporterName: map['reporterName'] as String?,
      reason: map['reason'] as String? ?? '',
      description: map['description'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      createdAt: map['createdAt'] as String? ?? '',
      reviewedAt: map['reviewedAt'] as String?,
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
