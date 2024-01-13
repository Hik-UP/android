import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/settings.dart';
import 'package:hikup/providers/sound_state.dart';
import 'package:hikup/screen/inventory/inventory_view.dart';
import 'package:hikup/screen/main/setting/complete_profile.dart';
import 'package:hikup/screen/main/setting/update_profile.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/widget/scaffold_with_custom_bg.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/locator.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_state.dart';
import '../../../theme.dart';

class LoadPictureProfil extends StatelessWidget {
  final double size;
  final AppState appState;
  const LoadPictureProfil({
    super.key,
    required this.appState,
    this.size = 75,
  });

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

class SettingsScreen extends StatefulWidget {
  static String routeName = "/settings";
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with RouteAware {
  get floatingActionButton => null;
  final _hiveService = locator<HiveService>();
  bool isInit = false;
  double soundValue = 100;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    if (isInit == false && appState.settings.volume != null) {
      setState(() {
        soundValue = appState.settings.volume! * 100;
        isInit = true;
      });
    }

    return ScaffoldWithCustomBg(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20.0),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<AppState>(builder: (context, state, child) {
                    return InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        UpdateProfile.routeName,
                      ),
                      child: Row(
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
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Divider(
                color: Color(0xff7D7D7D),
                thickness: 1,
              ),
              const Gap(10),
              const InventoryView(),
              const Gap(20),
              Text(
                AppMessages.infoMessage,
                style: subTitleTextStyle,
              ),
              const Gap(10.0),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(CompleteProfile.routeName),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppMessages.addExtraData,
                      style: textLinkProfileStyle,
                    ),
                  ],
                ),
              ),
              //InVENTORY BUTTON
              const Gap(20),
              Text(
                AppMessages.soundManager,
                style: subTitleTextStyle,
              ),
              const Gap(8.0),
              //S
              Slider(
                value: soundValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: "${soundValue.round().toString()}%",
                onChangeEnd: (double value) async {
                  var volume = value / 100;

                  await context.read<SoundState>().setVolume(volume: volume);
                  await _hiveService.addOnBoxViaKey<Settings>(
                    settingsBox,
                    "settings",
                    Settings(volume: volume),
                  );
                  appState.updateSettingsState(value: Settings(volume: volume));
                },
                onChanged: (double value) async {
                  setState(() {
                    soundValue = value;
                  });
                },
              ),
              const Gap(30.0),
              Text(AppMessages.aboutApp, style: subTitleTextStyle),
              const Gap(10.0),
              InkWell(
                onTap: () {
                  _showSnackBar(
                    context,
                    AppMessages.newestVersion,
                  );
                },
                child: Text(
                  "Version Pre-Release",
                  style: textLinkProfileStyle,
                ),
              ),
              const Gap(8.0),
              InkWell(
                onTap: () => {},
                child: Text(
                  githubName,
                  style: textLinkProfileStyle,
                ),
              ),
              const Gap(8.0),
              InkWell(
                onTap: () => {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: BlackPrimary,
                        title: Text(AppMessages.askIfUserWantToLogout,
                            style: subTitleTextStyle),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(AppMessages.cancel,
                                style: GreenAddressTextStyle),
                          ),
                          TextButton(
                            onPressed: () {
                              WrapperApi().logout(isLogout: true);
                            },
                            child: Text(AppMessages.logOut,
                                style: GreenAddressTextStyle),
                          ),
                        ],
                      );
                    },
                  )
                },
                child: Text(
                  AppMessages.logout,
                  style: GoogleFonts.poppins(
                    color: const Color(0xffFF153F),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const Gap(70.0),
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
