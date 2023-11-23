import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 26,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
    );
  }
}
