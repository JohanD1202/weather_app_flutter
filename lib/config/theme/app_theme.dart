import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData lightTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF2862f5),
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    )
  );

  ThemeData darkTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF2862f5),
    brightness: Brightness.dark,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    )
  );
}
