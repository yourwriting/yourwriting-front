
import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';


class WritingScreen extends StatefulWidget {
   const WritingScreen({Key? key}) : super(key: key);

   @override
   WritingScreenState createState() => WritingScreenState();
}

class WritingScreenState extends State<WritingScreen> {

  Future<String> fetchContent() async {
  String urlString = "http://ec2-3-39-143-31.ap-northeast-2.compute.amazonaws.com:8080/api/note/1";
  Uri uri = Uri.parse(urlString);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
 var jsonResponse = jsonDecode(response.body);
    return jsonResponse['result']['content'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load content');
  }
}

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedMonth = now.month.toString().padLeft(2, '0');
    String formattedDay = now.day.toString().padLeft(2, '0');
    String formattedDate = "${now.year}-$formattedMonth-$formattedDay";

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
                iconSize: 45,
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
                    fontSize: 20,
                  ),
                ),
                  const SizedBox(
                  height: 7,
                ),
                  ],
                ),    
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.text_fields_outlined,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.color_lens_outlined,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 35,
                  ),
                ),
              ],
            ),
        SingleChildScrollView(
            child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder<String> (
                      future: fetchContent(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return TextField(
                            controller: TextEditingController(text: snapshot.data),
                            style: const TextStyle(fontFamily: 'UhBee-DongKyung'),
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
