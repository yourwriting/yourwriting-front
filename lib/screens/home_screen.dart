import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 26,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Row(
                children: [
                  Text(
                    '2023-05-31',
                    style: TextStyle(
                      color: ColorStyles.mainwhite,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
