import 'package:chatapp/core/errors/dio_error_handler.dart';
import 'package:chatapp/features/chat/data/model/message_model.dart';
import 'package:dio/dio.dart';

class ChatDataSource {
  final Dio dio;
  ChatDataSource({required this.dio});

  Future<List<MessageModel>> getChatHistory(String receiverId) async {
    try {
      final response = await dio.get('/chat/$receiverId');

      final data = response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        final List<dynamic> messages = data['messages'];
        return messages
            .map((msgJson) => MessageModel.fromJson(msgJson))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch messages');
      }
    } catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
