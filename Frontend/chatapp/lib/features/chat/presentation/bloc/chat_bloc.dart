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
    on<ConnectSocket>((event, emit) {
      chatRepository.connectSocket(currentUserId);
      chatRepository.onMessageReceived((message) {
        add(ReceiveMessage(message));
      });
    });

    on<SendMessage>((event, emit) {
      chatRepository.sendMessage(event.message);
      emit(ChatUpdated([...state.messages, event.message]));
    });

    on<ReceiveMessage>((event, emit) {
      emit(ChatUpdated([...state.messages, event.message]));
    });
  }

  @override
  Future<void> close() {
    chatRepository.disconnect();
    return super.close();
  }
}
