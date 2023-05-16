import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/widget/custom_loader.dart";
import "package:provider/provider.dart";

class GuestCmp extends StatelessWidget {
  final String picture;
  final String username;
  const GuestCmp({
    Key? key,
    required this.picture,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        picture.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: picture,
                errorWidget: (context, url, target) => const CircleAvatar(
                  radius: 28.0,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.triangleExclamation,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, progress) =>
                    const CircleAvatar(
                  radius: 28.0,
                  child: Center(
                    child: CustomLoader(),
                  ),
                ),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 28.0,
                  backgroundImage: imageProvider,
                ),
              )
            : const CircleAvatar(
                radius: 28.0,
                backgroundImage: AssetImage(profilePlaceHoder),
              ),
        const Gap(4.0),
        Text(
          appState.username != username ? username : AppMessages.me,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
