/*import 'dart:io';

import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/viewmodel/edit_comments_model.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/widget/upload_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';

import '../../../theme.dart';
import '../../../utils/constant.dart';

class Editcomment extends StatelessWidget {
  const Editcomment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<EditCommentModel>(builder: (context, model, child) {
      model.commentCtrl.text = appState.comment;

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            AppMessages.modifprofilTxt,
            style: titleTextStyleWhite,
          ),
          iconTheme: const IconThemeData(
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
              child: Consumer<AppState>(builder: (context, state, child) {
                return Column(children: [
                const Gap(10.0),
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
                      ): LoadPictureProfil(
                        appState: state,
                        size: 140
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Commentaire",
                      style: subTitleTextStyle,
                    ),
                  ),
                ),
                const Gap(5.0),
                CustomTextField(
                  controller: model.commentCtrl,
                  hintText: "Commentaire",
                  //validator: Validation.validateUsername,
                ),
                const Gap(20.0),
                const Gap(5.0),
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
                    model.editComment(
                      appState: appState,
                      comment: model.commentCtrl.text,
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
              ]);
            }),
            ),
          ),
        ),
      );
    });
  }
}*/
