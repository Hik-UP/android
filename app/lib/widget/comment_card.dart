import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/comment.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/widget/custom_loader.dart";
import "package:hikup/widget/warning_error_img.dart";

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
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
                comment.author.picture.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: comment.author.picture,
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
                      comment.author.username,
                      style: subTitleTextStyle,
                    ),
                    Text(
                      comment.date.toString().split(' ')[0].replaceAll(
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
                    comment.body,
                    style: WhiteAddressTextStyle,
                  ),
                  if (comment.pictures.isNotEmpty &&
                      comment.pictures.first.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: comment.pictures[0],
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
