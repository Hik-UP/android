import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/constant.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height / 4 * .5,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        
        child: Card(
          color: BlackSecondary,
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(17.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(children: [            
              Row(
                children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    logoWhiteNoBg,
                    height: 50,
                    width: 50,
                ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Text(
                      "Titre",
                      style: WhiteTitleTextStyle,
                    ),
                    const Gap(4.0),*/
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) + 100,
                      child: Text(
                        msg.substring(0, 70),
                        style: WhiteAddressTextStyle,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(4.0),
                    Text(
                      DateTime.now().toLocal().toString().split(' ')[0],
                      style: greySubTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            const Gap(5),
            SizedBox(
              height: 1,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: BlackTertiary.withOpacity(0.25),
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

/*
                    
                    */