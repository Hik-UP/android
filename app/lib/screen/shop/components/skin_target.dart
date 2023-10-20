import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hikup/utils/constant.dart';

class SkinTarget extends StatelessWidget {
  final String skinUrlImage;
  const SkinTarget({
    Key? key,
    required this.skinUrlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          targetSkin,
          width: double.infinity,
          height: 77,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: skinUrlImage.isEmpty
                ? Icon(
                    FontAwesomeIcons.triangleExclamation,
                  )
                : Image.network(
                    skinUrlImage,
                    width: 30.0,
                    height: 40.0,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ],
    );
  }
}
