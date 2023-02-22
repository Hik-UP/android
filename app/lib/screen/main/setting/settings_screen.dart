import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/screen/main/setting/logout.dart';
import 'package:hikup/screen/main/setting/update_profile.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/widget/custom_btn.dart';

import 'package:provider/provider.dart';

import '../../../providers/app_state.dart';
import '../../../theme.dart';

class LoadPictureProfil extends StatelessWidget {
  final AppState appState;
  const LoadPictureProfil({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: appState.picture,
      progressIndicatorBuilder: (context, url, progress) => Container(
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          FontAwesomeIcons.triangleExclamation,
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: imageProvider,
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";
  const SettingsScreen({Key? key}) : super(key: key);

  get floatingActionButton => null;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

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
                    child: Consumer<AppState>(builder: (context, state, child) {
                      return Row(
                        children: [
                          state.picture.isEmpty
                              ? Container(
                                  width: 75,
                                  height: 75,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        "assets/images/user_profile_example.png",
                                      ),
                                    ),
                                  ),
                                )
                              : LoadPictureProfil(
                                  appState: state,
                                ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appState.username.isNotEmpty
                                    ? "${appState.username[0].toUpperCase()}${appState.username.substring(1)}"
                                    : "",
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
                                  border: Border.all(color: primaryColor500),
                                ),
                                child: Text(
                                  appState.email,
                                  style: descTextStyle.copyWith(
                                    color: primaryColor500,
                                  ),
                                ),
                              ),
                              const Gap(6.0),
                              CustomBtn(
                                content: AppMessages.updateProfil,
                                onPress: () {
                                  Navigator.of(context).pushNamed(
                                    UpdateProfile.routeName,
                                  );
                                },
                                gradient: loginButtonColor,
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 32,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        "Version 1.0.0",
                        style: descTextStyle,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => {},
                  splashColor: primaryColor100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        "Github",
                        style: normalTextStyle,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Do you want to logout ?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                WrapperApi().logout();
                              }, child: const Text("Logout"),
                            ),
                            // TextButton(
                            //     onPressed: () => Navigator.of(context).pop(true),
                            //     child: const Text("Logout"),
                            // ),  
                          ],
                        );
                      } 
                    )  
                    // Navigator.of(context).pushNamed(
                    // LoginPage.routeName,
                    // );
                    //Continue ton implementation ici
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          FontAwesomeIcons.rightFromBracket,
                          color: darkBlue300,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        AppMessages.logout,
                        style: normalTextStyle,
                      ),
                    ],
                  ),
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
