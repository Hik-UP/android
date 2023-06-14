import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/notification.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
          color: BlackSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: [
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              notification.title,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(16.0),
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: notification.read
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Text(
                                notification.read
                                    ? AppMessages.lueNotifLabel
                                    : AppMessages.nonLueNotifLabel,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(4.0),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 2) + 100,
                          child: Text(
                            notification.body,
                            style: WhiteAddressTextStyle,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(4.0),
                        Text(
                          notification.dateTime.split('T')[0].replaceAll(
                                RegExp(r'-'),
                                "/",
                              ),
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
