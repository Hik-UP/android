import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';

class HikeCard extends StatelessWidget {
  final Hike hike;
  const HikeCard({
    Key? key,
    required this.hike,
  }) : super(key: key);

  String formatDate() {
    var replaceDate = hike.schedule.replaceAll(RegExp(r'T'), ' ');
    var splitDate = replaceDate.split(' ');

    return "${splitDate[0]} ${splitDate[1].split(':').sublist(0, 2).join(':')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 25.0,
        right: 22.0,
        bottom: 17.0,
        left: 22.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(idHikeIcon),
              const Gap(8.0),
              Text(
                "ID",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              hike.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Gap(10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(calendarIcon),
              const Gap(8.0),
              Text(
                AppMessages.date,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              formatDate(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Gap(10.0),
          Row(
            children: [
              Image.asset(
                pinIcon,
                width: 18,
                height: 18,
                color: HOPA,
              ),
              const Gap(8.0),
              Text(
                AppMessages.position,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              hike.address,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
