import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'dart:developer' as developer;
import 'package:realwriting/style.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
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
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 200),
                        RepaintBoundary(
                          key: UniqueKey(), // 여기에서 UniqueKey 사용
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: const DrawingArea(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //  ElevatedButton (
                        //    onPressed:_DrawingAreaState.captureAndUpload,
                        //    child :Text('Capture and Upload'),
                        //  )
                      ],
                    ),
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

class DrawingArea extends StatefulWidget {
  const DrawingArea({super.key});

  @override
  _DrawingAreaState createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  GlobalKey globalKey = GlobalKey(); // GlobalKey 생성

  // static Future<void> captureAndUpload() async {
  //   // 캡쳐 및 업로드 함수 추가
  //   RenderRepaintBoundary boundary =
  //       globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage();
  //   final imageBytes = await getBytesFromCanvas(image);

  //   uploadImage(imageBytes);
  // }

  static Future<Uint8List> getBytesFromCanvas(ui.Image img) async {
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static Future<void> uploadImage(Uint8List imageBytes) async {
    var url = Uri.parse('http://127.0.0.1:5000/upload');

    var request = http.MultipartRequest('POST', url);

    // 이미지 파일 생성 (임시 파일)
    final tempDir = Directory.systemTemp;
    final file = await File('${tempDir.path}/1.png').create();
    await file.writeAsBytes(imageBytes);

    // MultipartRequest에 이미지 추가
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      file.path,
      contentType: MediaType('image', 'png'),
    ));

    // 요청 보내기
    var response = await request.send();

    if (response.statusCode == HttpStatus.ok) {
      developer.log("Upload successful!");
      await file.delete(); // 임시 파일 삭제
    } else {
      developer.log("Upload failed with status code ${response.statusCode}.");
      await file.delete(); // 임시 파일 삭제
    }
  }

  List<List<Offset>> lines = <List<Offset>>[]; // 여러 개의 선을 저장할 수 있는 리스트 생성
  List<Offset> currentLine = <Offset>[];
  bool insideBox = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
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
