class Creategroupchatrequest {
  List<String> usernameList;
  String chatName;

  Creategroupchatrequest({required this.usernameList, required this.chatName});

  Map<String, dynamic> toJson() {
    return {
      'usernameList' : usernameList,
      'chatName' : chatName
    };
  }
}
