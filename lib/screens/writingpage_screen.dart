import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class WritingScreen extends StatefulWidget {
  final int? noteId;
  const WritingScreen({Key? key, this.noteId}) : super(key: key);

  @override
  WritingScreenState createState() => WritingScreenState();
}

class WritingScreenState extends State<WritingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  double textSize = 16.0;

  Future<String> fetchContent() async {
    String urlString =
        "http://ec2-3-39-143-31.ap-northeast-2.compute.amazonaws.com:8080/api/note/${widget.noteId}";
    Uri uri = Uri.parse(urlString);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['result']['content'];
    } else {
      throw Exception('Failed to load content');
    }
  }

  Future<void> updateContent(String newTitle, String newContent) async {
    String urlString =
        "http://ec2-3-39-143-31.ap-northeast-2.compute.amazonaws.com:8080/api/note/${widget.noteId}";
    Uri uri = Uri.parse(urlString);

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'}, // Add this line
      body: jsonEncode({'title': newTitle, 'content': newContent}),
    );

    if (response.statusCode == 200) {
      developer.log('데이터가 성공적으로 수정되었습니다.');
    } else {
      developer.log('데이터 수정에 실패했습니다.');
    }
  }

  @override
  void initState() {
    super.initState();

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
    List<double> textSizeOptions = [14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0];

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
                iconSize: 40,
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
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                // IconButton(
                //   onPressed: () {
                //   },
                //   icon: const Icon(
                //     Icons.text_fields_outlined,
                //     size: 30,
                //   ),
                // ),
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
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await updateContent('제목바꿨다', _textEditingController.text);
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
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<String>(
                  future: fetchContent(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return TextField(
                        focusNode: focusNode,
                        controller: _textEditingController,
                        onChanged: (value) {
                          // 텍스트 필드 값이 변경될 때마다 수정된 내용 전송
                        },
                        style: TextStyle(
                            fontFamily: 'your-writing-thin', fontSize: textSize),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: '오늘의 글을 적어보세요.',
                          border: InputBorder.none,
                        ),
                      );
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
