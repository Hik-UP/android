import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_text_field.dart";

class UpdateCommentDialogue extends StatelessWidget {
  final bool isLoading;
  final TextEditingController controller;
  final Function() action;

  const UpdateCommentDialogue({
    super.key,
    required this.controller,
    this.isLoading = false,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppMessages.updateCommentLabel,
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          const Gap(20.0),
          CustomTextField(
            controller: controller,
          ),
          const Gap(20.0),
          CustomBtn(
            isLoading: isLoading,
            content: AppMessages.updateCommentLabel,
            bgColor: Colors.green,
            onPress: action,
          )
        ],
      ),
    );
  }
}
