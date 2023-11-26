import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailInviteCard extends StatelessWidget {
  final String email;
  final Function() action;
  final bool showIcon;
  const EmailInviteCard({
    super.key,
    required this.email,
    required this.action,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            email,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, color: Colors.white, fontSize: 12),
          ),
          const Gap(10.0),
          Visibility(
            visible: showIcon,
            child: GestureDetector(
              onTap: action,
              child: const Icon(
                FontAwesomeIcons.circleXmark,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
