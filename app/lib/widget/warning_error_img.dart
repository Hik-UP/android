import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class WarmingErrorImg extends StatelessWidget {
  const WarmingErrorImg({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.triangleExclamation,
          color: Colors.white,
        )
      ],
    );
  }
}
