import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/utils/constant.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height / 4 * .5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              children: [
                Image.asset(
                  logoBlackNoBg,
                  height: 40,
                ),
                const Gap(8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(2.0),
                    Text(
                      "Titre",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(4.0),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 4 * 2) + 20,
                      child: Text(
                        msg.substring(0, 70),
                        style: GoogleFonts.poppins(),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(4.0),
                  ],
                ),
                Text(
                  DateTime.now().toLocal().toString().split(' ')[0],
                  style: GoogleFonts.poppins(
                    fontSize: 6.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
