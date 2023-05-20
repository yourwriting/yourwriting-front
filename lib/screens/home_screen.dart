import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 147, 171, 207),
        child: Center(
          child: Padding(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'writing',
                hintText: '오늘의 글을 적어보세요.',
              ),
            ),
            padding: EdgeInsets.all(20.0),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color.fromARGB(255, 63, 54, 141),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          "realWriting",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
