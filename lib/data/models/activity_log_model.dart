import 'package:cloud_firestore/cloud_firestore.dart';

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
    // Handle Timestamp or String for timestamp/createdAt
    String timestampStr = '';
    final raw = map['timestamp'] ?? map['createdAt'];
    if (raw is Timestamp) {
      timestampStr = raw.toDate().toIso8601String();
    } else if (raw is String) {
      timestampStr = raw;
    }

    return ActivityLogModel(
      id: map['id'] as String? ?? '',
      adminName: map['adminName'] as String? ?? '',
      action: map['action'] as String? ?? '',
      targetType: map['targetType'] as String? ?? '',
      targetId: map['targetId'] as String? ?? '',
      details: map['details'] as String? ?? '',
      timestamp: timestampStr,
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
