import 'package:message/models/chat.dart';

class User {
  String username;
  String password;
  String name;
  int age;
  String email;
  bool activeStatus;
  List<Chat>? chats;
  User(
      {required this.username,
      required this.password,
      required this.name,
      required this.age,
      required this.email,
      required this.activeStatus,
      this.chats});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
     username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      email: json['email'] ?? '',
      activeStatus: json['activeStatus'] ?? false,
      chats: json['chats'] != null
          ? (json['chats'] as List)
              .map((chatJson) => Chat.fromJson(chatJson))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'name': name,
        'age': age,
        'email': email,
        'activeStatus': activeStatus,
        if (chats != null)
          'chats': chats?.map((chat) => chat.toJson()).toList(),
      };
}
