import "package:flutter/material.dart";

class CustomBtn extends StatelessWidget {
  final String content;
  final Function()? onPress;
  final Gradient? gradient;
  final bool isLoading;
  const CustomBtn({
    Key? key,
    required this.content,
    required this.onPress,
    this.gradient,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: gradient,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
