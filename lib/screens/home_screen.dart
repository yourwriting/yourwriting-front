import 'package:flutter/material.dart';
import 'package:realwriting/screens/generator_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:realwriting/widget/book.dart';

class Note {
  final int noteId;
  final String title;
  // final String content;
  final String createdAt;
  final String updatedAt;

  Note({
    required this.noteId,
    required this.title,
    // required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON to Note object
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      title: json['title'],
      // content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

Future<List<Note>> fetchNotes() async {
  final response = await http.get(Uri.parse(
      'http://ec2-3-39-143-31.ap-northeast-2.compute.amazonaws.com:8080/api/home'));

  if (response.statusCode == 200) {
    List jsonResponse = convert.jsonDecode(response.body)['result'];
    return jsonResponse.map((item) => Note.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load notes');
  }
}

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
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 21,
                    //         vertical: 15,
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           SizedBox(
                    //             width: 131,
                    //             height: 168,
                    //             //새로운 파일 추가 버튼
                    //             child: DottedBorder(
                    //                 color: ColorStyles.mainblack.withOpacity(0.6),
                    //                 strokeWidth: 2,
                    //                 dashPattern: const [3, 4],
                    //                 borderType: BorderType.RRect,
                    //                 radius: const Radius.circular(20),
                    //                 strokeCap: StrokeCap.round,
                    //                 child: Center(
                    //                   child: IconButton(
                    //                     onPressed: () {
                    //                       Navigator.push(context,
                    //                           MaterialPageRoute<void>(
                    //                               builder: (BuildContext context) {
                    //                         return const WritingScreen();
                    //                       }));
                    //                     },
                    //                     icon: const Icon(Icons.add),
                    //                   ),
                    //                 )),
                    //           ),
                    //           const WrittenBook(date: '2023-05-22'),
                    //         ],
                    //       ),
                    //     ),
                    //     const Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 21,
                    //         vertical: 15,
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           WrittenBook(date: '2023-03-31'),
                    //           WrittenBook(date: '2022-09-14'),
                    //         ],
                    //       ),
                    //     ),
                    //     const Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 21,
                    //         vertical: 15,
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           WrittenBook(date: '2022-08-31'),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // )
                    // FutureBuilder<List<Note>>(
                    //   future: fetchNotes(),
                    //   builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return const CircularProgressIndicator();
                    //     } else if (snapshot.hasError) {
                    //       return const Text('Error occurred');
                    //     } else {
                    //       return ListView.builder(
                    //         padding: const EdgeInsets.symmetric(vertical :15),
                    //         itemCount: snapshot.data!.length +1,
                    //         itemBuilder :(BuildContext context,int index){
                    //           if(index ==0 ){
                    //             // Add button
                    //             return IconButton(
                    //               onPressed: () {},
                    //               icon: const Icon(Icons.add),
                    //             );
                    //           }else{
                    //             return WrittenBook(date: snapshot.data![index -1].createdAt);
                    //           }
                    //         });
                    //     }
                    //   },
                    // )
                    FutureBuilder<List<Note>>(
                      future: fetchNotes(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Note>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error occurred');
                        } else {
                          // Use a Column widget to display the data
                          return Column(
                            children: snapshot.data!
                                .map((note) => WrittenBook(
                                      date: note.updatedAt,
                                      noteId: note.noteId,
                                    ))
                                .toList(),
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
