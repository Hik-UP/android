import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/achievement/achievement_view.dart';
import 'package:hikup/screen/main/hike/hikes_create.dart';
import 'package:hikup/screen/main/search/notification.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/Header/notif_bell.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

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
              child: Consumer<AppState>(
                builder: (context, state, child) {
                  return Row(
                    children: [
                      state.picture.isEmpty
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
                            ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Row(
          children: [
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(AchievementView.routeName),
              child: const Icon(
                FontAwesomeIcons.star,
              ),
            ),
            const Gap(20.0),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                HikesCreate.routeName,
              ),
              child: const Icon(
                FontAwesomeIcons.personHiking,
              ),
            ),
            const Gap(20.0),
            const NotifBell(),
            const Gap(16.0)
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
