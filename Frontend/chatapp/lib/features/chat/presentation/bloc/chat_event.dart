part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectSocket extends ChatEvent {}

class SendMessage extends ChatEvent {
  final MessageEntity message;
  SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends ChatEvent {
  final MessageEntity message;
  ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}
