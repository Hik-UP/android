import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/locator.dart";
import "package:hikup/model/comment.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/service/custom_navigation.dart";
import "package:hikup/service/dio_service.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_loader.dart";
import "package:hikup/widget/custom_text_field.dart";
import "package:hikup/widget/warning_error_img.dart";
import "package:provider/provider.dart";

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function update;
  const CommentCard({
    Key? key,
    required this.comment,
    required this.update,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final TextEditingController newCommentCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return Card(
      color: BlackPrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                widget.comment.author.picture.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.comment.author.picture,
                        imageBuilder: (context, imageProvider) =>
                            ShowAvatarContainer(
                          backgroundImage: imageProvider,
                        ),
                        errorWidget: (context, url, error) =>
                            const ShowAvatarContainer(
                          child: WarmingErrorImg(),
                        ),
                        progressIndicatorBuilder: (context, url, progress) =>
                            const ShowAvatarContainer(
                          child: CustomLoader(),
                        ),
                      )
                    : const ShowAvatarContainer(
                        backgroundImage: AssetImage(
                          profilePlaceHoder,
                        ),
                      ),
                const Gap(10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment.author.username,
                      style: subTitleTextStyle,
                    ),
                    Text(
                      widget.comment.date.toString().split(' ')[0].replaceAll(
                            RegExp(r'-'),
                            "/",
                          ),
                      style: GoogleFonts.poppins(
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(18.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.body,
                    style: WhiteAddressTextStyle,
                  ),
                  if (widget.comment.pictures.isNotEmpty &&
                      widget.comment.pictures.first.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: widget.comment.pictures[0],
                      errorWidget: (context, url, error) =>
                          const ContainerPicture(
                        child: WarmingErrorImg(),
                      ),
                      imageBuilder: (context, imageProvider) =>
                          ContainerPicture(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      progressIndicatorBuilder: (context, url, progress) =>
                          const ContainerPicture(
                        child: CustomLoader(),
                      ),
                    )
                ],
              ),
            ),
            IconButton(
              color: GreenPrimary,
              onPressed: () {
                locator<CustomNavigationService>().showDialogue(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Nouveau commentaire",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                      const Gap(4.0),
                      CustomTextField(
                        controller: newCommentCtrl,
                      ),
                      const Gap(4.0),
                      CustomBtn(
                        isLoading: isLoading,
                        content: "Modifier",
                        bgColor: Colors.green,
                        onPress: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await locator<DioService>().put(
                            path: updateCommentPath,
                            body: {
                              "user": {
                                "id": appState.id,
                                "roles": appState.roles,
                              },
                              "comment": {
                                "id": widget.comment.id,
                                "body": newCommentCtrl.text
                              },
                            },
                            token: 'Bearer ${appState.token}',
                          );

                          setState(() {
                            isLoading = false;
                          });
                        },
                      )
                    ],
                  ),
                  action: () {
                    widget.update();
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerPicture extends StatelessWidget {
  final Widget? child;
  final DecorationImage? image;
  const ContainerPicture({
    Key? key,
    this.image,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2 * .4,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
        image: image,
      ),
      child: child,
    );
  }
}

class ShowAvatarContainer extends StatelessWidget {
  final Widget? child;
  final ImageProvider<Object>? backgroundImage;
  const ShowAvatarContainer({
    Key? key,
    this.backgroundImage,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.green,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}
