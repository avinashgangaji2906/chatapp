import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? id; // Make id nullable
  final String senderId;
  final String receiverId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  const MessageEntity({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    receiverId,
    content,
    isRead,
    createdAt,
  ];
}
