import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/screens/login_screen.dart';
import 'package:realwriting/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

  Future<void> signup(String loginId, String password, String nickname) async {
    final response = await http.post(
      Uri.parse(
          'http://ec2-43-200-232-144.ap-northeast-2.compute.amazonaws.com:8080/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'loginId': loginId,
        'password': password,
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 201) {
      // 서버에서 응답이 성공적으로 왔을 때
      print("signup Success");
    } else {
      // 서버에서 에러 응답이 왔을 때
      showCupertinoDialog(
        context: context, // 필요한 context를 제공해야 합니다.
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('회원가입에 실패했습니다. 다른 아이디로 다시 시도해주세요.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      throw Exception('Failed to signup. Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 55,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 9,
                        ),
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: ColorStyles.blue,
                          size: 30,
                        ),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Display-Regular',
                              fontSize: 17,
                              color: ColorStyles.blue),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 65,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 37,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/realwriting.png'),
                          width: 178,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        const Row(
                          children: [
                            Text(
                              'ID',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: ColorStyles.mainblack,
                                  fontSize: 18,
                                  fontFamily: "SF-Pro-Rounded-Semibold"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          controller: _loginIdController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your ID',
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
                        const Row(
                          children: [
                            Text(
                              'Password',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: ColorStyles.mainblack,
                                  fontSize: 18,
                                  fontFamily: "SF-Pro-Rounded-Semibold"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
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
                        const SizedBox(
                          height: 36,
                        ),
                        const Row(
                          children: [
                            Text(
                              'Nickname',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: ColorStyles.mainblack,
                                  fontSize: 18,
                                  fontFamily: "SF-Pro-Rounded-Semibold"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your nickname',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: "SF-Pro-Rounded-Regular",
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your nickname';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await signup(
                                    _loginIdController.text,
                                    _passwordController.text,
                                    _nicknameController.text,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  print('Failed to signup: $e');
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage('assets/images/signup.png'),
                              width: 327,
                              height: 50,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
