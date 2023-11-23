import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/theme.dart';

class EmailInviteCard extends StatelessWidget {
  final String email;
  final Function() action;
  const EmailInviteCard({
    super.key,
    required this.email,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            email,
            style: HOPASTYLE,
          ),
          const Gap(10.0),
          GestureDetector(
            onTap: action,
            child: const Icon(
              FontAwesomeIcons.circleXmark,
            ),
          ),
        ],
      ),
    );
  }
}
