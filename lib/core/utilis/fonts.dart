import 'package:flutter/material.dart';

class Fonts {
  Fonts();
  static const String raleway = 'Raleway';
  static const String ralewaySemibold = 'Raleway-Semibold';
  static const String ralewayBold = ' Raleway-Bold';
  static const String ralewayExtraBold = 'Raleway-ExtraBold';
  
 
TextStyle textstylesnormal() {
  return const TextStyle(
      fontSize: 16, fontFamily: raleway, color: Colors.black);
}

TextStyle textstylessmall() {
  return const TextStyle(
      fontSize: 13, fontFamily: raleway, color: Colors.blue);
}

TextStyle textstylesnormalopacity() {
  return TextStyle(
      fontSize: 16,
      fontFamily: raleway,
      color: Colors.black.withOpacity(.50));
}

TextStyle textstylesnormal1() {
  return const TextStyle(
      fontSize: 18, fontFamily: raleway, color: Colors.black);
}

TextStyle textstylesBold(BuildContext context) {
  return const TextStyle(
      fontSize: 16, fontFamily:ralewayBold, color: Colors.black);
}
}

double responsiveWidth(BuildContext context, double designWidth) {
  double screenWidth = MediaQuery.of(context).size.width;
  return (designWidth / 403) * screenWidth;
}

