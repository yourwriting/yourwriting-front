import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
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
                      iconSize: 55,
                      icon: const Icon(Icons.arrow_circle_left_outlined),
                    ),
                  ),
                  Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      RepaintBoundary(
                        key: _DrawingAreaState.globalKey,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: const DrawingArea(),
                        ),
                      ),
                      const ElevatedButton(
                        // 캡쳐 및 업로드 버튼 추가
                        onPressed: _DrawingAreaState.captureAndUpload,
                        child: Text('Capture and Upload'),
                      )
                    ],
                  )),
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
  static GlobalKey globalKey = GlobalKey(); // GlobalKey 생성

  static Future<void> captureAndUpload() async {
    // 캡쳐 및 업로드 함수 추가
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final imageBytes = await getBytesFromCanvas(image);

    uploadImage(imageBytes);
  }

  static Future<Uint8List> getBytesFromCanvas(ui.Image img) async {
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static Future<void> uploadImage(Uint8List imageBytes) async {
    var url = Uri.parse('localhost:5000/upload');

    var request = http.MultipartRequest('POST', url);

    // 이미지 파일 생성 (임시 파일)
    final tempDir = Directory.systemTemp;
    final file = await File('${tempDir.path}/image.png').create();
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
      print("Upload successful!");
      await file.delete(); // 임시 파일 삭제
    } else {
      print("Upload failed with status code ${response.statusCode}.");
      await file.delete(); // 임시 파일 삭제
    }
  }

  List<Offset> points = <Offset>[];
  bool insideBox = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: GestureDetector(
        onPanDown: (DragDownDetails details) {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          Offset point = box!.globalToLocal(details.globalPosition);
          insideBox =
              point.dx > 0 && point.dy > 0 && point.dx < 250 && point.dy < 250;
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
              points.add(point);
            } else {
              insideBox = false;
            }
          });
        },
        onPanStart: (DragStartDetails details) {},
        child: CustomPaint(
          painter: DrawingPainter(points: points),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.points});

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
