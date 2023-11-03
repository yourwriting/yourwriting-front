import 'package:flutter/material.dart';
import 'package:realwriting/screens/generator_screen.dart';
import 'package:realwriting/screens/writingpage_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:realwriting/widget/book.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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

Future<void> loadSavedFont() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  File fontFile = File('${appDocDir.path}/font.ttf');

  if (await fontFile.exists()) {
    var fontLoader = FontLoader('MyFont');
    fontLoader.addFont(
        Future.value(ByteData.view(fontFile.readAsBytesSync().buffer)));
    await fontLoader.load();
  }
}

class HomeScreen extends StatefulWidget {
  final String accessToken;
  final int? noteId;
  const HomeScreen({Key? key, this.noteId, required this.accessToken})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String accessToken;
  //"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJybGoiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTY5ODczNDczNSwiZXhwIjo0MjkwNzM0NzM1fQ.WpulBwf6CLFO1tFvgw9FqAxAK22-fihbf1zrFbhpph6S8lKCHqj4_zcrJGeYBPQ5Im9TjTss9_siRoeclrHNUA";
  late Future<List<Note>> futureNotes;

  @override
  void initState() {
    super.initState();
    futureNotes = fetchNotes();
    accessToken = widget.accessToken;
    loadSavedFont();
  }

  Future<List<Note>> fetchNotes() async {
    final response = await http.get(
      Uri.parse(
          'http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/home'),
      headers: <String, String>{
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse =
          convert.jsonDecode(convert.utf8.decode(response.bodyBytes))['result'];
      return jsonResponse.map((item) => Note.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<int> createNote() async {
    String urlString =
        "http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/note";
    Uri uri = Uri.parse(urlString);

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken,
      },
      body: convert.jsonEncode(<String, String>{
        'title': '',
        'content': '',
      }),
    );

    if (response.statusCode == 201) {
      // Parse the noteId from the response body
      var jsonResponse = convert.jsonDecode(response.body);
      int noteId =
          jsonResponse['result']['noteId']; // Extract noteId from result
      return noteId;
    } else {
      throw Exception('Failed to create a new note');
    }
  }

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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          style: TextStyle(fontFamily: "Pretendard-Regular"),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          Text(
                            //date,
                            formattedDate,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: "Pretendard-Regular"),
                          ),
                          const SizedBox(
                            height: 7,
                          )
                        ],
                      ),
                      const Column(
                        children: [
                          Icon(
                            Icons.settings,
                            size: 40,
                            color: ColorStyles.mainblack,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 335,
                      height: 160,
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
                                createNote().then((newNoteId) {
                                  Navigator.push(context,
                                      MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return WritingScreen(noteId: newNoteId);
                                    },
                                  ));
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<Note>>(
                      future: futureNotes,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Note>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // 데이터 로딩 중일 때 보여줄 UI
                        } else if (snapshot.hasError) {
                          return const Text('Error occurred'); // 에러 발생 시 보여줄 UI
                        } else {
                          // 데이터 로딩이 완료되었을 때 보여줄 UI
                          return Column(
                            children: snapshot.data!
                                .map((note) => WrittenBook(
                                    date: note.createdAt,
                                    title: note.title,
                                    noteId: note.noteId,
                                    onDelete: () {
                                      setState(() {
                                        futureNotes = fetchNotes();
                                      });
                                    }))
                                .toList(),
                          );
                        }
                      },
                    ),
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
