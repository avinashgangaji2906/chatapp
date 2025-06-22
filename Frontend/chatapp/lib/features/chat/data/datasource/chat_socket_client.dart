import 'dart:developer';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chatapp/core/network/dio_client.dart';

class ChatSocketClient {
  IO.Socket? _socket;

  Future<void> connect(String userId) async {
    try {
      final dio = await DioClient.getInstance();

      // Get CookieJar safely
      final cookieManager =
          dio.interceptors.firstWhere(
                (i) => i is CookieManager,
                orElse: () => throw Exception('CookieManager not found'),
              )
              as CookieManager;
      final cookieJar = cookieManager.cookieJar;

      final uri = Uri.parse('http://192.168.69.58:3000');
      final cookies = await cookieJar.loadForRequest(uri);

      final sessionCookie = cookies.firstWhere(
        (cookie) => cookie.name == 'session',
        orElse: () => throw Exception("Session cookie not found"),
      );

      final cookieHeader = 'session=${sessionCookie.value}';

      _socket = IO.io(
        'http://192.168.69.58:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders({'cookie': cookieHeader})
            .build(),
      );

      _socket!.connect();

      _socket!.onConnect((_) {
        log('✅ Socket connected');
      });

      _socket!.onDisconnect((_) {
        log('🔌 Socket disconnected');
      });

      _socket!.onConnectError((err) {
        log('❌ Connect error: $err');
      });

      _socket!.onError((err) {
        log('❌ General error: $err');
      });
    } catch (e, stack) {
      log('❌ Error while connecting socket: $e');
      log('📌 Stacktrace:\n$stack');
    }
  }

  void onReceiveMessage(Function(dynamic) callback) {
    if (_socket?.connected == true) {
      _socket!.on('message:receive', callback);
    } else {
      log('⚠️ Tried to listen before socket connection');
    }
  }

  void sendMessage(Map<String, dynamic> payload) {
    if (_socket?.connected == true) {
      _socket!.emit('message:send', payload);
    } else {
      log('⚠️ Tried to send message before socket connection');
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.off('message:receive'); // remove listeners
      _socket!.disconnect();
      _socket = null;
      log('🔌 Socket disconnected and cleaned up');
    }
  }
}
