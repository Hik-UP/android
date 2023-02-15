import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/setting/update_profile.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_btn.dart';

import 'package:provider/provider.dart';

import '../../../providers/app_state.dart';
import '../../../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState _appState = context.read<AppState>();

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            "Réglages",
            style: titleTextStyle,
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Compte",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  "assets/images/user_profile_example.png"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _appState.username.isNotEmpty ? "${_appState.username[0].toUpperCase()}${_appState.username.substring(1)}" : "",
                              style: subTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: primaryColor100.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: primaryColor500)),
                              child: Text(
                                _appState.email,
                                style: descTextStyle.copyWith(
                                  color: primaryColor500,
                                ),
                              ),
                            ),
                           const Gap(6.0),
                            CustomBtn(content: "Modifier mon profil", onPress: () {
                              Navigator.of(context).pushNamed(UpdateProfile.routeName);
                            }, gradient: loginButtonColor,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Unité",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            CupertinoIcons.creditcard_fill,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "",
                                overflow: TextOverflow.visible,
                                style: normalTextStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "",
                                style: descTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Other",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            CupertinoIcons.moon_circle,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Theme",
                              style: normalTextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Light",
                              style: descTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.language_rounded,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Langue",
                              style: normalTextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Anglais",
                              style: descTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "À Propos de l'app",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                InkWell(
                  onTap: () {
                    _showSnackBar(context, "Newest Version");
                  },
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            CupertinoIcons.info_circle_fill,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "",
                                style: normalTextStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Version 1.0.0",
                                style: descTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(12.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: Image.asset(
                            "assets/icons/github.png",
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Github",
                                style: normalTextStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "",
                                style: descTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "",
                      style: normalTextStyle,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "",
                      style: subTitleTextStyle.copyWith(color: primaryColor500),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "",
                      style: normalTextStyle,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.hiking,
                      color: Colors.black,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      // margin: EdgeInsets.all(16),
    ));
  }
}
