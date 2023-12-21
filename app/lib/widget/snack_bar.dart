import 'package:flutter/material.dart';

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
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 120,
          left: 10,
          right: 10),
      backgroundColor: isError
          ? const Color.fromRGBO(132, 16, 42, 1)
          : const Color.fromRGBO(12, 60, 40, 1),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1.0,
          color: isError
              ? const Color.fromRGBO(255, 21, 63, 1)
              : const Color.fromRGBO(21, 255, 120, 1),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: Text(
        content,
      ),
    );
  }
}
