import 'package:skill_exchange/data/models/user_profile_model.dart';

enum ConnectionStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  const ConnectionStatus(this.value);
  final String value;

  static ConnectionStatus fromString(String s) {
    return ConnectionStatus.values.firstWhere(
      (e) => e.value == s,
      orElse: () => ConnectionStatus.pending,
    );
  }
}

class ConnectionModel {
  final String id;
  final String fromUserId;
  final String toUserId;
  final ConnectionStatus status;
  final String? message;
  final String createdAt;
  final String updatedAt;
  final UserProfileModel? fromUser;
  final UserProfileModel? toUser;

  const ConnectionModel({
    this.id = '',
    this.fromUserId = '',
    this.toUserId = '',
    this.status = ConnectionStatus.pending,
    this.message,
    this.createdAt = '',
    this.updatedAt = '',
    this.fromUser,
    this.toUser,
  });

  factory ConnectionModel.fromMap(Map<String, dynamic> map) {
    return ConnectionModel(
      id: map['id'] as String? ?? '',
      fromUserId: map['fromUserId'] as String? ?? '',
      toUserId: map['toUserId'] as String? ?? '',
      status:
          ConnectionStatus.fromString(map['status'] as String? ?? 'pending'),
      message: map['message'] as String?,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      fromUser: map['fromUser'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['fromUser'] as Map))
          : null,
      toUser: map['toUser'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['toUser'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory ConnectionModel.fromJson(Map<String, dynamic> json) =
      ConnectionModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'status': status.value,
        'message': message,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  ConnectionModel copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    ConnectionStatus? status,
    String? message,
    String? createdAt,
    String? updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  }) {
    return ConnectionModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
    );
  }
}
