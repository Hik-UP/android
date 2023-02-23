import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/setting/complete_profile.dart';
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
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          AppMessages.settingTxt,
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
                AppMessages.account,
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
                                      profilePlaceHoder,
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
              const Gap(40),
              Text(
                AppMessages.infoMessage,
                style: subTitleTextStyle.copyWith(color: primaryColor500),
              ),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(CompleteProfile.routeName),
                splashColor: primaryColor100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        FontAwesomeIcons.clipboardList,
                        color: darkBlue300,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      AppMessages.addExtraData,
                      style: normalTextStyle,
                    ),
                  ],
                ),
              ),
              const Gap(30.0),
              Text(
                AppMessages.aboutApp,
                style: subTitleTextStyle.copyWith(
                  color: primaryColor500,
                ),
              ),
              InkWell(
                onTap: () {
                  _showSnackBar(
                    context,
                    AppMessages.newestVersion,
                  );
                },
                splashColor: primaryColor100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        CupertinoIcons.info_circle_fill,
                        size: 24,
                        color: darkBlue300,
                      ),
                    ),
                    const Gap(4.0),
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
                      child: Image.asset(
                        githubLink,
                        color: darkBlue300,
                      ),
                    ),
                    const Gap(4.0),
                    Text(
                      githubName,
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
                        title: Text(AppMessages.askIfUserWantToLogout),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(AppMessages.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              WrapperApi().logout(
                                isLogout: true,
                              );
                            },
                            child: Text(AppMessages.logOut),
                          ),
                        ],
                      );
                    },
                  )
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
                    const Gap(4.0),
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
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }
}
