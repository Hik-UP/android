import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/hike/hikes_create.dart';
import 'package:hikup/screen/main/search/notification.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';

import '../screen/main/community/community_history_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();
    appState.picture;

    var state;
    return AppBar(
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 156, 156, 156),
      ),
      title: SizedBox(
        width: MediaQuery.of(context).size.width / 2 * .9,
        child: Text(
          appState.username.isNotEmpty
              ? "${appState.username[0].toUpperCase()}${appState.username.substring(1)}"
              : "",
          style: subTitleTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                //CommunityHistoryScreen.routeName,
                SettingsScreen.routeName,
              ),
                  child: Consumer<AppState>(builder: (context, state, child) {
                    return Row(
                      children: [
                        state.picture.isEmpty
                            ? Container(
                                width: 35,
                                height: 35,
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
                                appState: state,
                              ),
                        const SizedBox(
                          width: 16,
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       appState.username.isNotEmpty
                        //           ? "${appState.username[0].toUpperCase()}${appState.username.substring(1)}"
                        //           : "",
                        //       style: subTitleTextStyle,
                        //     ),
                        //     const SizedBox(
                        //       height: 8,
                        //     ),
                        //     Container(
                        //       width: MediaQuery.of(context).size.width * .6,
                        //       padding: const EdgeInsets.all(2),
                        //       child: Text(
                        //         appState.email,
                        //         style: descTextStyleWhite,
                        //         maxLines: 1,
                        //       ),
                        //     ),
                        //     const Gap(6.0),
                        //     // CustomBtn(
                        //     //   content: AppMessages.updateProfil,
                        //     //   height: 50, 
                        //     //   onPress: () {
                        //     //     Navigator.of(context).pushNamed(
                        //     //       UpdateProfile.routeName,
                        //     //     );
                        //     //   },
                        //     //   gradient: loginButtonColor,
                        //     // ),
                        //   ],
                        // ),
                      ],
                    );
                  }),
              // child: Container(
              //   margin: const EdgeInsets.only(left: 10.0),
              //   width: 35,
              //   height: 35,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Color.fromARGB(255, 156, 156, 156),
              //     image: DecorationImage(
              //       fit: BoxFit.fill,
              //       image: AssetImage("assets/images/user_profile_example.png"),
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      elevation: 0.0,
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
            const Gap(20.0),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                //CommunityHistoryScreen.routeName,
                NotificationView.routeName,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    FontAwesomeIcons.bell,
                    size: 23,
                  ),
                  Positioned(
                    right: 0,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 23, 255, 119),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16.0)
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
