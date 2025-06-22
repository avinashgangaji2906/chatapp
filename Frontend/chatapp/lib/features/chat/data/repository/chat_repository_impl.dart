import 'package:chatapp/features/chat/domain/entity/message_entity.dart';

import '../../domain/repository/chat_repository.dart';
import '../datasource/chat_socket_client.dart';
import '../model/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketClient client;

  ChatRepositoryImpl({required this.client});

  @override
  void connectSocket(String userId) => client.connect(userId);

  @override
  void sendMessage(MessageEntity message) {
    client.sendMessage({
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'content': message.content,
    });
  }

  @override
  void onMessageReceived(Function(MessageEntity) callback) {
    client.onReceiveMessage((data) {
      final message = MessageModel.fromJson(data);
      callback(message);
    });
  }

  @override
  void disconnect() => client.disconnect();
}
