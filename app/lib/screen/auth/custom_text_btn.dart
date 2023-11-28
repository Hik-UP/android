import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CustomTextBtn extends StatelessWidget {
  final Function() onPressed;
  final String label;
  final Color color;
  const CustomTextBtn({
    super.key,
    required this.onPressed,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: color,
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}
