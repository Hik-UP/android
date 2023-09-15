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
import 'package:hikup/widget/custom_app_bar.dart';
import 'package:hikup/widget/custom_btn.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/app_state.dart';
import '../../../theme.dart';

class LoadPictureProfil extends StatelessWidget {
  final double size;
  final AppState appState;
  const LoadPictureProfil({
    Key? key,
    required this.appState,
    this.size = 75,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: appState.picture,
      progressIndicatorBuilder: (context, url, progress) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: BlackPrimary,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: BlackSecondary,
        ),
        child: const Icon(
          FontAwesomeIcons.triangleExclamation,
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BlackPrimary,
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
    var _i18n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          _i18n.settingTxt,
          style: titleTextStyleWhite,
        ),
        iconTheme: IconThemeData(
          color: GreenPrimary, // Couleur de la flèche retour
        ),
        backgroundColor: BlackPrimary,
        centerTitle: true,
      ),
      appBar: CustomAppBar(label: AppMessages.settingTxt),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20.0),
              Text(
                _i18n.account,
                style: subTitleTextStyle,
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
                                  color: BlackPrimary,
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
                              width: MediaQuery.of(context).size.width * .6,
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                appState.email,
                                style: descTextStyleWhite,
                                maxLines: 1,
                              ),
                            ),
                            const Gap(6.0),
                            CustomBtn(
                              content: _i18n.updateProfil,
                              height: 50,
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
                _i18n.infoMessage,
                style: subTitleTextStyle,
              ),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(CompleteProfile.routeName),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        FontAwesomeIcons.clipboardList,
                        color: BlackTertiary,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      _i18n.addExtraData,
                      style: linkTextStyle,
                    ),
                  ],
                ),
              ),
              const Gap(30.0),
              Text(_i18n.aboutApp, style: subTitleTextStyle),
              InkWell(
                onTap: () {
                  _showSnackBar(
                    context,
                    _i18n.newestVersion,
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        CupertinoIcons.info_circle_fill,
                        size: 24,
                        color: BlackTertiary,
                      ),
                    ),
                    const Gap(4.0),
                    Text(
                      "Version Beta",
                      style: linkTextStyle,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        githubLink,
                        color: BlackTertiary,
                      ),
                    ),
                    const Gap(4.0),
                    Text(
                      githubName,
                      style: linkTextStyle,
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
                        backgroundColor: BlackPrimary,
                        title: Text(_i18n.askIfUserWantToLogout,
                            style: subTitleTextStyle),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(_i18n.cancel,
                                style: GreenAddressTextStyle),
                          ),
                          TextButton(
                            onPressed: () {
                              WrapperApi().logout(isLogout: true);
                            },
                            child: Text(_i18n.logOut,
                                style: GreenAddressTextStyle),
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
                        color: BlackTertiary,
                      ),
                    ),
                    const Gap(4.0),
                    Text(
                      _i18n.logout,
                      style: linkTextStyle,
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
