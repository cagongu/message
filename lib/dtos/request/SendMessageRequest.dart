class SendMessageRequest {
  String chatId;
  String sender;
  String context;

  SendMessageRequest({
    required this.chatId,
    required this.sender,
    required this.context
  });

  Map<String, dynamic> toJson(){
    return{
      'chatId' : chatId,
      'sender' : sender,
      'context' : context
    };
  }
}
