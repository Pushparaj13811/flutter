class Connection {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String status;
  final String? message;
  final String createdAt;
  final String updatedAt;

  const Connection({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });
}
