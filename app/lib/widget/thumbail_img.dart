import "dart:io";

import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class ThumbailImg extends StatelessWidget {
  final Function() action;
  final File file;
  const ThumbailImg({
    super.key,
    required this.file,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: -8,
          top: -8,
          child: GestureDetector(
            onTap: action,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                FontAwesomeIcons.xmark,
                color: Colors.grey,
                size: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
