import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          shape: BoxShape.circle,
        ),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 26,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
    );
  }
}
