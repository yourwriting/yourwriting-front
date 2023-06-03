import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realwriting/screens/landingpage_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: LandingScreen(),
    );
  }
}
