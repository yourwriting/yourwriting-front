import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';
import 'package:realwriting/widget/book.dart';
import 'package:dotted_border/dotted_border.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                              color: ColorStyles.mainshadow.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 11.5,
                          horizontal: 23.5,
                        ),
                        child: Text(
                          'my font',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.remove_circle_outline,
                      size: 33,
                      color: ColorStyles.mainblack.withOpacity(0.8),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const Text(
                      //date,
                      '2023-05-31',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Column(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 50,
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
                  height: 13,
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

                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 135,
                            height: 163,
                            child: DottedBorder(
                              color: ColorStyles.mainblack.withOpacity(0.6),
                              strokeWidth: 2,
                              dashPattern: const [3, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(20),
                              strokeCap: StrokeCap.round,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 70,
                                  horizontal: 54,
                                ),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                          const writtenBook(Date: '2023-05-22'),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
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
                        horizontal: 32,
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
