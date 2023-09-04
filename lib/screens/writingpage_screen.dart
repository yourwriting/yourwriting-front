import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:core';

class WritingScreen extends StatelessWidget {
  const WritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedMonth = now.month.toString().padLeft(2, '0');
    String formattedDay = now.day.toString().padLeft(2, '0');
    String formattedDate = "${now.year}-$formattedMonth-$formattedDay";

    return Scaffold(
      backgroundColor: ColorStyles.mainbackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          children: [  
            const SizedBox(
              height: 30,
            ),
            Transform.translate(
              offset: const Offset(-147, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return const HomeScreen();
                  }));
                },
                iconSize: 45,
                icon: const Icon(Icons.arrow_circle_left_outlined),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                  const SizedBox(
                  height: 7,
                ),
                  ],
                ),    
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.text_fields_outlined,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.color_lens_outlined,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 35,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '오늘의 글을 적어보세요.',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
