class ActivityLogModel {
  final String id;
  final String adminName;
  final String action;
  final String targetType;
  final String targetId;
  final String details;
  final String timestamp;

  const ActivityLogModel({
    this.id = '',
    this.adminName = '',
    this.action = '',
    this.targetType = '',
    this.targetId = '',
    this.details = '',
    this.timestamp = '',
  });

  factory ActivityLogModel.fromMap(Map<String, dynamic> map) {
    return ActivityLogModel(
      id: map['id'] as String? ?? '',
      adminName: map['adminName'] as String? ?? '',
      action: map['action'] as String? ?? '',
      targetType: map['targetType'] as String? ?? '',
      targetId: map['targetId'] as String? ?? '',
      details: map['details'] as String? ?? '',
      timestamp: map['timestamp'] as String? ?? '',
    );
  }

  /// Legacy compatibility alias
  factory ActivityLogModel.fromJson(Map<String, dynamic> json) =
      ActivityLogModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'adminName': adminName,
        'action': action,
        'targetType': targetType,
        'targetId': targetId,
        'details': details,
        'timestamp': timestamp,
      };
}
