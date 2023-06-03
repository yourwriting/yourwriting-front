import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
                'realWriting',
                style: TextStyle(
                  color: ColorStyles.mainblack,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
