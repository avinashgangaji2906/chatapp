import 'dart:convert';
import 'dart:developer';
import 'package:chatapp/features/chat/data/datasource/chat_data_source.dart';
import 'package:chatapp/features/chat/data/datasource/chat_socket_client.dart';
import 'package:chatapp/features/chat/data/model/message_model.dart';
import 'package:chatapp/features/chat/domain/entity/message_entity.dart';
import 'package:chatapp/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketClient client;
  final ChatDataSource chatDataSource;

  ChatRepositoryImpl({required this.client, required this.chatDataSource});

  @override
  Future<void> connectSocket(String userId) async {
    await client.connect(userId);
  }

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
    log('📥 Registering message listener in repository');
    client.onReceiveMessage((data) {
      try {
        Map<String, dynamic> json;
        if (data is String) {
          json = jsonDecode(data);
        } else if (data is Map<String, dynamic>) {
          json = data;
        } else {
          log('⚠️ Unsupported message format: $data');
          return;
        }

        log('📋 Parsed JSON: $json');

        if (!json.containsKey('senderId') ||
            !json.containsKey('receiverId') ||
            !json.containsKey('content')) {
          log('⚠️ Invalid message payload: $json');
          return;
        }

        final message = MessageModel.fromJson(json);
        log('✅ Parsed message: ${message.content}');
        log('📤 Invoking message callback with: ${message.content}');
        callback(message);
      } catch (e, stack) {
        log('❌ Error parsing message: $e');
        log('📌 Stack trace: $stack');
      }
    });
  }

  @override
  Future<List<MessageEntity>> getChatHistory({
    required String receiverId,
  }) async {
    return await chatDataSource.getChatHistory(receiverId);
  }

  @override
  void disconnect() => client.disconnect();
}
