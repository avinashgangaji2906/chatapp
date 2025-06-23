import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/features/chat/domain/entity/message_entity.dart';
import 'package:chatapp/features/chat/domain/repository/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/widgets/message_bubble.dart';
import 'package:chatapp/features/users_list/domain/entity/user_list_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/chat_bloc.dart';

class ChatScreen extends StatelessWidget {
  final UserListEntity receiver;
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
          (_) =>
              ChatBloc(
                  chatRepository: sl<ChatRepository>(),
                  currentUserId: currentUserId,
                  receiverId: receiver.id,
                )
                ..add(LoadChatHistory())
                ..add(ConnectSocket()),
      child: _ChatView(receiver: receiver, currentUserId: currentUserId),
    );
  }
}

class _ChatView extends StatefulWidget {
  final UserListEntity receiver;
  final String currentUserId;

  const _ChatView({required this.receiver, required this.currentUserId});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = MessageEntity(
      id: null,
      senderId: widget.currentUserId,
      receiverId: widget.receiver.id,
      content: text,
      isRead: false,
      createdAt: DateTime.now(),
    );

    context.read<ChatBloc>().add(SendMessage(message));
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiver.username)),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatUpdated) {
                  print(
                    '🖥️ ChatUpdated with ${state.messages.length} messages',
                  );
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                final messages = state.messages;
                print('🖥️ Building UI with ${messages.length} messages');
                return ListView.builder(
                  controller: _scrollController,
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
                      timestamp: DateFormat(
                        'h:mm a',
                      ).format(msg.createdAt.toLocal()),
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
                    onSubmitted: (_) => _sendMessage(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  iconSize: 28,
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatScreenArgs {
  final UserListEntity receiver;
  final String currentUserId;

  ChatScreenArgs({required this.receiver, required this.currentUserId});
}
