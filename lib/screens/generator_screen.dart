import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';

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
                    child:
                    Column(children: [const SizedBox(height: 200,),
                     Container(
                        decoration:
                            BoxDecoration(color:
                              Colors.white, borderRadius:
                                BorderRadius.circular(30)),
                        child:
                          const DrawingArea(),
                      ),
                    ],)
                  ),
                ],
              ),
              const SizedBox(height:
                15),
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
          insideBox = point.dx >0 && point.dy >0 && point.dx <250 && point.dy <250;
        },
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox? box = context.findRenderObject() as RenderBox?;
            Offset point = box!.globalToLocal(details.globalPosition);
            if (insideBox && point.dx >0 && point.dy >0 && point.dx <250 && point.dy <250){
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

    for (int i=0; i<points.length-1; i++) { 
       canvas.drawLine(points[i], points[i+1], paint);
     } 
   }

   @override
   bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
