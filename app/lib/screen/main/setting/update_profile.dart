import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/viewmodel/update_profil_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/widget/scaffold_with_custom_bg.dart';
import 'package:hikup/widget/upload_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';
import 'package:hikup/model/user.dart';

import '../../../theme.dart';
import '../../../utils/constant.dart';

class UpdateProfile extends StatefulWidget {
  static String routeName = "/update-profile";
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _navigationService = locator<CustomNavigationService>();
  bool verifyEmail = false;
  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<UpdateProfilModel>(builder: (context, model, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isInit == false) {
          model.emailCtrl.text = appState.verifyEmail.isNotEmpty
              ? appState.verifyEmail
              : appState.email;
          model.usernameCtrl.text = appState.username;
          model.verifyController.text = '';
          setState(() {
            isInit = true;
          });
        }
        if (model.emailCtrl.text == appState.verifyEmail &&
            verifyEmail == false &&
            appState.verifyEmail.isNotEmpty) {
          setState(() {
            verifyEmail = true;
          });
        }
      });

      return ScaffoldWithCustomBg(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            AppMessages.modifprofilTxt,
            style: titleTextStyleWhite,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Couleur de la flèche retour
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Consumer<AppState>(builder: (context, state, child) {
              return Column(children: [
                const Gap(20.0),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      model.userImage != null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundImage: FileImage(
                                File(
                                  model.userImage!.path,
                                ),
                              ),
                            )
                          : LoadPictureProfil(appState: state, size: 140),
                      Positioned(
                        left: 50,
                        bottom: -12,
                        child: GestureDetector(
                          onTap: () async {
                            var result = await showModalBottomSheet(
                              context: context,
                              builder: (context) => const UplaodPicture(),
                            ) as XFile?;
                            model.setUserImage(value: result);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 0.5,
                                )
                              ],
                            ),
                            child: const Icon(
                              FontAwesomeIcons.plus,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(50.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nom d'utilisateur",
                    style: subTitleTextStyle,
                  ),
                ),
                const Gap(5.0),
                CustomTextField(
                  formKey: model.nameFormKey,
                  controller: model.usernameCtrl,
                  hintText: "Nom d'utilisateur",
                  validator: Validation.validateUsername,
                ),
                const Gap(20.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: subTitleTextStyle,
                  ),
                ),
                const Gap(5.0),
                CustomTextField(
                  formKey: model.mailFormKey,
                  controller: model.emailCtrl,
                  hintText: "Email",
                  validator: model.validateEmail,
                  onChange: (value) {
                    if (verifyEmail == true) {
                      model.verifyController.text = '';
                      setState(() {
                        verifyEmail = false;
                      });
                    }
                  },
                ),
                const Gap(20.0),
                verifyEmail == true
                    ? Column(children: [
                        CustomTextField(
                          formKey: model.tokenFormKey,
                          controller: model.verifyController,
                          hintText: "Code de vérification",
                          validator: model.validateToken,
                          maxLine: 1,
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                width: 80,
                                child: CustomBtn(
                                    bgColor: Colors.transparent,
                                    borderColor: Colors.transparent,
                                    textColor: Colors.green,
                                    isLoading:
                                        model.getState == ViewState.update,
                                    disabled:
                                        model.getState == ViewState.deletion,
                                    onPress: () {
                                      if (!model.tokenFormKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      model.updateProfileVerify(
                                          appState: appState,
                                          email: model.emailCtrl.text,
                                          token: model.verifyController.text,
                                          onSuccess: () {
                                            model.verifyEmail = '';
                                            model.verifyController.text = '';
                                            appState.setVerifyEmail(
                                                value: null);
                                            setState(() {
                                              verifyEmail = false;
                                            });
                                          });
                                    },
                                    content: "Valider")),
                            SizedBox(
                              width: 80,
                              child: CustomBtn(
                                bgColor: Colors.transparent,
                                borderColor: Colors.transparent,
                                textColor: Colors.red,
                                isLoading: model.getState == ViewState.deletion,
                                disabled: model.getState == ViewState.update,
                                onPress: () {
                                  model.cancelEmailVerify(
                                      appState: appState,
                                      onSuccess: () {
                                        model.emailCtrl.text = appState.email;
                                        model.verifyEmail = '';
                                        model.verifyController.text = '';
                                        appState.setVerifyEmail(value: null);
                                        setState(() {
                                          verifyEmail = false;
                                        });
                                      });
                                },
                                content: "Annuler",
                              ),
                            ),
                          ],
                        ),
                      ])
                    : Container(),
                verifyEmail ? const Gap(20) : Container(),
                CustomBtn(
                  content: AppMessages.updateTxt,
                  isLoading: model.getState == ViewState.busy,
                  onPress: () {
                    if (!model.nameFormKey.currentState!.validate() ||
                        !model.mailFormKey.currentState!.validate()) {
                      return;
                    }
                    if (appState.picture.isEmpty && model.userImage == null) {
                      locator<CustomNavigationService>().showSnackBack(
                        content: AppMessages.needAPicture,
                        isError: true,
                      );
                      return;
                    }
                    if (verifyEmail == false &&
                        model.emailCtrl.text == appState.verifyEmail) {
                      _navigationService.showSnackBack(
                        content: "Veuillez vérifier votre adresse Email",
                        isError: false,
                      );
                      setState(() {
                        verifyEmail = true;
                      });
                    } else if (verifyEmail == false) {
                      model.verifyEmail = model.emailCtrl.text;
                      model.updateProfile(
                          appState: appState,
                          username: model.usernameCtrl.text,
                          email: model.emailCtrl.text,
                          onVerify: () {
                            setState(() {
                              verifyEmail = true;
                            });
                          });
                    } else {
                      model.updateProfile(
                          appState: appState,
                          username: model.usernameCtrl.text,
                          email: appState.email,
                          onVerify: () {
                            setState(() {
                              verifyEmail = true;
                            });
                          });
                    }
                    return;
                  },
                  gradient: loginButtonColor,
                ),
              ]);
            }),
          ),
        ),
      );
    });
  }
}
