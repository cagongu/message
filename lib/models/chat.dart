import 'package:message/models/message.dart';
import 'package:message/models/user.dart';

class Chat {
  String? chatId;
  String? chatName;
  String? chatType;
  List<User>? users;
  String? lastModifier;
  List<Message>? messageList;

  Chat({
    this.chatId,
    this.chatName,
    this.chatType,
    this.users,
    this.lastModifier,
    this.messageList,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      chatName: json['chatName'],
      chatType: json['chatType'],
      users: (json['users'] as List?)
          ?.map((userJson) => User.fromJson(userJson))
          .toList(),
      lastModifier: json['lastModifier'],
      messageList: (json['messageList'] as List?)
          ?.map((e) => Message.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'chatName': chatName,
      'chatType': chatType,
      if (users != null) 
      'users': users?.map((e) => e.toJson()).toList(),
      'lastModifier': lastModifier,
      if (messageList != null)
        'messageList': messageList?.map((e) => e.toJson()).toList(),
    };
  }
}
