enum NotificationType {
  connectionRequest('connection_request'),
  connectionAccepted('connection_accepted'),
  sessionReminder('session_reminder'),
  sessionCancelled('session_cancelled'),
  newMessage('new_message'),
  reviewReceived('review_received'),
  system('system');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String s) {
    return NotificationType.values.firstWhere(
      (e) => e.value == s,
      orElse: () => NotificationType.system,
    );
  }
}

class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool read;
  final String createdAt;
  final String? actionUrl;
  final Map<String, dynamic> metadata;

  const NotificationModel({
    this.id = '',
    this.userId = '',
    this.type = NotificationType.system,
    this.title = '',
    this.message = '',
    this.read = false,
    this.createdAt = '',
    this.actionUrl,
    this.metadata = const {},
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      type: NotificationType.fromString(map['type'] as String? ?? 'system'),
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      read: map['read'] as bool? ?? false,
      createdAt: map['createdAt'] as String? ?? '',
      actionUrl: map['actionUrl'] as String?,
      metadata: map['metadata'] is Map
          ? Map<String, dynamic>.from(map['metadata'] as Map)
          : {},
    );
  }

  /// Legacy compatibility alias
  factory NotificationModel.fromJson(Map<String, dynamic> json) =
      NotificationModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'type': type.value,
        'title': title,
        'message': message,
        'read': read,
        'createdAt': createdAt,
        'actionUrl': actionUrl,
        'metadata': metadata,
      };

  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    bool? read,
    String? createdAt,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
