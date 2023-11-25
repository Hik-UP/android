import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/hike/hikes_create.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return AppBar(
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 156, 156, 156),
      ),
      centerTitle: true,
      title: Text(
        "HIK'UP",
        style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                HikesCreate.routeName,
              ),
              child: const Icon(
                FontAwesomeIcons.personHiking,
              ),
            ),
            const Gap(10),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                //CommunityHistoryScreen.routeName,
                SettingsScreen.routeName,
              ),
              child: Consumer<AppState>(
                builder: (context, state, child) {
                  return state.picture.isEmpty
                      ? Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: BlackPrimary,
                            // image: DecorationImage(
                            //   fit: BoxFit.fill,
                            //   image: AssetImage(
                            //     profilePlaceHoder,
                            //   ),
                            // ),
                          ),
                        )
                      : LoadPictureProfil(
                          size: 35,
                          appState: state,
                        );
                },
              ),
            ),
            const Gap(16.0),
          ],
        ),
        // Row(
        //   children: [
        //     // GestureDetector(
        //     //   // onTap: () => Navigator.of(context).pushNamed(
        //     //   //   HikesCreate.routeName,
        //     //   // ),
        //     //   child: const Icon(
        //     //     FontAwesomeIcons.book,
        //     //   ),
        //     // ),
        //     const Gap(20.0),
        //     GestureDetector(
        //       onTap: () => Navigator.of(context).pushNamed(
        //         CommunityHistoryScreen.routeName,
        //         //NotificationView.routeName,
        //       ),
        //       child: Stack(
        //         clipBehavior: Clip.none,
        //         children: [
        //           const Icon(
        //             FontAwesomeIcons.book,
        //             size: 23,
        //           ),
        //           Positioned(
        //             right: 0,
        //             top: -5,
        //             child: Container(
        //               padding: const EdgeInsets.all(3.0),
        //               decoration: const BoxDecoration(
        //                 color: Color.fromARGB(255, 23, 255, 119),
        //                 shape: BoxShape.circle,
        //               ),
        //               child: const Text(
        //                 "3",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 8.0,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const Gap(16.0)
        //   ],
        // )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
