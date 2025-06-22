import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            Text(timestamp, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
