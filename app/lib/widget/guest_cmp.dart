import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/utils/app_messages.dart";
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
        const CircleAvatar(
          radius: 28.0,
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
