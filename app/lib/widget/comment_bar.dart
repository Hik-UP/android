import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/viewmodel/comment_bar_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/file_upload_cmp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "package:gap/gap.dart";
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/thumbail_img.dart';

class CommentBar extends StatefulWidget {
  final String trailId;
  final Function() update;
  const CommentBar({super.key, required this.trailId, required this.update});

  @override
  State<CommentBar> createState() => _CommentBarState();
}

class _CommentBarState extends State<CommentBar> {
  final TextEditingController newCommentCtrl = TextEditingController();
  bool isLoading = false;
  FocusNode inputFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<CommentBarViewModel>(
        builder: (context, model, child) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.image != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
                      child: ThumbailImg(
                        file: File(model.image!.path),
                        action: () => model.closeThumbmail(),
                      ),
                    ),
                  Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        top: 5.0,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: TextFormField(
                                  key: model.commentFormKey,
                                  validator: model.validateComment,
                                  focusNode: model.inputFocus,
                                  maxLines: 2,
                                  controller: model.textController,
                                  keyboardType: TextInputType.text,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Ajouter un avis',
                                    prefix: const Padding(
                                        padding: EdgeInsets.only(left: 15.0)),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        0, 15, 15, 15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    fillColor: BlackPrimary,
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(15),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0.0),
                                      iconSize: 20,
                                      color: Colors.white,
                                      onPressed: () {
                                        FileUploadCmp.myAlert(
                                          context: context,
                                          getImageGallery: () => model.getImage(
                                            ImageSource.gallery,
                                          ),
                                          getImageCamera: () => model.getImage(
                                            ImageSource.camera,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.camera_alt),
                                    ),
                                  ),
                                  const Gap(5),
                                  SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: model.getState == ViewState.create
                                        ? const CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          )
                                        : IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            iconSize: 20,
                                            color: Colors.white,
                                            onPressed: () {
                                              if (model
                                                  .commentFormKey.currentState!
                                                  .validate()) {
                                                model.submitMessage(
                                                  appState: appState,
                                                  trailId: widget.trailId,
                                                  update: () => widget.update(),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.send_outlined,
                                            ),
                                          ),
                                  )
                                ])
                          ])
                        ],
                      ),
                    ),
                  )
                ]));
  }
}
