import 'dart:async';

import 'package:flutter/material.dart';
import 'package:realwriting/screens/home_screen.dart';
import 'package:realwriting/style.dart';
import 'package:get/get.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1300), () {
      Get.to(const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'yourwriting',
                style: TextStyle(
                  color: ColorStyles.mainblack,
                  fontSize: 35,
                  fontFamily: "SF-Pro-Display-Regular",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
