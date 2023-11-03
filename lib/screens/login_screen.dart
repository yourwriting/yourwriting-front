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
                TextFormField(
                  controller: _loginIdController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Id',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Id';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        String accessToken = await login(
                            _loginIdController.text, _passwordController.text);
                        print('Access token: $accessToken');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(accessToken: accessToken),
                          ),
                        );
                      } catch (e) {
                        print('Failed to login: $e');
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
