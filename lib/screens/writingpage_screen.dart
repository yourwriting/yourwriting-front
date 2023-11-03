import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class WritingScreen extends StatefulWidget {
  final int? noteId;
  final String? date;
  const WritingScreen({Key? key, this.noteId, this.date}) : super(key: key);

  @override
  WritingScreenState createState() => WritingScreenState();
}

class WritingScreenState extends State<WritingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  String accessToken =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJybGoiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTY5ODczNDczNSwiZXhwIjo0MjkwNzM0NzM1fQ.WpulBwf6CLFO1tFvgw9FqAxAK22-fihbf1zrFbhpph6S8lKCHqj4_zcrJGeYBPQ5Im9TjTss9_siRoeclrHNUA";
  double textSize = 23.0;

  Future<String> fetchContent() async {
    String urlString =
        "http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/note/${widget.noteId}";
    Uri uri = Uri.parse(urlString);

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['result']['content'];
    } else {
      throw Exception('Failed to load content');
    }
  }

  Future<void> updateContent(String newTitle, String newContent) async {
    String urlString =
        "http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/note/${widget.noteId}";
    Uri uri = Uri.parse(urlString);

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      }, // Add this line
      body: jsonEncode({'title': newTitle, 'content': newContent}),
    );

    if (response.statusCode == 200) {
      developer.log('데이터가 성공적으로 수정되었습니다.');
    } else {
      developer.log('데이터 수정에 실패했습니다.');
    }
  }

  Future<String> fetchTitle() async {
    String urlString =
        "http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/note/${widget.noteId}";
    Uri uri = Uri.parse(urlString);

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['result']['title'];
    } else {
      throw Exception('Failed to load title');
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

  @override
  void initState() {
    super.initState();
    loadSavedFont();

    fetchTitle().then((title) {
      _titleEditingController.text = title;
    });

    // 초기에 서버에서 데이터 가져와 컨트롤러에 설정
    fetchContent().then((content) {
      _textEditingController.text = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedMonth = now.month.toString().padLeft(2, '0');
    String formattedDay = now.day.toString().padLeft(2, '0');
    String formattedDate = "${now.year}-$formattedMonth-$formattedDay";

    final FocusNode focusNode = FocusNode();
    List<double> textSizeOptions = [24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0];

    return Scaffold(
      backgroundColor: ColorStyles.mainbackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute<void>(
                    //     builder: (BuildContext context) {
                    //   return const HomeScreen();
                    // }));
                  },
                  iconSize: 31,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await updateContent(_titleEditingController.text,
                          _textEditingController.text);
                      focusNode.unfocus();
                    } catch (e) {
                      // 에러 처리 로직
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey.withOpacity(
                            0.5); // color when the button is pressed
                      }
                      return null;
                    }),
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Pretendard-Regular",
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.date != null
                                ? '${widget.date}'
                                : formattedDate,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "Pretendard-Regular",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      PopupMenuButton<double>(
                        icon: const Icon(
                          Icons.text_fields_outlined,
                          size: 30,
                        ),
                        itemBuilder: (BuildContext context) =>
                            textSizeOptions.map((double value) {
                          return PopupMenuItem<double>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onSelected: (double newValue) {
                          setState(() {
                            textSize = newValue;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.color_lens_outlined,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.image_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder<String>(
                  future: fetchContent(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: [
                        TextField(
                          // 제목 입력 필드 추가
                          controller: _titleEditingController,
                          style: const TextStyle(
                              fontFamily: 'your-writing-25',
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                              hintText: '제목을 적어보세요', border: InputBorder.none),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          focusNode: focusNode,
                          controller: _textEditingController,
                          onChanged: (value) {},
                          style: TextStyle(
                              fontFamily: 'your-writing-25',
                              fontSize: textSize,
                              height: 1.5,
                              fontWeight: FontWeight.w400),
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: '오늘의 글을 적어보세요.',
                              border: InputBorder.none),
                        ),
                      ]);
                    } else if (snapshot.hasError) {
                      return const Text('Error occurred');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
