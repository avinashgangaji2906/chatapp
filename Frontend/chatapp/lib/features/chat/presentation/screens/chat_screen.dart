import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/features/chat/domain/entity/message_entity.dart';
import 'package:chatapp/features/chat/domain/repository/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/widgets/message_bubble.dart';
import 'package:chatapp/features/users_list/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/chat_bloc.dart';

class ChatScreen extends StatelessWidget {
  final UserEntity receiver;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.receiver,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ChatBloc(
            chatRepository: sl<ChatRepository>(),
            currentUserId: currentUserId,
            receiverId: receiver.id,
          )..add(ConnectSocket()),
      child: _ChatView(receiver: receiver, currentUserId: currentUserId),
    );
  }
}

class _ChatView extends StatefulWidget {
  final UserEntity receiver;
  final String currentUserId;

  const _ChatView({required this.receiver, required this.currentUserId});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = MessageEntity(
      senderId: widget.currentUserId,
      receiverId: widget.receiver.id,
      content: text,
      createdAt: DateTime.now(),
    );

    context.read<ChatBloc>().add(SendMessage(message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiver.username)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final messages = state.messages;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == widget.currentUserId;

                    return MessageBubble(
                      message: msg.content,
                      timestamp: DateFormat.Hm().format(msg.createdAt),
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreenArgs {
  final UserEntity receiver;
  final String currentUserId;

  ChatScreenArgs({required this.receiver, required this.currentUserId});
}
