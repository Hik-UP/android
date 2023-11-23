import "package:flutter/material.dart";

class SkinInventoryCard extends StatelessWidget {
  final String img;
  const SkinInventoryCard({
    super.key,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xff7D7D7D).withOpacity(0.2),
        border: Border.all(
            width: 2.0, color: const Color(0xff7D7D7D).withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Image.network(img),
    );
  }
}
