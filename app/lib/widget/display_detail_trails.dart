import "package:any_link_preview/any_link_preview.dart";
import "package:flutter/material.dart";
import 'dart:math' as math;
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/detail_trail_model.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/main/community/comments/home.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/wrapper_api.dart";
import "package:hikup/widget/show_burn_calories.dart";
import "package:provider/provider.dart";
import 'package:flutter_svg/flutter_svg.dart';

class DisplayDetailTrails extends StatelessWidget {
  final double fontSize;
  final String trailId;
  final int duration;
  final int distance;
  final int upHill;
  final int downHill;
  final int difficulty;

  const DisplayDetailTrails({
    Key? key,
    required this.fontSize,
    required this.trailId,
    required this.duration,
    required this.distance,
    required this.upHill,
    required this.downHill,
    required this.difficulty,
  }) : super(key: key);

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Color trailColor = difficulty == 1
        ? const Color.fromRGBO(87, 252, 255, 0.8)
        : difficulty == 2
            ? const Color.fromRGBO(72, 255, 201, 0.8)
            : difficulty == 3
                ? const Color.fromRGBO(194, 283, 255, 0.8)
                : difficulty == 4
                    ? const Color.fromRGBO(253, 210, 59, 0.8)
                    : difficulty == 5
                        ? const Color.fromRGBO(87, 252, 255, 0.8)
                        : Colors.transparent;

    return Row(
      children: [
        SvgPicture.asset("assets/icons/details/clock.svg",
            height: fontSize,
            width: fontSize,
            colorFilter: ColorFilter.mode(trailColor, BlendMode.srcIn),
            semanticsLabel: 'duration'),
        const Gap(2),
        Text("${durationToString(duration)} h",
            style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        const Gap(10),
        SvgPicture.asset("assets/icons/details/shoe.svg",
            height: fontSize + 1,
            width: fontSize + 1,
            colorFilter: ColorFilter.mode(trailColor, BlendMode.srcIn),
            semanticsLabel: 'distance'),
        const Gap(2),
        Text("${distance / 1000} km",
            style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        const Gap(10),
        SvgPicture.asset("assets/icons/details/down-arrow.svg",
            height: fontSize - 2,
            width: fontSize - 2,
            colorFilter: ColorFilter.mode(trailColor, BlendMode.srcIn),
            semanticsLabel: 'downhill'),
        const Gap(2),
        Text("$downHill m",
            style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        const Gap(10),
        SvgPicture.asset("assets/icons/details/up-arrow.svg",
            height: fontSize - 2,
            width: fontSize - 2,
            colorFilter: ColorFilter.mode(trailColor, BlendMode.srcIn),
            semanticsLabel: 'uphill'),
        const Gap(2),
        Text("$upHill m",
            style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white))
      ],
    );
  }
}
