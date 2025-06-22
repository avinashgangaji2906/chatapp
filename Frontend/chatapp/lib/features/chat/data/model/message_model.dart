import 'package:chatapp/features/chat/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
