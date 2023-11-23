import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/comment.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/viewmodel/comment_card_viewmodel.dart";
import "package:hikup/widget/base_view.dart";
import "package:hikup/widget/custom_loader.dart";
import "package:hikup/widget/warning_error_img.dart";
import "package:provider/provider.dart";

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function() update;
  const CommentCard({
    super.key,
    required this.comment,
    required this.update,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final TextEditingController newCommentCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<CommentCardViewModel>(
      builder: (context, model, child) => InkWell(
        onLongPress: () => widget.comment.author.username == appState.username
            ? model.updateComment(
                update: widget.update,
                appState: appState,
                comment: widget.comment,
              )
            : null,
        child: Card(
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
                            progressIndicatorBuilder:
                                (context, url, progress) =>
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
                          widget.comment.date
                              .toString()
                              .split(' ')[0]
                              .replaceAll(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerPicture extends StatelessWidget {
  final Widget? child;
  final DecorationImage? image;
  const ContainerPicture({
    super.key,
    this.image,
    this.child,
  });

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
    super.key,
    this.backgroundImage,
    this.child,
  });

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
