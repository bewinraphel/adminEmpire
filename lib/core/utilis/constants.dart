import 'package:flutter/material.dart';

class SharedpreferenceKey {
  static const String isLoggedIn = 'is_Logged_in';
}

String limitWords(String text, int maxWords) {
  final words = text.split(' ');
  if (words.length <= maxWords) return text;
  return words.sublist(0, maxWords).join(' ') + '...';
}

const double kDefaultPadding = 16.0;
const double kSmallSpacing = 8.0;
const double kMediumSpacing = 10.0;
const double kLargeSpacing = 20.0;

const BoxDecoration kCardDecoration = BoxDecoration(
  color: Color(0xFFE0E0E0),
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
  boxShadow: [
    BoxShadow(color: Colors.black12, offset: Offset(5, 5), blurRadius: 10),
    BoxShadow(color: Colors.white70, offset: Offset(-5, -5), blurRadius: 10),
  ],
);

const BoxDecoration kTagDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  boxShadow: [
    BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 4),
    BoxShadow(color: Colors.white70, offset: Offset(-2, -2), blurRadius: 4),
  ],
);

const BoxDecoration kButtonDecoration = BoxDecoration(
  color: Color(0xFFB0BEC5),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  boxShadow: [
    BoxShadow(color: Colors.black12, offset: Offset(4, 4), blurRadius: 8),
    BoxShadow(color: Colors.white70, offset: Offset(-4, -4), blurRadius: 8),
  ],
);

class Constants {
   static String landingImage = 'assets/landing.png';
}
