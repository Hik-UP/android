import 'dart:io';

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
import 'package:hikup/widget/upload_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';
import '../../../utils/constant.dart';

class UpdateProfile extends StatelessWidget {
  static String routeName = "/update-profile";
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<UpdateProfilModel>(builder: (context, model, child) {
      model.emailCtrl.text = appState.email;
      model.usernameCtrl.text = appState.username;

      return Scaffold(
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          AppMessages.modifprofilTxt,
          style: titleTextStyleWhite,
        ),
        iconTheme: IconThemeData(
            color: GreenPrimary, // Couleur de la flèche retour
        ),
        backgroundColor: BlackPrimary,
        centerTitle: true,
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: model.formKey,
              child: Column(children: [
                const Gap(10.0),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: model.userImage != null
                            ? FileImage(
                                File(
                                  model.userImage!.path,
                                ),
                              )
                            : null,
                      ),
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
                CustomTextField(
                  controller: model.usernameCtrl,
                  hintText: 'Prénom',
                  validator: Validation.validateUsername,
                ),
                const Gap(20.0),
                CustomTextField(
                  controller: model.emailCtrl,
                  hintText: "Email",
                  validator: Validation.validEmail,
                ),
                const Gap(20.0),
                CustomBtn(
                  content: AppMessages.updateTxt,
                  isLoading: model.getState == ViewState.busy,
                  onPress: () {
                    if (!model.formKey.currentState!.validate()) {
                      return;
                    }
                    if (appState.picture.isEmpty && model.userImage == null) {
                      locator<CustomNavigationService>().showSnackBack(
                        content: AppMessages.needAPicture,
                        isError: true,
                      );
                      return;
                    }
                    model.updateProfile(
                      appState: appState,
                      username: model.usernameCtrl.text,
                      email: model.emailCtrl.text,
                    );
                    return;
                  },
                  gradient: loginButtonColor,
                ),
                const Gap(70.0),
                // CustomBtn(
                //   content: AppMessages.deleteaccount,
                //   onPress: () {},
                //   gradient: deleteButtonColor,
                // ),
                const Gap(20.0),
                InkWell(
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppMessages.askUserWantToDelete),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(AppMessages.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                //WrapperApi().logout(isLogout: true);
                              },
                              child: Text(AppMessages.delete),
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
                        // child: Icon(
                        //   FontAwesomeIcons.deleteLeft,
                        //   color: darkBlue300,
                        // ),
                      ),
                      //const Gap(4.0),
                      // Text(
                      //   AppMessages.delete,
                      //   style: normalTextStyle,
                      // ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    });
  }
}
