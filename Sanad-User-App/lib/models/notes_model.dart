import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesStyle {
  

  // Define a list of card colors
  static List<Color> cardColors = [
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.grey.shade300,
  ];

  // Define text styles
  static TextStyle mainTitle = GoogleFonts.roboto(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mainContent = GoogleFonts.nunito(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static TextStyle dateTitle = GoogleFonts.roboto(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
  );
}