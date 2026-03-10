class NotificationEntity {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final bool read;
  final String createdAt;
  final String? actionUrl;
  final Map<String, dynamic> metadata;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.read = false,
    required this.createdAt,
    this.actionUrl,
    this.metadata = const {},
  });
}
