import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketClient {
  late IO.Socket socket;

  void connect(String userId) {
    socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'userId': userId})
          .build(),
    );
    socket.connect();
  }

  void onReceiveMessage(Function(dynamic) callback) {
    socket.on('message:receive', callback);
  }

  void sendMessage(Map<String, dynamic> payload) {
    socket.emit('message:send', payload);
  }

  void disconnect() => socket.disconnect();
}
