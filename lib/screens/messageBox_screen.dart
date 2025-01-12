import 'package:flutter/material.dart';
import 'package:message/dtos/request/SendMessageRequest.dart';
import 'package:message/models/chat.dart';
import 'package:message/models/message.dart';
import 'package:message/services/message_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageBoxScreen extends StatefulWidget {
  final Chat chat;
  final MessageService messageService;
  const MessageBoxScreen(
      {Key? key, required this.chat, required this.messageService})
      : super(key: key);

  @override
  _MessageBoxScreenState createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.messageService.onMessageReceived = (Message message) {
      setState(() {
        widget.chat.messageList ??= [];
        if (!widget.chat.messageList!.any((m) => m.id == message.id)) {
          widget.chat.messageList!.add(message);
        }
      });
    };
    widget.messageService.initialize();
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username')?? '';
  }

  Future<void> _sendMessage() async {
    String messageContent = textController.text.trim();
    String sender = 'hoainguyen';
    if (messageContent.isNotEmpty && sender.length >= 3) {
      debugPrint("Gửi tin nhắn: $messageContent");
      SendMessageRequest _request = SendMessageRequest(
        chatId: widget.chat.chatId!,
        sender: sender,
        context: messageContent,
      );

      widget.messageService.sendMessage(_request);

      textController.clear();
    } else {
      print("Tin nhắn không được gửi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.chatName ?? 'Chat'),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
          IconButton(icon: Icon(Icons.info), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Divider(thickness: 1),
          Expanded(
            child: widget.chat.messageList == null ||
                    widget.chat.messageList!.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                              'https://img.freepik.com/free-photo/person-washing-carrots-kitchen_23-2150316427.jpg?t=st=1735806975~exp=1735810575~hmac=93efac70511c48327a17b4d182b3c68441960ff2f303c0249e14d9cde07e2ce5&w=1060'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.chat.chatName ?? 'Người dùng',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'van.namm2410',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Các bạn là bạn bè trên Facebook',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.chat.messageList!.length,
                    itemBuilder: (context, index) {
                      widget.chat.messageList!.sort((a, b) => a.time.compareTo(b.time));
                      final message = widget.chat.messageList![index];
                      final isSender = message.sender.username ==  'hoainguyen';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isSender)
                                CircleAvatar(
                                  child: Text(message.sender.name[0]
                                      .toUpperCase()), // Avatar cho sender khác
                                ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSender
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (!isSender)
                                        Text(
                                          message.sender.username,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      Text(
                                        message.content,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        message.time
                                            .toIso8601String(), // Thời gian gửi
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Logic mở giao diện thêm file/tin nhắn
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Nhắn tin...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // Gọi phương thức gửi tin nhắn
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true, // Đảm bảo giao diện không bị bàn phím che
    );
  }
}
