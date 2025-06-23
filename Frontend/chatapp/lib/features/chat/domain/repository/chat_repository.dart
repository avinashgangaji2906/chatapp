import 'package:chatapp/features/chat/domain/entity/message_entity.dart';

abstract class ChatRepository {
  Future<void> connectSocket(String currentUserId);
  void sendMessage(MessageEntity message);
  void onMessageReceived(Function(MessageEntity) callback);
  Future<List<MessageEntity>> getChatHistory({required String receiverId});
  void disconnect();
}
