import 'package:message/models/user.dart';

class Message {
  String id;
  User sender;
  DateTime time;
  String content;
  Message(
      {required this.id,
      required this.sender,
      required this.time,
      required this.content,
      });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: User.fromJson(json['sender']),
      time: DateTime.parse(json['time']),
      content: json['content'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'time': time.toIso8601String(),
      'content': content,
      
    };
  }
}
