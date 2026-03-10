class Conversation {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final String? lastMessageAt;
  final int unreadCount;
  final String updatedAt;

  const Conversation({
    required this.id,
    this.participants = const [],
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    required this.updatedAt,
  });
}
