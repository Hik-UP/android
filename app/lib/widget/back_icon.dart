import 'package:flutter/material.dart';

import 'package:hikup/theme.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: HOPA,
          shape: BoxShape.circle,
        ),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 26,
            icon: const Icon(
              Icons.arrow_back,
              color: HOPA,
            )),
      ),
    );
  }
}
