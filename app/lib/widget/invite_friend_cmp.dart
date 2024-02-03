import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/widget/email_invite_card.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/locator.dart';

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
  GlobalKey<FormState> inviteFormKey = GlobalKey<FormState>();
  bool isDisabled = true;
  bool isUserExist = true;
  final _dioService = locator<DioService>();
  bool addLoading = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    checkEmail({required String email}) async {
      try {
        Map<String, dynamic> user = {
          "id": appState.id,
          "roles": appState.roles,
        };

        var result = await _dioService.post(
          path: checkUserPath,
          token: "Bearer ${appState.token}",
          body: {
            "user": user,
            "other": {"email": email.toLowerCase()}
          },
        );
        if (result.statusCode == 200) {
          return true;
        }
        return false;
      } catch (e) {
        return false;
      }
    }

    String? validateEmail(String? email) {
      if (email == null || email.isEmpty) {
        return null;
      } else if (email.length > 256) {
        return "Ne peut avoir plus de 256 caractères";
      } else if (!Validation.emailValidator(email)) {
        return AppMessages.wrongEmail;
      } else if (isUserExist == false) {
        return "Cet utilisateur n'existe pas";
      }
      return null;
    }

    return Column(
      children: [
        Form(
          key: inviteFormKey,
          child: CustomTextField(
            controller: _controller,
            hintText: "Email",
            validator: validateEmail,
            onChange: (value) {
              if (_controller.text.isEmpty) {
                inviteFormKey.currentState!.validate();
              }
              setState(() {
                isUserExist = true;
                isDisabled = _controller.text.isEmpty;
              });
            },
          ),
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
        const Gap(10),
        CustomBtn(
          content: AppMessages.invitMsg,
          disabled: isDisabled,
          isLoading: addLoading,
          onPress: () async {
            setState(() {
              addLoading = true;
            });
            if (inviteFormKey.currentState!.validate()) {
              if (await checkEmail(
                    email: _controller.text,
                  ) ==
                  false) {
                setState(() {
                  isUserExist = false;
                  addLoading = false;
                });
                inviteFormKey.currentState!.validate();
                return;
              } else {
                setState(() {
                  isUserExist = true;
                });
                inviteFormKey.currentState!.validate();
              }
              widget.value(_controller.text);
              _controller.text = "";
              setState(() {
                isDisabled = _controller.text.isEmpty;
              });
            }
            setState(() {
              addLoading = false;
            });
          },
          gradient: loginButtonColor,
        ),
      ],
    );
  }
}
