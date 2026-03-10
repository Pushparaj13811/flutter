class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final String createdAt;
  final bool read;
  final bool isFromMe;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    this.read = false,
    this.isFromMe = false,
  });
}
