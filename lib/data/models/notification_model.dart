import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('connection_request')
  connectionRequest,
  @JsonValue('connection_accepted')
  connectionAccepted,
  @JsonValue('session_reminder')
  sessionReminder,
  @JsonValue('session_cancelled')
  sessionCancelled,
  @JsonValue('new_message')
  newMessage,
  @JsonValue('review_received')
  reviewReceived,
  @JsonValue('system')
  system,
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    @Default(false) bool read,
    required String createdAt,
    String? actionUrl,
    @Default({}) Map<String, dynamic> metadata,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
