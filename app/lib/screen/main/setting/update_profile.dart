import 'dart:io';
import 'dart:async';
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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';
import 'package:hikup/screen/auth/reset_page.dart';
import 'package:hikup/widget/file_upload_cmp.dart';

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

      void startTimer(int start) {
        model.delay = start;
        const oneSec = Duration(seconds: 1);
        model.timer = Timer.periodic(
          oneSec,
          (Timer timer) {
            if (model.delay == 0) {
              setState(() {
                timer.cancel();
              });
            } else {
              setState(() {
                model.delay = model.delay - 1;
              });
            }
          },
        );
      }

      return WillPopScope(
          onWillPop: () async {
            if (model.timer != null) {
              model.timer?.cancel();
              model.delay = 0;
            }
            return true;
          },
          child: ScaffoldWithCustomBg(
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
                                FileUploadCmp.myAlert(
                                  context: context,
                                  getImageGallery: () => model
                                      .getImage(ImageSource.gallery, (image) {
                                    model.setUserImage(value: image);
                                  }),
                                  getImageCamera: () => model
                                      .getImage(ImageSource.camera, (image) {
                                    model.setUserImage(value: image);
                                  }),
                                );
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
                        if (model.timer != null) {
                          model.timer?.cancel();
                          model.delay = 0;
                        }
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
                                    child: CustomBtn(
                                        bgColor: Colors.transparent,
                                        borderColor: Colors.transparent,
                                        textColor: Colors.white,
                                        isLoading:
                                            model.getState == ViewState.resend,
                                        disabled:
                                            model.getState == ViewState.busy ||
                                                model.delay != 0,
                                        onPress: () => model.resend(
                                            email: appState.email,
                                            onDelay: (delay) {
                                              startTimer(delay);
                                            }),
                                        content: model.delay == 0
                                            ? "Renvoyer un code"
                                            : "Renvoyer un code (${model.delay})")),
                                SizedBox(
                                    //width: 80,
                                    child: CustomBtn(
                                        bgColor: Colors.transparent,
                                        borderColor: Colors.transparent,
                                        textColor: Colors.green,
                                        isLoading:
                                            model.getState == ViewState.update,
                                        disabled: model.getState ==
                                            ViewState.deletion,
                                        onPress: () {
                                          if (!model.tokenFormKey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          model.updateProfileVerify(
                                              appState: appState,
                                              email: model.emailCtrl.text,
                                              token:
                                                  model.verifyController.text,
                                              onSuccess: () {
                                                model.verifyEmail = '';
                                                model.verifyController.text =
                                                    '';
                                                appState.setVerifyEmail(
                                                    value: null);
                                                setState(() {
                                                  verifyEmail = false;
                                                });
                                              });
                                        },
                                        content: "Valider")),
                                SizedBox(
                                  //width: 80,
                                  child: CustomBtn(
                                    bgColor: Colors.transparent,
                                    borderColor: Colors.transparent,
                                    textColor: Colors.red,
                                    isLoading:
                                        model.getState == ViewState.deletion,
                                    disabled:
                                        model.getState == ViewState.update,
                                    onPress: () {
                                      model.cancelEmailVerify(
                                          appState: appState,
                                          onSuccess: () {
                                            model.emailCtrl.text =
                                                appState.email;
                                            model.verifyEmail = '';
                                            model.verifyController.text = '';
                                            appState.setVerifyEmail(
                                                value: null);
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
                      bgColor: const Color.fromRGBO(253, 210, 59, 0.8)
                          .withOpacity(0.2),
                      borderColor: const Color.fromRGBO(253, 210, 59, 0.8),
                      content: "Modifier mon mot de passe",
                      disabled: model.getState == ViewState.busy,
                      onPress: () => Navigator.of(context).pushNamed(
                          ResetPage.routeName,
                          arguments: {'isReset': false}),
                    ),
                    const Gap(20),
                    CustomBtn(
                      content: AppMessages.updateTxt,
                      isLoading: model.getState == ViewState.busy,
                      onPress: () {
                        if (!model.nameFormKey.currentState!.validate() ||
                            !model.mailFormKey.currentState!.validate()) {
                          return;
                        }
                        if (appState.picture.isEmpty &&
                            model.userImage == null) {
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
                          model.verifyEmail =
                              model.emailCtrl.text.toLowerCase();
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
          ));
    });
  }
}
