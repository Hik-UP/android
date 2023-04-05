import 'dart:io';

import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/update_profil_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
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
    return BaseView<UpdateProfilModel>(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              const Gap(10.0),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: model.userImage != null
                          ? FileImage(File(model.userImage!.path))
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
                              ]),
                          child: const Icon(
                            FontAwesomeIcons.plus,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Username',
            ),
          ),
        ),
                const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
          ),
        ),
              const Spacer(),
 
            CustomBtn(
                content: AppMessages.updateTxt,
                isLoading: model.getState == ViewState.busy,
                onPress: () {
                  if (model.userImage != null) {
                    model.updateProfile(
                      appState: context.read<AppState>(),
                    );
                    return;
                  }
                  locator<CustomNavigationService>().showSnackBack(
                    content: AppMessages.needAPicture,
                    isError: true,
                  );
                },
                gradient: loginButtonColor,
              ),
              const Gap(20.0),
              CustomBtn(
                content: AppMessages.deleteaccount,
                isLoading: model.getState == ViewState.busy,
                onPress: () {
                },
                gradient: deleteButtonColor,
              ), 
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
                      child: Icon(
                        FontAwesomeIcons.deleteLeft,
                        color: darkBlue300,
                      ),
                    ),
                    const Gap(4.0),
                    Text(
                      AppMessages.delete,
                      style: normalTextStyle,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
