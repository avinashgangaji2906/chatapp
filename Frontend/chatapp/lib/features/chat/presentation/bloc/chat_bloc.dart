import 'dart:developer';
import 'package:chatapp/features/chat/domain/entity/message_entity.dart';
import 'package:chatapp/features/chat/domain/repository/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final String currentUserId;
  final String receiverId;

  ChatBloc({
    required this.chatRepository,
    required this.currentUserId,
    required this.receiverId,
  }) : super(ChatInitial()) {
    // Register message listener immediately
    chatRepository.onMessageReceived((message) {
      // Filter messages for this chat
      if (message.senderId == receiverId || message.receiverId == receiverId) {
        log('📩 Received relevant message: ${message.content}');
        add(ReceiveMessage(message));
      } else {
        log(
          '📩 Ignored message from ${message.senderId} to ${message.receiverId}',
        );
      }
    });

    on<ConnectSocket>((event, emit) async {
      try {
        await chatRepository.connectSocket(currentUserId);
      } catch (e) {
        log('❌ Error connecting socket: $e');
      }
    });

    on<SendMessage>((event, emit) {
      chatRepository.sendMessage(event.message);
      final updatedMessages = [...state.messages, event.message];
      emit(ChatUpdated(updatedMessages));
    });

    on<ReceiveMessage>((event, emit) {
      if (!state.messages.any((msg) => msg.id == event.message.id)) {
        log('📩 Processing ReceiveMessage: ${event.message.content}');
        final updatedMessages = [...state.messages, event.message];
        emit(ChatUpdated(updatedMessages));
      }
    });

    on<LoadChatHistory>((event, emit) async {
      try {
        final messages = await chatRepository.getChatHistory(
          receiverId: receiverId,
        );
        emit(ChatUpdated(messages));
      } catch (e) {
        log('❌ Error loading chat history: $e');
        emit(ChatUpdated([]));
      }
    });
  }

  Future<void> close() {
    return super.close();
  }
}
