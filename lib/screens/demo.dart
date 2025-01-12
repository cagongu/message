import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Layout Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cột 1 chứa 2 hàng
              Column(
                children: [
                  Text('Row 1'),
                  Text('Row 2'),
                ],
              ),
              SizedBox(width: 10),
              // Cột 2 chứa 2 cột con
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Column 2A')),
                        Expanded(child: Text('Column 2B')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Column 2A')),
                        Expanded(child: Text('Column 2B')),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              // Cột 3
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-photo/person-washing-carrots-kitchen_23-2150316427.jpg?t=st=1735806975~exp=1735810575~hmac=93efac70511c48327a17b4d182b3c68441960ff2f303c0249e14d9cde07e2ce5&w=1060',
                    ),
                  ),
                  Text('Hồ Phúc Thái'),
                  Text('HoPhucThai413a@gmail.com'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
