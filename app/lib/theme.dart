import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
const Color primaryColor100 = Color.fromARGB(255, 146, 240, 199);
const Color primaryColor300 = Color.fromARGB(255, 99, 253, 184);
const Color primaryColor500 = Color(0xff04D300);*/

//TEXT AND LINK
const Color GreenPrimary = Color.fromARGB(255, 23, 255, 119);
//GRADIENT
const Color GreenSecondary = Color.fromARGB(255, 34, 253, 173);

//BACKGROUND
const Color BlackPrimary = Color.fromARGB(255, 32, 32, 32);

//ELEMENTS ON BACKGROUND
const Color BlackSecondary = Color.fromARGB(255, 19, 19, 19);

//ICON
const Color BlackTertiary = Color.fromARGB(255, 156, 156, 156);

//const Color colorWhite = Colors.white;

//USE THIS IF YOU DON'T KNOW THE CORRECT COLOR OR STYLE TO USE
const Color HOPA = Color.fromARGB(255, 255, 0, 0);
const Color HOPABLUE = Color.fromARGB(255, 55, 0, 255);
TextStyle HOPASTYLE = GoogleFonts.poppins(color: Colors.white);

const greenColor = Color.fromARGB(255, 255, 94, 0);

const double borderRadiusSize = 16.0;

TextStyle WhiteTitleTextStyle = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white);

TextStyle WhiteAddressTextStyle = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);

TextStyle greySubTextStyle = GoogleFonts.poppins(
    fontSize: 8, fontWeight: FontWeight.w400, color: BlackTertiary);

TextStyle subTitleTextStyle = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white);

TextStyle subErrorTitleTextStyle = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w500, color: BlackTertiary);

TextStyle GreenTitleTextStyle = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700, color: GreenPrimary);

TextStyle GreenSubTitleTextStyle = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w700, color: GreenPrimary);

TextStyle GreenAddressTextStyle = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: GreenPrimary);

TextStyle linkTextStyle = GoogleFonts.poppins(color: GreenPrimary);

TextStyle titleTextStyleWhite = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: const Color.fromARGB(255, 255, 255, 255));

TextStyle descTextStyleWhite = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color.fromARGB(255, 255, 255, 255));

TextStyle addressTextStyleWhite = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color.fromARGB(255, 255, 255, 255));

TextStyle facilityTextStyleWhite = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: const Color.fromARGB(255, 255, 255, 255));

TextStyle priceTextStyleWhite = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: const Color.fromARGB(255, 255, 255, 255));

/*
TextStyle normalTextStyle = GoogleFonts.poppins(color: darkBlue500);

TextStyle greetingTextStyle = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700, color: darkBlue500);

TextStyle titleTextStyle = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w700, color: darkBlue500);

TextStyle descTextStyle = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: darkBlue300);

TextStyle addressTextStyle = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: darkBlue300);

TextStyle facilityTextStyle = GoogleFonts.poppins(
    fontSize: 13, fontWeight: FontWeight.w500, color: darkBlue300);

TextStyle priceTextStyle = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w700, color: darkBlue500);
*/

TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

TextStyle bottomNavTextStyle = GoogleFonts.poppins(
    fontSize: 11, fontWeight: FontWeight.w500, color: GreenPrimary);

TextStyle tabBarTextStyle =
    GoogleFonts.poppins(fontWeight: FontWeight.w500, color: GreenPrimary);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
