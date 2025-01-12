import 'dart:convert';

import 'package:message/dtos/request/SendMessageRequest.dart';
import 'package:message/dtos/response/ApiResponse.dart';
import 'package:message/models/message.dart';
import 'package:message/utils/json_utils.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class MessageService {
  final String url = 'http://localhost:8080/ws';

  StompClient? _stompClient;
  late Function(Message message) onMessageReceived;

  void initialize() {
    _stompClient = StompClient(
        config: StompConfig.sockJS(
      url: url,
      onConnect: onConnectCallback,
      onWebSocketError: (error) {
        print('WebSocket error: $error'); // Log khi có lỗi kết nối
      },
      onStompError: (frame) {
        print('STOMP error: ${frame.body}'); // Log khi có lỗi STOMP
      },
    ));

    try {
      _stompClient?.activate();
      print('WebSocket connection activated');
    } catch (e) {
      print(
          'Error activating WebSocket: $e'); // Log khi có lỗi khi kích hoạt kết nối
    }
  }

   void onConnectCallback(StompFrame frame) {
    _stompClient?.subscribe(
      destination: '/chat-app/messages',
      callback: (frame) {
        // Kiểm tra frame.body không null
        if (frame.body != null) {
          try {
            final responseData = jsonDecode(frame.body!);
            // Sử dụng ApiResponse để parse dữ liệu
            ApiResponse<Message> objectResponse = ApiResponse.fromJson(
              responseData,
              (json) => parseObject(json, (messageJson) => Message.fromJson(messageJson)),
            );
            // Gọi hàm callback để xử lý message
            onMessageReceived(objectResponse.result!);
          } catch (e) {
            print("Error decoding message: $e"); // Log lỗi khi giải mã JSON
          }
        } else {
          print("Received empty frame body");
        }
      },
    );
  }

  void sendMessage(SendMessageRequest request) {
    final body = jsonEncode(request.toJson());

    try {
      _stompClient?.send(
        destination: "/app/send-message",
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      // Xử lý lỗi khi gửi tin nhắn
      print("Error sending message: $e");
    }
  }

  void disconnect() {
    _stompClient?.deactivate();
  }
}
