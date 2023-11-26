import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/widget/email_invite_card.dart';

class InviteFriendCmp extends StatefulWidget {
  final Function(String data) value;
  final List<String> guestList;
  final Function(int index) onGuestRemove;
  const InviteFriendCmp(
      {super.key,
      required this.value,
      required this.guestList,
      required this.onGuestRemove});

  @override
  State<InviteFriendCmp> createState() => _InviteFriendCmpState();
}

class _InviteFriendCmpState extends State<InviteFriendCmp> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _controller,
          hintText: "Email",
        ),
        Visibility(
          visible: widget.guestList.isNotEmpty,
          child: Column(children: [
            Column(children: [
              const Gap(5),
              SizedBox(
                height: 40.0,
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.guestList.length,
                  itemBuilder: (context, index) => EmailInviteCard(
                    email: widget.guestList[index],
                    action: () {
                      widget.onGuestRemove(index);
                    },
                  ),
                  separatorBuilder: (context, index) => const Gap(5),
                ),
              )
            ])
          ]),
        ),
        const Gap(5),
        CustomBtn(
          content: AppMessages.invitMsg,
          onPress: () {
            widget.value(_controller.text);
            _controller.text = "";
          },
          gradient: loginButtonColor,
        ),
      ],
    );
  }
}
