import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Transform.translate(
                offset: const Offset(-150, 0),
                child: IconButton(
                  onPressed: () {},
                  iconSize: 55,
                  icon: const Icon(Icons.arrow_circle_left_outlined),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Transform.translate(
                offset: const Offset(-100, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorStyles.mainblack,
                    backgroundColor: const Color(0xFFD7E1CA),
                    shape: const CircleBorder(
                      eccentricity: 1.0,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 35,
                    ),
                  ),
                  child: const Text(
                    'template',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 220,
                    horizontal: 60,
                  ),
                  child: Text(
                    '템플릿을 다운받아 글씨를 적고,\n적은 이미지파일을 업로드 해주세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Transform.translate(
                offset: const Offset(110, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorStyles.mainblack,
                    backgroundColor: const Color(0xFFD7E1CA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 35,
                    ),
                  ),
                  child: const Text(
                    'upload',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
