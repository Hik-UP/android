import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/comment.dart";

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(comment.pictures);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.green,
                ),
                const Gap(10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author.username,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                      ),
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
            const Gap(16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.body,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                    ),
                  ),
                  if (comment.pictures.isNotEmpty &&
                      comment.pictures.first.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: comment.pictures[0],
                      errorWidget: (context, url, error) => ContainerPicture(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              FontAwesomeIcons.triangleExclamation,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      imageBuilder: (context, imageProvider) =>
                          ContainerPicture(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      progressIndicatorBuilder: (context, url, progress) =>
                          ContainerPicture(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        ),
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
