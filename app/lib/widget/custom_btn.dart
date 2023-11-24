import "package:flutter/material.dart";

class CustomBtn extends StatelessWidget {
  final String content;
  final Function()? onPress;
  final Gradient? gradient;
  final bool isLoading;
  final double height;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  const CustomBtn(
      {super.key,
      required this.content,
      required this.onPress,
      this.gradient,
      this.isLoading = false,
      this.height = 40,
      this.textColor = Colors.white,
      this.bgColor = const Color.fromRGBO(12, 60, 40, 1),
      this.borderColor = const Color.fromRGBO(21, 255, 120, 1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: gradient,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPress,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            backgroundColor: bgColor,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(
              width: 1.0,
              color: borderColor,
            )),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  content,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
