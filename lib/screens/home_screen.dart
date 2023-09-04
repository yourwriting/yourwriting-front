import 'package:flutter/material.dart';
import 'package:realwriting/screens/generator_screen.dart';
import 'package:realwriting/screens/writingpage_screen.dart';
import 'package:realwriting/style.dart';
import 'package:realwriting/widget/book.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:core';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       DateTime now = DateTime.now();
    String formattedMonth = now.month.toString().padLeft(2, '0');
    String formattedDay = now.day.toString().padLeft(2, '0');
    String formattedDate = "${now.year}-$formattedMonth-$formattedDay";

    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return const GeneratorScreen();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorStyles.mainblack,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 21,
                        ),
                      ),
                      child: const Text(
                        'my font',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 5),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: 32,
                            color: ColorStyles.mainblack.withOpacity(0.8),
                          )),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      //date,
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    const Column(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 40,
                          color: ColorStyles.mainblack, 
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 23,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(22),
                //     // boxShadow: [
                //     //   BoxShadow(
                //     //       color: ColorStyles.mainshadow.withOpacity(0.5),
                //     //       blurRadius: 4,
                //     //       offset: const Offset(0, 2))
                //     // ],
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(
                //       vertical: 200,
                //       horizontal: 190,
                //     ),
                //   ),
                // ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 21,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 131,
                            height: 168,
                            //새로운 파일 추가 버튼
                            child: DottedBorder(
                              color: ColorStyles.mainblack.withOpacity(0.6),
                              strokeWidth: 2,
                              dashPattern: const [3, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(20),
                              strokeCap: StrokeCap.round,                         
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                      return const WritingScreen();
                                    }));
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              )
                            ),
                          ),
                          const writtenBook(Date: '2023-05-22'),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 21,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          writtenBook(Date: '2023-03-31'),
                          writtenBook(Date: '2022-09-14'),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 21,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          writtenBook(Date: '2022-08-31'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
