import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';

class WritingScreen extends StatelessWidget {
  const WritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.mainbackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Transform.translate(
              offset: const Offset(-160, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return const HomeScreen();
                  }));
                },
                iconSize: 55,
                icon: const Icon(Icons.arrow_circle_left_outlined),
              ),
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 25,
                ),
                const Text(
                  '2023-06-5',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  width: 60,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.text_fields_outlined,
                    size: 45,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.color_lens_outlined,
                    size: 45,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 45,
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
