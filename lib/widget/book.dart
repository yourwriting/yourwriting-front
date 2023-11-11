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
  final String accessToken;

  const WrittenBook({
    Key? key,
    required this.date,
    required this.noteId,
    required this.title,
    required this.onDelete,
    required this.accessToken,
  }) : super(key: key);

  @override
  _WrittenBookState createState() => _WrittenBookState();
}

class _WrittenBookState extends State<WrittenBook> {
  late String accessToken = widget.accessToken;
  //"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJybGoiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTY5ODczNDczNSwiZXhwIjo0MjkwNzM0NzM1fQ.WpulBwf6CLFO1tFvgw9FqAxAK22-fihbf1zrFbhpph6S8lKCHqj4_zcrJGeYBPQ5Im9TjTss9_siRoeclrHNUA";

  @override
  Widget build(BuildContext context) {
    Future<void> deleteNote(int noteId) async {
      String urlString =
          "http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/note/${widget.noteId}";
      Uri uri = Uri.parse(urlString);

      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Authorization': accessToken,
        },
      );

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
              content: Text('${widget.date}를 정말 삭제하시겠습니까?'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: ColorStyles.mainshadow.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1))
                ],
              ),
              child: SizedBox(
                width: 343,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WritingScreen(
                                  accessToken: accessToken,
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
                        vertical: 19, horizontal: 16),
                  ),
                  child: Align(
                    // Align 위젯 추가
                    alignment: Alignment.centerLeft, // 좌측 정렬 설정
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.date.replaceAll("-", "/"),
                            style: const TextStyle(
                              fontFamily: "PretendardVariable",
                              color: ColorStyles.dateColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: ColorStyles.mainblack,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: "PretendardVariable",
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ]),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 11), // Add SizedBox here
          ],
        ));
  }
}
