import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';

class InviteFriendCmp extends StatefulWidget {
  final Function(String data) value;
  const InviteFriendCmp({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<InviteFriendCmp> createState() => _InviteFriendCmpState();
}

class _InviteFriendCmpState extends State<InviteFriendCmp> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomTextField(
            controller: _controller,
            hintText: AppMessages.hintEmailFriend,
          ),
        ),
        const Gap(10.0),
        Expanded(
          child: CustomBtn(
            height: 50,
            content: AppMessages.invitMsg,
            onPress: () {
              widget.value(_controller.text);
              _controller.text = "";
            },
            gradient: loginButtonColor,
          ),
        )
      ],
    );
  }
}
