import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class GeneratorScreen extends StatelessWidget {
  final String accessToken;
  const GeneratorScreen({Key? key, required this.accessToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.subbackground,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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
                                  fontSize: 17,
                                  color: ColorStyles.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 190),
                      Center(
                        child: DrawingSession(
                          accessToken: accessToken,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingSession extends StatefulWidget {
  final String accessToken;
  const DrawingSession({Key? key, required this.accessToken}) : super(key: key);

  @override
  _DrawingSessionState createState() => _DrawingSessionState();
}

class _DrawingSessionState extends State<DrawingSession> {
  late String accessToken = widget.accessToken;
  //"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJybGoiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTY5ODczNDczNSwiZXhwIjo0MjkwNzM0NzM1fQ.WpulBwf6CLFO1tFvgw9FqAxAK22-fihbf1zrFbhpph6S8lKCHqj4_zcrJGeYBPQ5Im9TjTss9_siRoeclrHNUA";
  List<Uint8List> images = []; // 각각의 그림에 대한 이미지 데이터를 저장할 리스트
  List<String> nowJamo = [
    "ㄱ",
    "ㄲ",
    "ㄴ",
    "ㄷ",
    "ㄸ",
    "ㄹ",
    "ㅁ",
    "ㅂ",
    "ㅃ",
    "ㅅ",
    "ㅆ",
    "ㅇ",
    "ㅈ",
    "ㅉ",
    "ㅊ",
    "ㅋ",
    "ㅌ",
    "ㅍ",
    "ㅎ",
    "ㅏ",
    "ㅐ",
    "ㅑ",
    "ㅒ",
    "ㅓ",
    "ㅔ",
    "ㅕ",
    "ㅖ",
    "ㅗ",
    "ㅘ",
    "ㅙ",
    "ㅚ",
    "ㅛ",
    "ㅜ",
    "ㅝ",
    "ㅞ",
    "ㅟ",
    "ㅠ",
    "ㅡ",
    "ㅢ",
    "ㅣ"
  ];
  int currentStep = 0; // 현재 그리고 있는 글자의 인덱스
  final GlobalKey<_DrawingAreaState> _drawingAreaKey = GlobalKey();

  Future<void> captureImage(Uint8List imageBytes) async {
    // 이미지 파일 생성 (임시 파일)
    final tempDir = Directory.systemTemp;
    final file = await File('${tempDir.path}/${currentStep + 1}.PNG').create();

    // 여기서 currentStep은 현재 그리고 있는 글자의 인덱스입니다.

    await file.writeAsBytes(imageBytes);
  }

  Future<void> uploadImages() async {
    var url = Uri.parse(
        'http://ec2-43-202-176-82.ap-northeast-2.compute.amazonaws.com:5000/font/upload');
    //'http://127.0.0.1:5000/upload');
    var request = http.MultipartRequest('POST', url);

    for (int i = 1; i <= 40; i++) {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$i.PNG');

      if (await file.exists()) {
        request.files.add(await http.MultipartFile.fromPath(
          'files',
          file.path,
          contentType: MediaType('image', 'png'),
        ));
      }
    }

    var response = await request.send();

    if (response.statusCode == HttpStatus.ok) {
      print("Upload successful!");
      for (int i = 1; i <= 40; i++) {
        // 임시 파일 삭제
        final tempDir = Directory.systemTemp;
        final file = File('${tempDir.path}/$i.PNG');
        if (await file.exists()) {
          await file.delete();
        }
      }
    } else {
      print("Upload failed with status code ${response.statusCode}.");
      // 실패한 경우에도 임시 파일 삭제
      for (int i = 1; i <= 40; i++) {
        final tempDir = Directory.systemTemp;
        final file = File('${tempDir.path}/$i.PNG');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }

  Future<void> combineImages() async {
    String urlString =
        'http://ec2-43-202-176-82.ap-northeast-2.compute.amazonaws.com:5000/font/combine';
    //'http://127.0.0.1:5000/upload');

    Uri uri = Uri.parse(urlString);
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      print("Success");
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> concatImages() async {
    String urlString =
        'http://ec2-43-202-176-82.ap-northeast-2.compute.amazonaws.com:5000/font/concat';
    //'http://127.0.0.1:5000/upload');

    Uri uri = Uri.parse(urlString);
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      print("Success");
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // Future<void> createfont() async {
  //   String urlString =
  //       'http://ec2-43-202-176-82.ap-northeast-2.compute.amazonaws.com:5000/font/create';
  //   //'http://127.0.0.1:5000/upload');

  //   Uri uri = Uri.parse(urlString);
  //   final response = await http.get(
  //     uri,
  //   );

  //   if (response.statusCode == 200) {
  //     print("Success");
  //   } else {
  //     throw Exception('Failed to load notes');
  //   }
  // }

  Future<void> loadFont() async {
    var httpClient = http.Client();
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ec2-43-202-176-82.ap-northeast-2.compute.amazonaws.com:5000/font/create'));
    //'http://127.0.0.1:5000/create'));

    var response = await httpClient.send(request);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    File fontFile = File('${appDocDir.path}/font.ttf');

    //같은 이름의 파일이 있을 때는 저절로 덮어씀.
    List<int> bytes = await response.stream.toBytes();
    await fontFile.writeAsBytes(bytes);

    var fontLoader = FontLoader('font');
    fontLoader.addFont(
        Future.value(ByteData.view(fontFile.readAsBytesSync().buffer)));
    await fontLoader.load();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 70,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final drawingAreaState =
                        _drawingAreaKey.currentState as _DrawingAreaState;
                    drawingAreaState.clearDrawing();
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
                            0.3); // color when the button is pressed
                      }
                      return null;
                    }),
                  ),
                  child: const Text(
                    'erase',
                    style: TextStyle(
                        fontFamily: "SF-Pro-Display-Regular",
                        color: Colors.black,
                        fontSize: 16),
                  ),
                ),
                Text(
                  '글자: \' ${nowJamo[currentStep]} \'   ',
                  style: const TextStyle(fontFamily: "Pretendard-Regular"),
                ),
              ],
            ),
            if (images.isNotEmpty) Image.memory(images.last), // 마지막으로 그린 이미지 표시
            DrawingArea(
              key: _drawingAreaKey,
              onCapture: (imageBytes) async {
                await captureImage(imageBytes);
                if (currentStep < 39) {
                  setState(() {
                    currentStep++;
                  });
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final drawingAreaState =
                        _drawingAreaKey.currentState as _DrawingAreaState;
                    await drawingAreaState.captureAndSave();
                    if (currentStep >= 39) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text('업로드'),
                            content: const Text(
                              '모든 글자를 전송합니다.',
                              style:
                                  TextStyle(fontFamily: "Pretendard-Regular"),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      fontFamily: "SF-Pro-Display-Regular",
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  // Navigator.of(context)
                                  //     .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      ).then((_) async {
                        // After closing the dialog
                        await uploadImages();
                        //await combineImages();
                        // await concatImages();
                        // await createfont();
                        // await loadFont();
                        // Navigator.push(context, MaterialPageRoute<void>(
                        //   builder: (BuildContext context) {
                        //     return const HomeScreen(accessToken: accessToken,);
                        //   },
                        // )
                        //);
                      });
                      //uploadImages();
                    } else {
                      drawingAreaState.clearDrawing();
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
                            0.3); // color when the button is pressed
                      }
                      return null;
                    }),
                  ),
                  child: Text(
                    currentStep >= 39 ? 'upload all' : 'next',
                    style: const TextStyle(
                        fontFamily: "SF-Pro-Display-Regular",
                        color: Colors.black,
                        fontSize: 16),
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await combineImages();
                      },
                      child: const Text('Combine Images'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await concatImages();
                      },
                      child: const Text('Concat Images'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     await createfont();
                    //   },
                    //   child: const Text('Create Font'),
                    //),
                    ElevatedButton(
                      onPressed: () async {
                        await loadFont();
                      },
                      child: const Text('Load Font'),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}

class DrawingArea extends StatefulWidget {
  final Function(Uint8List) onCapture;

  const DrawingArea({Key? key, required this.onCapture}) : super(key: key);

  @override
  _DrawingAreaState createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  List<Uint8List> images = []; // 각각의 그림에 대한 이미지 데이터를 저장할 리스트

  GlobalKey globalKey = GlobalKey(); // GlobalKey 생성

  Future<void> captureAndSave() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final imageBytes = await getBytesFromCanvas(image);

    widget.onCapture(imageBytes); // capture and send the bytes to parent widget
  }

  void clearDrawing() {
    setState(() {
      lines.clear();
    });
  }

  static Future<Uint8List> getBytesFromCanvas(ui.Image img) async {
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  List<List<Offset>> lines = <List<Offset>>[]; // 여러 개의 선을 저장할 수 있는 리스트 생성
  List<Offset> currentLine = <Offset>[];
  bool insideBox = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: RepaintBoundary(
            key: globalKey,
            child: GestureDetector(
              onPanDown: (DragDownDetails details) {
                setState(() {
                  currentLine = []; // 현재 그리는 선 초기화
                  lines.add(currentLine); // 새로운 선 추가

                  RenderBox? box = context.findRenderObject() as RenderBox?;
                  Offset point = box!.globalToLocal(details.globalPosition);
                  insideBox = point.dx > 0 &&
                      point.dy > 0 &&
                      point.dx < 250 &&
                      point.dy < 250;
                  if (insideBox) {
                    currentLine.add(point); // 터치한 위치에 점 추가
                  }
                });
              },
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  RenderBox? box = context.findRenderObject() as RenderBox?;
                  Offset point = box!.globalToLocal(details.globalPosition);
                  if (insideBox &&
                      point.dx > 0 &&
                      point.dy > 0 &&
                      point.dx < 250 &&
                      point.dy < 250) {
                    currentLine.add(point); // 현재 그리는 선에 포인트 추가
                  } else {
                    insideBox = false;
                  }
                });
              },
              onPanStart: (DragStartDetails details) {},
              child: CustomPaint(
                painter: DrawingPainter(lines: lines),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.lines});

  final List<List<Offset>> lines;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;

    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
