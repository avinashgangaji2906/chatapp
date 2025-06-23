import 'dart:developer';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chatapp/core/network/dio_client.dart';

class ChatSocketClient {
  static final ChatSocketClient _instance = ChatSocketClient._internal();
  factory ChatSocketClient() => _instance;
  ChatSocketClient._internal();

  IO.Socket? _socket;
  bool _isConnecting = false;

  Future<void> connect(String userId) async {
    if (_socket != null && _socket!.connected) {
      log('⚠️ Socket already connected for UserId $userId');
      return;
    }

    if (_isConnecting) {
      log('⚠️ Connection attempt already in progress');
      return;
    }

    _isConnecting = true;

    try {
      final dio = await DioClient.getInstance();
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
      log('📦 Cookie Header: $cookieHeader');

      _socket = IO.io(
        'http://192.168.69.58:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setTimeout(10000)
            .enableReconnection()
            .setReconnectionDelay(1000) // Delay between reconnection attempts
            .setReconnectionAttempts(5) // Max reconnection attempts
            .setExtraHeaders({'cookie': cookieHeader})
            .build(),
      );

      _socket!.onConnect((_) {
        log('✅ Socket connected with UserId $userId');
        _isConnecting = false;
      });

      _socket!.onConnectError((err) {
        log('❌ Connect error: $err');
        _isConnecting = false;
      });

      _socket!.onError((err) {
        log('❌ Socket error: $err');
      });

      _socket!.onDisconnect((reason) {
        log('🔌 Socket disconnected: $reason');
        _isConnecting = false;
      });

      _socket!.onReconnect((attempt) {
        log('🔄 Socket reconnected on attempt: $attempt');
      });

      // Debug all incoming events
      _socket!.onAny((event, data) {
        log('📡 Received socket event: $event with data: $data');
      });

      _socket!.connect();
    } catch (e, stack) {
      log('❌ Error connecting socket: $e');
      log('📌 Stacktrace: $stack');
      _isConnecting = false;
    }
  }

  void onReceiveMessage(Function(dynamic) callback) {
    if (_socket == null) {
      log('⚠️ Socket not initialized');
      return;
    }
    _socket!.on('message:receive', (data) {
      log('📬 Received message: $data');
      callback(data);
    });
  }

  void sendMessage(Map<String, dynamic> payload) {
    if (_socket?.connected == true) {
      log('📤 Sending message: $payload');
      _socket!.emit('message:send', payload);
    } else {
      log('⚠️ Cannot send message: Socket not connected');
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.off('message:receive');
      _socket!.disconnect();
      _socket = null;
      log('🔌 Socket disconnected and cleaned up');
    }
  }

  bool get isConnected => _socket?.connected ?? false;
}
