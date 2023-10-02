import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class WrittenBook extends StatelessWidget {
  final String date;

  const WrittenBook({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: ColorStyles.mainshadow.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorStyles.mainblack,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 75,
                horizontal: 25,
              ),
            ),
            child: Center(
              child: Text(
                date,
                textAlign: TextAlign.center,
              ),
            )));
  }
}
