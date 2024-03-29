import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkinTarget extends StatelessWidget {
  final String skinUrlImage;
  const SkinTarget({
    super.key,
    required this.skinUrlImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
        child: skinUrlImage.isEmpty
            ? const Icon(
                FontAwesomeIcons.triangleExclamation,
              )
            : Image.network(
                skinUrlImage,
              ),
      ),
    );
  }
}
