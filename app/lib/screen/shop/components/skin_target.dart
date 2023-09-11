import 'package:flutter/material.dart';
import 'package:hikup/utils/constant.dart';

class SkinTarget extends StatelessWidget {
  const SkinTarget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      targetSkin,
      width: double.infinity,
      height: 77,
      fit: BoxFit.contain,
    );
  }
}
