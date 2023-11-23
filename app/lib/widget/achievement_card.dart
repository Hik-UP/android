import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/achievement.dart";
import "package:hikup/utils/constant.dart";

//black card color nuance
const blanckNuanceColor = Color(0xff222222);
const finishColor = Color(0xff15FF78);
const inProgressColor = Color(0xffFFAE31);

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    double progress = achievement.progress / 100;

    return Padding(
      padding: const EdgeInsets.all(10.5),
      child: Container(
        decoration: BoxDecoration(
          color: blanckNuanceColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  achievement.icon,
                  width: 70,
                  height: 70,
                  fit: BoxFit.fill,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      achievement.title,
                      style: GoogleFonts.jomhuria(
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                        color: progress == 1.0 ? finishColor : inProgressColor,
                      ),
                    ),
                    Text(
                      achievement.smallDescription,
                      style: GoogleFonts.jomhuria(
                        color: const Color(0xff7F7F7F),
                        fontSize: 17.0,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Text(
                            achievement.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.judson(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Image.asset(
                          customArrowIcon,
                          width: 17,
                          height: 17,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: blanckNuanceColor,
                valueColor: AlwaysStoppedAnimation(
                  progress == 1.0 ? finishColor : inProgressColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
