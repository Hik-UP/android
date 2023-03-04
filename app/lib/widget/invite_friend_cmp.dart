import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';

class InviteFriendCmp extends StatelessWidget {
  const InviteFriendCmp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomTextField(
            hintText: AppMessages.hintEmailFriend,
          ),
        ),
        const Gap(10.0),
        Expanded(
          child: CustomBtn(
            height: 50,
            content: AppMessages.invitMsg,
            onPress: () {},
            gradient: loginButtonColor,
          ),
        )
      ],
    );
  }
}
