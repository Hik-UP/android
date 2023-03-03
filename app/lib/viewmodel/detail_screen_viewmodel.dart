import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/viewmodel/base_model.dart';

class DetailScreenViewModel extends BaseModel {
  Widget showTools({required List<String> toolsBack}) {
    List<Widget> tools = [];

    for (int i = 0; i + 1 < toolsBack.length; i += 2) {
      tools.add(Row(
        children: [
          Expanded(
            child: Text(
              "${i + 1}. ${toolsBack[i]}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${i + 2}. ${toolsBack[i + 1]}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ));
    }

    return Column(children: tools);
  }
}
