import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';

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
            const Gap(8.0),
            Text(
              AppMessages.calorieToBurn,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: darkBlue300,
              ),
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
