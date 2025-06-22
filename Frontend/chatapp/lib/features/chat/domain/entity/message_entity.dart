class MessageEntity {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
  });
}
