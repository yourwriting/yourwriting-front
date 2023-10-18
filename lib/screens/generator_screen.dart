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

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return const HomeScreen();
                        }));
                      },
                      iconSize: 31,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  const Column(
                    children: [
                      SizedBox(height: 200),
                      Center(
                        // child: Column(
                        //   children: [
                        //     const SizedBox(height: 200),
                        //     RepaintBoundary(
                        //       key: UniqueKey(), // 여기에서 UniqueKey 사용
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.circular(30)),
                        child: DrawingSession(),
                        //child: DrawingArea(),
                        // ),
                        // ),
                        //const SizedBox(height: 10),
                        // ElevatedButton(
                        //   onPressed: _DrawingAreaState.captureAndUpload,
                        //   child: const Text('Capture and Upload'),
                        // )
                        //],
                        // ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingSession extends StatefulWidget {
  const DrawingSession({Key? key}) : super(key: key);

  @override
  _DrawingSessionState createState() => _DrawingSessionState();
}

class _DrawingSessionState extends State<DrawingSession> {
  List<Uint8List> images = []; // 각각의 그림에 대한 이미지 데이터를 저장할 리스트
  int currentStep = 0; // 현재 그리고 있는 글자의 인덱스
  final GlobalKey<_DrawingAreaState> _drawingAreaKey = GlobalKey();

  Future<void> captureImage(Uint8List imageBytes) async {
    // 이미지 파일 생성 (임시 파일)
    final tempDir = Directory.systemTemp;
    final file = await File('${tempDir.path}/${currentStep + 1}.PNG').create();

    // 여기서 currentStep은 현재 그리고 있는 글자의 인덱스입니다.

    await file.writeAsBytes(imageBytes);
  }

  // void captureImage(Uint8List imageBytes) async {
  //   // 이미지 파일 생성 (임시 파일)
  //   final tempDir = Directory.systemTemp;
  //   final file = await File('${tempDir.path}/${currentStep + 1}.PNG').create();

  //   await file.writeAsBytes(imageBytes);
  // }

  Future<void> uploadImages() async {
    var url = Uri.parse('http://127.0.0.1:5000/upload');
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ElevatedButton(
          onPressed: () async {
            final drawingAreaState =
                _drawingAreaKey.currentState as _DrawingAreaState;
            await drawingAreaState.captureAndSave();
            drawingAreaState.clearDrawing();
          },
          child: const Text('Next'),
        ),
        ElevatedButton(
          onPressed: uploadImages,
          child: const Text('Upload All'),
        ),
      ],
    );
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

  // static Future<void> uploadImage(Uint8List imageBytes) async {
  //   var url = Uri.parse('http://127.0.0.1:5000/upload');

  //   var request = http.MultipartRequest('POST', url);

  //   // 이미지 파일 생성 (임시 파일)
  //   final tempDir = Directory.systemTemp;
  //   final file = await File('${tempDir.path}/1.PNG').create();
  //   await file.writeAsBytes(imageBytes);

  //   // MultipartRequest에 이미지 추가
  //   request.files.add(await http.MultipartFile.fromPath(
  //     'files',
  //     file.path,
  //     contentType: MediaType('image', 'png'),
  //   ));

  //   // 요청 보내기
  //   var response = await request.send();

  //   if (response.statusCode == HttpStatus.ok) {
  //     print("Upload successful!");
  //     await file.delete(); // 임시 파일 삭제
  //   } else {
  //     print("Upload failed with status code ${response.statusCode}.");
  //     await file.delete(); // 임시 파일 삭제
  //   }
  // }

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
        const SizedBox(height: 10),
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
      ..strokeWidth = 25.0;

    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
