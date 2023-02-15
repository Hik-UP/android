import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/widget/custom_btn.dart';

import '../../../utils/constant.dart';


class UpdateProfile extends StatelessWidget {
  static String routeName = "/update-profile";
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: [
       const Gap(10.0),
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 70,
              ),

              Positioned(
                right: 10,
                bottom: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(FontAwesomeIcons.camera),
                ),
              ),
            ],
          ),
        ),
       const Spacer(),
        CustomBtn(content: "Modifier", onPress: () {}, gradient: loginButtonColor,),
       const Gap(40.0),
      ]),
    ),));
  }
}