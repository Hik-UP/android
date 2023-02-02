import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';

class CustomSnackBar {
  final String content;
  final bool isError;
  final BuildContext context;

  const CustomSnackBar({
    required this.content,
    this.isError = false,
    required this.context,
  });

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(returnSnackBar(
      content: content,
      isError: isError,
    ));
  }

  SnackBar returnSnackBar({
    bool isError = false,
    required String content,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? redColor : greenColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: Text(
        content,
      ),
    );
  }
}
