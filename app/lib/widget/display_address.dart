import "package:flutter/material.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/constant.dart";

class DisplayAddress extends StatelessWidget {
  final String address;
  const DisplayAddress({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          pinIcon,
          width: 24,
          height: 24,
          color: GreenPrimary,
        ),
        const SizedBox(
          width: 16.0,
        ),
        Flexible(
          child: Text(
            address,
            overflow: TextOverflow.visible,
            style: WhiteAddressTextStyle,
          ),
        ),
      ],
    );
  }
}
