import 'package:message/models/user.dart';

class CreatePrivatechatrequest {
  User user1;
  User user2;

  CreatePrivatechatrequest({required this.user1, required this.user2});

  Map<String, dynamic> toJson() {
    return {
      'user1' : user1,
      'user2' : user2
    };
  }
}
