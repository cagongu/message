import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:message/dtos/request/LoginRequest.dart';
import 'package:message/dtos/response/ApiResponse.dart';
import 'package:message/models/user.dart';
import 'package:message/dtos/request/RegisterRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String authUrl =
      "http://localhost:8080/auth"; // Replace with your actual server URL

  Future<ApiResponse<User>> register(RegisterRequest request) async {
    var url = Uri.parse("$authUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse<User>.fromJson(
            responseData, (json) => User.fromJson(json));
      } else {
        return ApiResponse<User>(
          code: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      return ApiResponse<User>(message: e.toString());
    }
  }

  Future<ApiResponse<User>> login(LoginRequest request) async {
    final url = Uri.parse('$authUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      if (response.statusCode == 204) {
        final responseData = jsonDecode(response.body);
        final user = User.fromJson(responseData);

//luu thong tin dang nhap
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user.username);

        return ApiResponse<User>(
          code: 204,
          result: user,
        );
      } else {
        return ApiResponse<User>(
          code: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      return ApiResponse<User>(message: e.toString());
    }
  }
}
