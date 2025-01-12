import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:message/dtos/request/CreatePrivateChatRequest.dart';
import 'package:message/dtos/response/ApiResponse.dart';
import 'package:message/models/chat.dart';
import 'package:message/utils/json_utils.dart';

class ChatService {
  final String chat_path = "http://localhost:8080/chat";

  Future<ApiResponse<Chat>> createPrivateChatRequest(
      CreatePrivatechatrequest request) async {
    var url = Uri.parse("$chat_path/create-private");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return ApiResponse<Chat>.fromJson(
            responseData, (json) => Chat.fromJson(json));
      } else {
        return ApiResponse<Chat>(
          code: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      return ApiResponse<Chat>(message: e.toString());
    }
  }

  Future<ApiResponse<Chat>> createPublicChatRequest(
      CreatePrivatechatrequest request) async {
    var url = Uri.parse("$chat_path/create-public");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return ApiResponse<Chat>.fromJson(responseData,
            (json) => parseObject(json, (chatJson) => Chat.fromJson(chatJson)));
      } else {
        return ApiResponse<Chat>(
          code: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      return ApiResponse<Chat>(message: e.toString());
    }
  }

  Future<ApiResponse<List<Chat>>> getAllChatByUsername(String username) async {
    var url = Uri.parse("$chat_path/get-by-username?username=$username");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        ApiResponse<List<Chat>> objectResponse = ApiResponse.fromJson(
            responseData,
            (json) => parseList(json, (chatJson) => Chat.fromJson(chatJson)));

        return objectResponse;
      } else {
        return ApiResponse<List<Chat>>(
            code: response.statusCode,
            message: response.body,
            result: List.empty());
      }
    } catch (e) {
      return ApiResponse<List<Chat>>(message: e.toString(), result: []);
    }
  }

  Future<ApiResponse<Chat>> getChatById(String chatId) async {
    var url = Uri.parse("$chat_path/get-by-id/$chatId");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        return ApiResponse<Chat>.fromJson(
            responseData, (json) => Chat.fromJson(json));
      } else {
        return ApiResponse<Chat>(
          code: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      return ApiResponse<Chat>(message: e.toString());
    }
  }
}
