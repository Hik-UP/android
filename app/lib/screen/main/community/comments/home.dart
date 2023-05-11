import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/community_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hikup/viewmodel/comments_model.dart';
import 'package:provider/provider.dart';

class CommunityView extends StatelessWidget {
  final String trailId;
  static String routeName = "/community";
  const CommunityView({
    Key? key,
    required this.trailId,
  }) : super(key: key);

  void myAlert({
    required BuildContext context,
    required Function getImageGallery,
    required Function getImageCamera,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Please choose media to select'),
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
                      Text('From Gallery'),
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
                      Text('From Camera'),
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
        resizeToAvoidBottomInset: false,
        appBar: const Header(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    FutureBuilder<List<Comment>>(
                      future: model.retrieveData(
                        appState: appState,
                        trailId: trailId,
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

                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          List<Comment> commentsPhotos = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: commentsPhotos.length,
                            itemBuilder: (context, index) {
                              Comment commentPhoto = commentsPhotos[index];
                              return Card(
                                child: Column(
                                  children: [
                                    Text(
                                      commentPhoto.author.username,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        commentPhoto.body,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: commentPhoto.pictures.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        String pictures =
                                            commentPhoto.pictures[index];
                                        return Image.network(pictures);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return Padding(
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
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            autofocus: true,
                            controller: model.textController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
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
                                  color: Colors.green,
                                  onPressed: () => model.submitMessage(),
                                  icon: const Icon(
                                    Icons.send_outlined,
                                  ),
                                ),
                                IconButton(
                                  color: Colors.green,
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
