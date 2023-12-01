import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_text_field.dart";

class UpdateCommentDialogue extends StatelessWidget {
  final bool isLoadingEdit;
  final bool isLoadingDelete;
  final TextEditingController controller;
  final Function() editAction;
  final Function() deleteAction;

  const UpdateCommentDialogue({
    super.key,
    required this.controller,
    this.isLoadingEdit = false,
    this.isLoadingDelete = false,
    required this.editAction,
    required this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Votre avis",
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          ),
          const Gap(20.0),
          CustomTextField(
            controller: controller,
          ),
          const Gap(15.0),
          Row(
            children: [
              Expanded(
                  child: CustomBtn(
                isLoading: isLoadingEdit,
                content: AppMessages.updateCommentLabel,
                onPress: editAction,
              )),
              const Gap(5),
              Expanded(
                child: CustomBtn(
                  isLoading: isLoadingDelete,
                  content: "Supprimer",
                  bgColor: const Color.fromRGBO(132, 16, 42, 1),
                  borderColor: const Color.fromRGBO(255, 21, 63, 1),
                  onPress: deleteAction,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
