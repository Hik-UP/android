import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class DisplayStatus extends StatelessWidget {
  final Color? bgClor;
  final String status;
  const DisplayStatus({
    super.key,
    required this.status,
    this.bgClor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: bgClor,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(0),
            topLeft: Radius.circular(4.0),
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(0)),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
