import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: AppColors.textColor,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColors.textColor,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.poppins(fontSize: 16),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
