import 'dart:async';
import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String> login(String loginId, String password) async {
    final response = await http.post(
      Uri.parse(
          'http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'loginId': loginId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // 서버에서 응답이 성공적으로 왔을 때
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['result']['accessToken'];
    } else {
      // 서버에서 에러 응답이 왔을 때
      throw Exception('Failed to login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/realwriting.png'),
                  width: 178,
                ),
                const SizedBox(
                  height: 72,
                ),
                const Text(
                  'ID',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: ColorStyles.mainblack,
                      fontSize: 18,
                      fontFamily: "SF-Pro-Rounded-Semibold"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _loginIdController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Id',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: "SF-Pro-Rounded-Regular",
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 36,
                ),
                const Text(
                  'Password',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: ColorStyles.mainblack,
                      fontSize: 18,
                      fontFamily: "SF-Pro-Rounded-Semibold"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: "SF-Pro-Rounded-Regular",
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     if (_formKey.currentState!.validate()) {
                //       try {
                //         String accessToken = await login(
                //             _loginIdController.text, _passwordController.text);
                //         print('Access token: $accessToken');
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 HomeScreen(accessToken: "Bearer $accessToken"),
                //           ),
                //         );
                //       } catch (e) {
                //         print('Failed to login: $e');
                //       }
                //     }
                //   },
                //   child: const Text('Submit'),
                // ),
                const SizedBox(
                  height: 70,
                ),
                InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          String accessToken = await login(
                            _loginIdController.text,
                            _passwordController.text,
                          );
                          print('Access token: $accessToken');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                  accessToken: "Bearer $accessToken"),
                            ),
                          );
                        } catch (e) {
                          print('Failed to login: $e');
                        }
                      }
                    },
                    child: const Image(
                      image: AssetImage('assets/images/login.png'),
                      width: 327,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
