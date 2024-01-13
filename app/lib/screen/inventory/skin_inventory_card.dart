import "package:flutter/material.dart";

class SkinInventoryCard extends StatelessWidget {
  final bool isUnLock;
  final String? img;
  const SkinInventoryCard({
    super.key,
    required this.img,
    required this.isUnLock,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xff7D7D7D).withOpacity(0.2),
            border: Border.all(
                width: 2.0, color: const Color(0xff7D7D7D).withOpacity(0.5)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: img != null ? Image.network(img!) : null,
        ),
        Visibility(
          visible: !isUnLock,
          child: Center(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isUnLock,
          child: const Positioned.fill(
            child: Icon(
              Icons.lock,
              color: Colors.white,
              size: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
