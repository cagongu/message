import 'package:flutter/material.dart';
import 'package:message/models/chat.dart';
import 'package:message/screens/messageBox_screen.dart';
import 'package:message/services/chat_service.dart';
import 'package:message/services/message_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatService _chatService = ChatService();
  final MessageService _messageService = MessageService();
  List<Chat> _chatList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      // thay username set cung bang lay tu sharereferences
      String username = 'hoainguyen';
      if (username != null) {
        final response = await _chatService.getAllChatByUsername(username);

        if (response.code == 200 && response.result != null) {
          setState(() {
            _chatList = response.result!;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = response.message;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = "Username not found in SharedPreferences.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đoạn chat",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 15),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-photo/person-washing-carrots-kitchen_23-2150316427.jpg?t=st=1735806975~exp=1735810575~hmac=93efac70511c48327a17b4d182b3c68441960ff2f303c0249e14d9cde07e2ce5&w=1060',
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Hồ Phúc Thái',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('HoPhucThai413'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  children: [],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Đoạn chat'),
              trailing: const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue,
                child: Text('4',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Marketplace'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Tin nhắn đang chờ'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Kho lưu trữ'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Lời mời kết bạn'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Tạo cộng đồng'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    final chat = _chatList[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/login_image.png'),
                      ),
                      title: Text(chat.chatName ?? ''),
                      subtitle: Text(chat.chatType ?? ''),
                      // trailing: Text(chat.lastModifier as String),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageBoxScreen(
                                chat: chat, messageService: _messageService),
                          ),
                        );
                      },
                    );
                  }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
