import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/viewmodel/community_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/comment_card.dart';
import 'package:hikup/widget/file_upload_cmp.dart';
import 'package:hikup/widget/thumbail_img.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "package:gap/gap.dart";
import 'package:flutter_svg/flutter_svg.dart';

class CommunityView extends StatefulWidget {
  final String trailId;
  static String routeName = "/community";
  const CommunityView({
    super.key,
    required this.trailId,
  });

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<CommunityPageViewModel>(
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              "Avis",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white, // Couleur de la flèche retour
            ),
            backgroundColor: Colors.black,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<Comment>>(
                  future: model.retrieveData(
                    appState: appState,
                    trailId: widget.trailId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0,
                              left: 10.0,
                            ),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                ),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.25),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, index) {
                                IconButton(
                                  color: GreenPrimary,
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
                                  icon: const Icon(Icons.menu),
                                );

                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: CommentCard(
                                    comment: snapshot.data![index],
                                    update: () => setState(() {}),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/cat-error.svg",
                                height: 64,
                                width: 64,
                                colorFilter: const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcIn,
                                ),
                                semanticsLabel: 'error',
                              ),
                              const Gap(20),
                              Center(
                                child: Text(
                                  "Aucun avis",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    return const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 5.0,
                bottom: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (model.image != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ThumbailImg(
                        file: File(model.image!.path),
                        action: () => model.closeThumbmail(),
                      ),
                    ),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: BlackPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: BlackPrimary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          focusNode: model.inputFocus,
                          maxLines: 2,
                          controller: model.textController,
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Ajouter un avis',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
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
                            child: IconButton(
                              padding: const EdgeInsets.all(0.0),
                              iconSize: 20,
                              color: Colors.white,
                              onPressed: () => model.submitMessage(
                                appState: appState,
                                trailId: widget.trailId,
                                update: () {
                                  Future.delayed(
                                    const Duration(seconds: 3),
                                    () => setState(() {}),
                                  );
                                },
                              ),
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
          )),
    );
  }
}
