import 'package:flutter/material.dart';
import 'package:realwriting/style.dart';

class writtenBook extends StatelessWidget {
  final String Date;

  const writtenBook({
    super.key,
    required this.Date,
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
                Date,
                textAlign: TextAlign.center,
              ),
            )));
  }
}
