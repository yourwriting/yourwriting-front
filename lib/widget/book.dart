import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';
import 'package:realwriting/screens/writingpage_screen.dart';

class WrittenBook extends StatelessWidget {
  final String date;
  final int noteId;

  const WrittenBook({
    Key? key,
    required this.date,
    required this.noteId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.mainshadow.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2)
              )
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  WritingScreen(noteId: noteId)));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorStyles.mainblack,
              backgroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              textStyle:
                  const TextStyle(fontSize :14),
              padding:
                  const EdgeInsets.symmetric(vertical :75, horizontal :25),
            ),
            child:
                Center(child :Text(date,textAlign : TextAlign.center,))
          ),
        ),
        const SizedBox(height :10), // Add SizedBox here
      ],
    );
   }
}
