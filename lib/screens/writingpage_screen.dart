import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';

class WritingScreen extends StatefulWidget {
  final String accessToken;
  final int? noteId;
  final String? date;
  const WritingScreen(
      {Key? key, this.noteId, this.date, required this.accessToken})
      : super(key: key);

  @override
  WritingScreenState createState() => WritingScreenState();
}

class WritingScreenState extends State<WritingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  late String accessToken;
  // "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJybGoiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTY5ODczNDczNSwiZXhwIjo0MjkwNzM0NzM1fQ.WpulBwf6CLFO1tFvgw9FqAxAK22-fihbf1zrFbhpph6S8lKCHqj4_zcrJGeYBPQ5Im9TjTss9_siRoeclrHNUA";
  double textSize = 20.0;
  String? imagePath;
  String? imageUrl;

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
      //   var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      //   return jsonResponse['result']['content'];
      // } else {
      //   throw Exception('Failed to load content');
      // }
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse['result']['fileResList'].isNotEmpty) {
        // 이미지 URL 저장
        imageUrl = jsonResponse['result']['fileResList'][0]['fileUrl'];
      }
      return jsonResponse['result']['content'];
    } else {
      throw Exception('Failed to load content');
    }
  }

  Future<void> updateContent(String newTitle, String newContent,
      [String? imagePath]) async {
    String urlString =
        "http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/note/${widget.noteId}";
    Uri uri = Uri.parse(urlString);

    var request = http.MultipartRequest(
      'PUT',
      uri,
    );
    request.headers.addAll(<String, String>{
      'Authorization': accessToken,
    });

    // request.fields['input'] =
    //     jsonEncode({'title': newTitle, 'content': newContent});
    request.files.add(http.MultipartFile.fromString(
      'input',
      jsonEncode({'title': newTitle, 'content': newContent}),
      contentType: MediaType('application', 'json'),
    ));

    if (imagePath != null) {
      print("imagePath: $imagePath");
      //이미지가 제공되었을 경우, 이미지를 요청에 추가합니다.
      // request.files.add(await http.MultipartFile.fromPath(
      //   'files',
      //   imagePath,
      // ));
      try {
        var multipartFile = await http.MultipartFile.fromPath(
          'files',
          imagePath,
        );
        print('MultipartFile created successfully: $multipartFile');
        request.files.add(multipartFile);
      } catch (e) {
        print('Failed to create MultipartFile: $e');
      }
      final imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        print('파일이 존재합니다.');
      } else {
        print('파일이 존재하지 않습니다.');
      }
    }

    var response = await request.send();
    print('Request sent successfully: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('데이터가 성공적으로 수정되었습니다.');
    } else {
      print('데이터 수정에 실패했습니다.');
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
      print('Font uploading...');
      var fontLoader = FontLoader('font');
      fontLoader.addFont(
          Future.value(ByteData.view(fontFile.readAsBytesSync().buffer)));
      await fontLoader.load();
      print('Font loaded');
    } else {
      print('Font file does not exist');
    }
  }

  @override
  void initState() {
    super.initState();
    accessToken = widget.accessToken;
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
    final FocusNode focusNode = FocusNode();
    List<double> textSizeOptions = [20.0, 21.0, 22.0, 23.0, 24.0, 25.0];

    return Scaffold(
      backgroundColor: ColorStyles.mainbackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return HomeScreen(
                        accessToken: accessToken,
                      );
                    }));
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: ColorStyles.blue,
                        size: 30,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                            fontFamily: 'SF-Pro-Display-Regular',
                            fontSize: 18,
                            color: ColorStyles.blue),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (imagePath != null) {
                        // Done 버튼을 눌렀을 때, imagePath 변수에 저장된 이미지를 업로드합니다.
                        await updateContent(_titleEditingController.text,
                            _textEditingController.text, imagePath);
                      } else {
                        await updateContent(_titleEditingController.text,
                            _textEditingController.text);
                      }
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
                    'Done',
                    style: TextStyle(
                      color: ColorStyles.blue,
                      fontFamily: "SF-Pro-Display-Regular",
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      // Row(
                      //   children: [
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text(
                      //       widget.date != null
                      //           ? '${widget.date}'
                      //           : formattedDate,
                      //       style: const TextStyle(
                      //         fontSize: 18,
                      //         fontFamily: "Pretendard-Regular",
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
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
                            fontFamily: 'font',
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                            hintText: '제목을 적어보세요', border: InputBorder.none),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // ConstrainedBox(
                      //   constraints:
                      //       const BoxConstraints(maxHeight: 550), // 높이 제한 설정
                      SizedBox(
                        height: 520,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            TextField(
                              focusNode: focusNode,
                              controller: _textEditingController,
                              onChanged: (value) {},
                              style: TextStyle(
                                  fontFamily: 'font',
                                  fontSize: textSize,
                                  height: 1.25,
                                  fontWeight: FontWeight.w400),
                              maxLines: null,
                              decoration: const InputDecoration(
                                  hintText: '오늘의 글을 적어보세요.',
                                  border: InputBorder.none),
                            ),
                            imagePath != null
                                ? Image.file(
                                    File(imagePath!),
                                    // 이미지 크기 등을 설정하려면 여기에 추가하면 됩니다.
                                  )
                                : imageUrl != null
                                    ? Image.network(imageUrl!)
                                    : Container()
                          ]),
                        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      // 이미지가 선택되었을 때, 이미지의 경로를 imagePath 변수에 저장합니다.
                      setState(() {
                        imagePath = pickedFile.path;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
