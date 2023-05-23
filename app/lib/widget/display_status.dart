import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class DisplayStatus extends StatelessWidget {
  final Color? bgClor;
  final String status;
  const DisplayStatus({
    Key? key,
    required this.status,
    this.bgClor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: bgClor,
        borderRadius: BorderRadius.circular(8.0),
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