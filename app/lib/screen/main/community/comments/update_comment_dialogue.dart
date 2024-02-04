import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_text_field.dart";
import 'package:hikup/utils/constant.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/locator.dart';

class UpdateCommentDialogue extends StatefulWidget {
  final TextEditingController controller;
  final Function() update;
  final String commentId;
  const UpdateCommentDialogue({
    super.key,
    required this.controller,
    required this.update,
    required this.commentId,
  });

  @override
  State<UpdateCommentDialogue> createState() => _UpdateCommentDialogueState();
}

class _UpdateCommentDialogueState extends State<UpdateCommentDialogue> {
  final _customNavigationService = locator<CustomNavigationService>();
  final commentFormKey = GlobalKey<FormFieldState>();
  final _dioService = DioService();
  bool editLoading = false;
  bool deleteLoading = false;

  String? validateComment(String? comment) {
    if (comment == null || comment.isEmpty) {
      return "Vous devez écrire un avis";
    } else if (comment.length > 2048) {
      return "Ne peut avoir plus de 2048 caractères";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

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
            formKey: commentFormKey,
            controller: widget.controller,
            validator: validateComment,
          ),
          const Gap(15.0),
          Row(
            children: [
              Expanded(
                  child: CustomBtn(
                isLoading: editLoading,
                content: AppMessages.updateCommentLabel,
                onPress: () async {
                  try {
                    if (commentFormKey.currentState!.validate()) {
                      setState(() {
                        editLoading = true;
                      });
                      await _dioService.put(
                        path: updateCommentPath,
                        body: {
                          "user": {
                            "id": appState.id,
                            "roles": appState.roles,
                          },
                          "comment": {
                            "id": widget.commentId,
                            "body": widget.controller.text,
                          },
                        },
                        token: 'Bearer ${appState.token}',
                      );
                      setState(() {
                        editLoading = false;
                      });
                      _customNavigationService.showSnackBack(
                        content: "Votre commentaire a été édité",
                        isError: false,
                      );
                      widget.update();
                    }
                  } catch (e) {
                    _customNavigationService.showSnackBack(
                      content: "Une erreur est survenue",
                      isError: true,
                    );
                    widget.update();
                  }
                },
              )),
              const Gap(5),
              Expanded(
                child: CustomBtn(
                  isLoading: deleteLoading,
                  content: "Supprimer",
                  bgColor: const Color.fromRGBO(132, 16, 42, 1),
                  borderColor: const Color.fromRGBO(255, 21, 63, 1),
                  onPress: () async {
                    try {
                      setState(() {
                        deleteLoading = true;
                      });
                      await _dioService.delete(
                        path: deleteCommentPath,
                        body: {
                          "user": {
                            "id": appState.id,
                            "roles": appState.roles,
                          },
                          "comment": {
                            "id": widget.commentId,
                          },
                        },
                        token: 'Bearer ${appState.token}',
                      );
                      setState(() {
                        deleteLoading = false;
                      });
                      _customNavigationService.showSnackBack(
                        content: "Votre commentaire a été supprimé",
                        isError: false,
                      );
                      widget.update();
                    } catch (e) {
                      _customNavigationService.showSnackBack(
                        content: "Une erreur est survenue",
                        isError: true,
                      );
                      widget.update();
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
