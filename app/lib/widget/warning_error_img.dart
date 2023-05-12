import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class WarmingErrorImg extends StatelessWidget {
  const WarmingErrorImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          FontAwesomeIcons.triangleExclamation,
          color: Colors.white,
        )
      ],
    );
  }
}
