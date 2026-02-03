import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFD4FF00); // Neon Green
  static const Color secondaryColor = Color(0xFF1E1F2A);
  static const Color darkBgColor = Color(0xFF0F1017);
  static const Color darkCardColor = Color(0xFF161721);
  static const Color textColor = Colors.white;
  static const Color textSecondaryColor = Colors.white54;
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Colors.greenAccent;

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkBgColor,
    primaryColor: primaryColor,
    cardColor: darkCardColor,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: textColor,
      displayColor: textColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBgColor,
      elevation: 0,
      centerTitle: false,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: primaryColor,
      surface: darkCardColor,
      error: errorColor,
    ),
  );
}
