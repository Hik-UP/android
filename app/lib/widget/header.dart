import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/search/notification.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      leadingWidth: 250,
      leading: Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                        SettingsScreen.routeName,
                      ),
                  child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                "assets/images/user_profile_example.png"),
                          )))),
              const SizedBox(
                width: 16,
              ),
              Text(
                appState.username.isNotEmpty
                    ? "${appState.username[0].toUpperCase()}${appState.username.substring(1)}"
                    : "",
                style: subTitleTextStyle,
              )
            ],
          )),
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
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
                        color: primaryColor500,
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
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
