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
              color: GreenPrimary,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              "${calories / 1000} kcal",
              style: WhiteAddressTextStyle,
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
