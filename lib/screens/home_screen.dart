import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorStyles.mainbackground,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 70,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorStyles.mainwhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Text(
                        'my font',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.remove_circle_outline,
                    size: 30,
                    color: ColorStyles.mainwhite,
                  ),
                  const SizedBox(
                    width: 64,
                  ),
                  const Text(
                    '2023-05-31',
                    style: TextStyle(
                      color: ColorStyles.mainwhite,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.settings,
                    size: 55,
                    color: ColorStyles.mainwhite,
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
