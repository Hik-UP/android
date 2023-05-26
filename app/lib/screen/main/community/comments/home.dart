import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/community_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/comment_card.dart';
import 'package:hikup/widget/thumbail_img.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CommunityView extends StatefulWidget {
  final String trailId;
  static String routeName = "/community";
  const CommunityView({
    Key? key,
    required this.trailId,
  }) : super(key: key);

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  void myAlert({
    required BuildContext context,
    required Function getImageGallery,
    required Function getImageCamera,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BlackPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            'Sélectionner le média',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImageGallery();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Text('À partir de la gallerie'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImageCamera();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.camera),
                      Text('À partir de la caméra'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<CommunityPageViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            AppMessages.commentaireLabel,
            style: titleTextStyleWhite,
          ),
          iconTheme: const IconThemeData(
            color: GreenPrimary, // Couleur de la flèche retour
          ),
          backgroundColor: BlackPrimary,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(18.0),
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
                            right: 16.0,
                            left: 16.0,
                            top: 20.0,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: CommentCard(
                                  comment: snapshot.data![index],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text(
                            AppMessages.noComment,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 20.0,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: BlackPrimary,
                        //color: const Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          TextFormField(
                            //keyboardType: TextInputType.text,
                            maxLines: 2,
                            controller: model.textController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.white),

                            decoration: const InputDecoration(
                              hintText: 'Écrire un commentaire',
                              //style: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              //style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  color: GreenPrimary,
                                  onPressed: () => model.submitMessage(
                                    appState: appState,
                                    trailId: widget.trailId,
                                    update: () {
                                      setState(() {});
                                    },
                                  ),
                                  icon: const Icon(
                                    Icons.send_outlined,
                                  ),
                                ),
                                IconButton(
                                  color: GreenPrimary,
                                  onPressed: () {
                                    myAlert(
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
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
