import "package:flutter/material.dart";
import 'package:hikup/theme.dart';

class ShowBurnCalories extends StatelessWidget {
  final int calories;
  const ShowBurnCalories({
    Key? key,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.hiking_rounded,
              color: primaryColor500,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              calories.toString(),
              style: descTextStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
