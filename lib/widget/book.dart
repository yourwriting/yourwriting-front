import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';
import 'package:realwriting/screens/writingpage_screen.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class WrittenBook extends StatefulWidget {
  final String date;
  final int noteId;
  final String title;
  final VoidCallback onDelete;

  const WrittenBook({
    Key? key,
    required this.date,
    required this.noteId,
    required this.title,
    required this.onDelete,
  }) : super(key: key);

  @override
  _WrittenBookState createState() => _WrittenBookState();
}

class _WrittenBookState extends State<WrittenBook> {
  @override
  Widget build(BuildContext context) {
    Future<void> deleteNote(int noteId) async {
      String urlString =
          "http://ec2-3-39-143-31.ap-northeast-2.compute.amazonaws.com:8080/api/note/${widget.noteId}";
      Uri uri = Uri.parse(urlString);

      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        developer.log('노트가 성공적으로 삭제되었습니다.');
      } else {
        developer.log('노트 삭제에 실패했습니다.');
        throw Exception('Failed to delete note');
      }
    }

    Future<void> handleDelete() async {
      try {
        await deleteNote(widget.noteId);
        widget.onDelete();
      } catch (e) {
        developer.log('Error deleting note: $e');
      }
    }

    return GestureDetector(
        onLongPress: () async {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) => CupertinoAlertDialog(
              title: const Text('노트 삭제'),
              content: Text('${widget.date} 을(를) 정말 삭제하시겠습니까?'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('아니오'),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                CupertinoDialogAction(
                  child: const Text('예'),
                  onPressed: () {
                    handleDelete().then((_) => Navigator.pop(dialogContext));
                  },
                ),
              ],
            ),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: ColorStyles.mainshadow.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ],
              ),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WritingScreen(
                                  noteId: widget.noteId,
                                  date: widget.date,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorStyles.mainblack,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    textStyle: const TextStyle(fontSize: 14),
                    padding: const EdgeInsets.symmetric(
                        vertical: 75, horizontal: 25),
                  ),
                  child: Center(
                      child: Column(children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.date,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ]))),
            ),
            const SizedBox(height: 10), // Add SizedBox here
          ],
        ));
  }
}
