import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorStyles.mainbackground,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'writing',
                hintText: '오늘의 글을 적어보세요.',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
