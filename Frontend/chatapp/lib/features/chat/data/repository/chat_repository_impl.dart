import 'dart:convert';
import 'dart:developer';

import 'package:chatapp/features/chat/data/datasource/chat_data_source.dart';
import 'package:chatapp/features/chat/domain/entity/message_entity.dart';

import '../../domain/repository/chat_repository.dart';
import '../datasource/chat_socket_client.dart';
import '../model/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketClient client;
  final ChatDataSource chatDataSource;

  ChatRepositoryImpl({required this.client, required this.chatDataSource});

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
      try {
        // Handle both raw JSON string or already parsed map
        Map<String, dynamic> json;

        if (data is String) {
          json = jsonDecode(data);
        } else if (data is Map<String, dynamic>) {
          json = data;
        } else {
          log('⚠️ Unsupported message format: $data');
          return;
        }

        final message = MessageModel.fromJson(json);
        callback(message);
      } catch (e, stack) {
        log(' Error parsing incoming message: $e');
        log(' Stack trace: $stack');
      }
    });
  }

  @override
  Future<List<MessageEntity>> getChatHistory({
    required String receiverId,
  }) async {
    // Directly return since chatDataSource returns List<MessageModel>
    return await chatDataSource.getChatHistory(receiverId);
  }

  @override
  void disconnect() => client.disconnect();
}
