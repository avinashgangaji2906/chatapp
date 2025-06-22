part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  List<MessageEntity> get messages => [];

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatUpdated extends ChatState {
  final List<MessageEntity> chatMessages;
  ChatUpdated(this.chatMessages);

  @override
  List<Object> get props => [chatMessages];

  @override
  List<MessageEntity> get messages => chatMessages;
}
